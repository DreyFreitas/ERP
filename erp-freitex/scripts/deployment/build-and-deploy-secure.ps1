# Script de build e deploy seguro para ERP Freitex (PowerShell)
# Resolve o problema de criação de tabelas no Portainer

param(
    [switch]$Force,
    [switch]$SkipPull
)

# Configurar para parar em caso de erro
$ErrorActionPreference = "Stop"

Write-Host "🚀 Iniciando build e deploy seguro do ERP Freitex..." -ForegroundColor Blue

# Função para log colorido
function Write-Log {
    param([string]$Message)
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Verificar se estamos no diretório correto
if (-not (Test-Path "docker/docker-compose.yml")) {
    Write-Error "Execute este script a partir da raiz do projeto (erp-freitex/)"
    exit 1
}

# Verificar se Docker está rodando
try {
    docker info | Out-Null
} catch {
    Write-Error "Docker não está rodando. Inicie o Docker e tente novamente."
    exit 1
}

Write-Log "🔍 Verificando configurações..."

# Verificar se as imagens existem
Write-Log "📦 Verificando imagens Docker..."
$backendImage = docker images | Select-String "dreyfreitas/erp-freitex-backend"
$frontendImage = docker images | Select-String "dreyfreitas/erp-freitex-frontend"
$nginxImage = docker images | Select-String "dreyfreitas/erp-freitex-nginx"

if (-not $backendImage) {
    Write-Warning "Imagem backend não encontrada. Será necessário fazer build."
}

if (-not $frontendImage) {
    Write-Warning "Imagem frontend não encontrada. Será necessário fazer build."
}

if (-not $nginxImage) {
    Write-Warning "Imagem nginx não encontrada. Será necessário fazer build."
}

# Parar containers existentes
Write-Log "🛑 Parando containers existentes..."
docker-compose -f docker/docker-compose.yml down --remove-orphans

# Fazer pull das imagens mais recentes (se não for pulado)
if (-not $SkipPull) {
    Write-Log "📥 Fazendo pull das imagens mais recentes..."
    docker-compose -f docker/docker-compose.yml pull
}

# Iniciar PostgreSQL primeiro
Write-Log "🗄️  Iniciando PostgreSQL..."
docker-compose -f docker/docker-compose.yml up -d postgres

# Aguardar PostgreSQL estar pronto
Write-Log "⏳ Aguardando PostgreSQL estar disponível..."
$maxAttempts = 30
$attempt = 1

do {
    try {
        $result = docker-compose -f docker/docker-compose.yml exec -T postgres pg_isready -U postgres -d erp_freitex 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "PostgreSQL está disponível!"
            break
        }
    } catch {
        # Ignorar erro e continuar
    }
    
    Write-Host "⏳ Tentativa $attempt/$maxAttempts - PostgreSQL não está disponível ainda..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    $attempt++
} while ($attempt -le $maxAttempts)

if ($attempt -gt $maxAttempts) {
    Write-Error "Timeout aguardando PostgreSQL!"
    exit 1
}

# Iniciar Redis
Write-Log "🔄 Iniciando Redis..."
docker-compose -f docker/docker-compose.yml up -d redis

# Aguardar Redis estar pronto
Write-Log "⏳ Aguardando Redis estar disponível..."
Start-Sleep -Seconds 5

# Iniciar backend
Write-Log "🔧 Iniciando backend..."
docker-compose -f docker/docker-compose.yml up -d backend

# Aguardar backend estar pronto
Write-Log "⏳ Aguardando backend estar disponível..."
$maxAttempts = 60
$attempt = 1

do {
    try {
        $result = docker-compose -f docker/docker-compose.yml exec -T backend curl -f http://localhost:7001/health 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Backend está disponível!"
            break
        }
    } catch {
        # Ignorar erro e continuar
    }
    
    Write-Host "⏳ Tentativa $attempt/$maxAttempts - Backend não está disponível ainda..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    $attempt++
} while ($attempt -le $maxAttempts)

if ($attempt -gt $maxAttempts) {
    Write-Error "Timeout aguardando backend!"
    Write-Log "📋 Logs do backend:"
    docker-compose -f docker/docker-compose.yml logs --tail=20 backend
    exit 1
}

# Verificar se as tabelas foram criadas
Write-Log "📋 Verificando se as tabelas foram criadas..."
try {
    $tableCount = docker-compose -f docker/docker-compose.yml exec -T postgres psql -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>$null
    $tableCount = $tableCount.Trim()
    
    if ($tableCount -and [int]$tableCount -gt 0) {
        Write-Success "$tableCount tabelas criadas com sucesso!"
    } else {
        Write-Warning "Nenhuma tabela encontrada. Verificando logs..."
        docker-compose -f docker/docker-compose.yml logs --tail=20 backend
    }
} catch {
    Write-Warning "Erro ao verificar tabelas: $_"
}

# Iniciar frontend
Write-Log "🎨 Iniciando frontend..."
docker-compose -f docker/docker-compose.yml up -d frontend

# Iniciar nginx
Write-Log "🌐 Iniciando nginx..."
docker-compose -f docker/docker-compose.yml up -d nginx

# Iniciar adminer
Write-Log "🗄️  Iniciando Adminer..."
docker-compose -f docker/docker-compose.yml up -d adminer

# Verificar status final
Write-Log "📊 Verificando status dos serviços..."
docker-compose -f docker/docker-compose.yml ps

# Verificar saúde dos serviços
Write-Log "🏥 Verificando saúde dos serviços..."

# Backend
try {
    $result = docker-compose -f docker/docker-compose.yml exec -T backend curl -f http://localhost:7001/health 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Backend: ✅ Saudável"
    } else {
        Write-Warning "Backend: ⚠️  Problemas de saúde"
    }
} catch {
    Write-Warning "Backend: ⚠️  Problemas de saúde"
}

# Frontend
try {
    $result = docker-compose -f docker/docker-compose.yml exec -T nginx curl -f http://localhost:80 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Frontend: ✅ Saudável"
    } else {
        Write-Warning "Frontend: ⚠️  Problemas de saúde"
    }
} catch {
    Write-Warning "Frontend: ⚠️  Problemas de saúde"
}

# PostgreSQL
try {
    $result = docker-compose -f docker/docker-compose.yml exec -T postgres pg_isready -U postgres -d erp_freitex 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "PostgreSQL: ✅ Saudável"
    } else {
        Write-Warning "PostgreSQL: ⚠️  Problemas de saúde"
    }
} catch {
    Write-Warning "PostgreSQL: ⚠️  Problemas de saúde"
}

# Mostrar URLs de acesso
Write-Host ""
Write-Host "🎉 Deploy concluído com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 URLs de acesso:" -ForegroundColor Cyan
Write-Host "🌐 Sistema ERP: http://localhost:7000" -ForegroundColor White
Write-Host "🗄️  Adminer: http://localhost:7004" -ForegroundColor White
Write-Host ""
Write-Host "📊 Status dos serviços:" -ForegroundColor Cyan
docker-compose -f docker/docker-compose.yml ps
Write-Host ""
Write-Host "📋 Para ver logs em tempo real:" -ForegroundColor Cyan
Write-Host "docker-compose -f docker/docker-compose.yml logs -f" -ForegroundColor White
Write-Host ""
Write-Host "🛑 Para parar os serviços:" -ForegroundColor Cyan
Write-Host "docker-compose -f docker/docker-compose.yml down" -ForegroundColor White
Write-Host ""

Write-Success "Deploy concluído! Sistema pronto para uso."
