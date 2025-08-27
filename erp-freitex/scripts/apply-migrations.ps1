# Script para aplicar migrações do Prisma no ambiente Docker
# Autor: ERP Freitex Softwares
# Data: 2025-08-21

Write-Host "Aplicando migrações do Prisma..." -ForegroundColor Yellow

# Verificar se o Docker está rodando
try {
    $containers = docker ps --format "table {{.Names}}" | Select-String "docker-backend-1"
    if (-not $containers) {
        Write-Host "ERRO: Container docker-backend-1 não está rodando!" -ForegroundColor Red
        Write-Host "DICA: Execute 'docker-compose up -d' primeiro" -ForegroundColor Cyan
        exit 1
    }
} catch {
    Write-Host "ERRO: Docker não está rodando ou não está acessível!" -ForegroundColor Red
    exit 1
}

Write-Host "OK: Container encontrado. Aplicando migrações..." -ForegroundColor Green

# Aplicar migrações
Write-Host "Executando 'npx prisma migrate deploy'..." -ForegroundColor Cyan
try {
    docker exec docker-backend-1 npx prisma migrate deploy
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: Migrações aplicadas com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "ERRO: Erro ao aplicar migrações!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERRO: Erro ao executar migrações: $_" -ForegroundColor Red
    exit 1
}

# Gerar cliente Prisma
Write-Host "Gerando cliente Prisma..." -ForegroundColor Cyan
try {
    docker exec docker-backend-1 npx prisma generate
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: Cliente Prisma gerado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "ERRO: Erro ao gerar cliente Prisma!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERRO: Erro ao gerar cliente: $_" -ForegroundColor Red
    exit 1
}

# Reiniciar backend
Write-Host "Reiniciando container do backend..." -ForegroundColor Cyan
try {
    docker restart docker-backend-1
    Write-Host "OK: Backend reiniciado com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Erro ao reiniciar backend: $_" -ForegroundColor Red
    exit 1
}

# Aguardar inicialização
Write-Host "Aguardando inicialização do backend..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Verificar status
Write-Host "Verificando status do backend..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7000/api/health" -Method GET -TimeoutSec 10 -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Host "OK: Backend está funcionando corretamente!" -ForegroundColor Green
    } else {
        Write-Host "AVISO: Backend respondeu com status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "AVISO: Não foi possível verificar o status do backend: $_" -ForegroundColor Yellow
}

Write-Host "Processo concluído com sucesso!" -ForegroundColor Green
Write-Host "DICA: Execute este script sempre que fizer alteracoes no schema do Prisma" -ForegroundColor Cyan
