# Script para iniciar o ambiente Docker e aplicar migrações automaticamente
# Autor: ERP Freitex Softwares
# Data: 2025-08-21

Write-Host "🚀 Iniciando ambiente ERP Freitex Softwares..." -ForegroundColor Green

# Verificar se o Docker está rodando
try {
    docker version | Out-Null
    Write-Host "✅ Docker está rodando" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker não está rodando! Inicie o Docker Desktop primeiro." -ForegroundColor Red
    exit 1
}

# Navegar para o diretório do Docker
Set-Location "docker"

# Iniciar containers
Write-Host "📦 Iniciando containers Docker..." -ForegroundColor Yellow
try {
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Containers iniciados com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro ao iniciar containers!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erro ao executar docker-compose: $_" -ForegroundColor Red
    exit 1
}

# Aguardar inicialização dos containers
Write-Host "⏳ Aguardando inicialização dos containers..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Aplicar migrações
Write-Host "🔄 Aplicando migrações do banco de dados..." -ForegroundColor Cyan
try {
    docker exec docker-backend-1 npx prisma migrate deploy
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Migrações aplicadas com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro ao aplicar migrações!" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erro ao executar migrações: $_" -ForegroundColor Red
}

# Gerar cliente Prisma
Write-Host "🔧 Gerando cliente Prisma..." -ForegroundColor Cyan
try {
    docker exec docker-backend-1 npx prisma generate
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Cliente Prisma gerado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "❌ Erro ao gerar cliente Prisma!" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Erro ao gerar cliente: $_" -ForegroundColor Red
}

# Verificar status dos serviços
Write-Host "🔍 Verificando status dos serviços..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000" -Method GET -TimeoutSec 10 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Frontend está acessível em: http://localhost:7000" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Frontend ainda não está acessível" -ForegroundColor Yellow
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000/api/health" -Method GET -TimeoutSec 10 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend está funcionando corretamente!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Backend ainda não está respondendo" -ForegroundColor Yellow
}

Write-Host "🎉 Ambiente iniciado com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 URLs de acesso:" -ForegroundColor Cyan
Write-Host "   🌐 Frontend: http://localhost:7000" -ForegroundColor White
Write-Host "   🔧 Backend API: http://localhost:7000/api" -ForegroundColor White
Write-Host "   🗄️  Adminer (Banco): http://localhost:7004" -ForegroundColor White
Write-Host ""
Write-Host "💡 Comandos úteis:" -ForegroundColor Cyan
Write-Host "   📊 Ver logs: docker-compose logs -f" -ForegroundColor White
Write-Host "   🛑 Parar: docker-compose down" -ForegroundColor White
Write-Host "   🔄 Aplicar migrações: .\scripts\apply-migrations.ps1" -ForegroundColor White
