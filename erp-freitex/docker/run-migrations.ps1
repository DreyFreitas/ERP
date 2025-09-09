# Script PowerShell para executar migrations do Prisma no ERP Freitex
# Execute este script após o PostgreSQL estar funcionando

Write-Host "🚀 Iniciando execução das migrations do Prisma..." -ForegroundColor Green

# Verificar se o PostgreSQL está rodando
Write-Host "🔍 Verificando se o PostgreSQL está rodando..." -ForegroundColor Yellow
$postgresStatus = docker-compose ps postgres | Select-String "Up"
if (-not $postgresStatus) {
    Write-Host "❌ PostgreSQL não está rodando. Iniciando..." -ForegroundColor Red
    docker-compose up -d postgres
    Write-Host "⏳ Aguardando PostgreSQL inicializar..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
}

# Verificar se o backend está rodando
Write-Host "🔍 Verificando se o backend está rodando..." -ForegroundColor Yellow
$backendStatus = docker-compose ps backend | Select-String "Up"
if (-not $backendStatus) {
    Write-Host "❌ Backend não está rodando. Iniciando..." -ForegroundColor Red
    docker-compose up -d backend
    Write-Host "⏳ Aguardando backend inicializar..." -ForegroundColor Yellow
    Start-Sleep -Seconds 15
}

# Executar migrations no container do backend
Write-Host "📦 Executando migrations do Prisma..." -ForegroundColor Cyan
$migrationResult = docker-compose exec backend npx prisma migrate deploy

# Verificar se as migrations foram executadas com sucesso
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Migrations executadas com sucesso!" -ForegroundColor Green
    
    # Executar seed se existir
    Write-Host "🌱 Verificando se existe seed para executar..." -ForegroundColor Yellow
    $seedResult = docker-compose exec backend sh -c "if [ -f prisma/seed.js ] || [ -f prisma/seed.ts ]; then npx prisma db seed; fi"
    
    # Gerar cliente Prisma
    Write-Host "🔧 Gerando cliente Prisma..." -ForegroundColor Cyan
    docker-compose exec backend npx prisma generate
    
    Write-Host "🎉 Processo concluído com sucesso!" -ForegroundColor Green
    Write-Host "📋 Verificando tabelas criadas..." -ForegroundColor Yellow
    
    # Verificar tabelas criadas
    docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"
    
} else {
    Write-Host "❌ Erro ao executar migrations!" -ForegroundColor Red
    Write-Host "📋 Logs do backend:" -ForegroundColor Yellow
    docker-compose logs --tail=20 backend
    exit 1
}

Write-Host "🌐 Sistema pronto para uso!" -ForegroundColor Green
Write-Host "🔗 Acesse: http://localhost:7000" -ForegroundColor Cyan
Write-Host "🗄️  Adminer: http://localhost:7004" -ForegroundColor Cyan