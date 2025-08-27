# Script completo para aplicar migrações no Docker

Write-Host "🚀 Iniciando processo de migração..." -ForegroundColor Green

# Verificar se o Docker está rodando
Write-Host "🔍 Verificando se o Docker está rodando..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    Write-Host "✅ Docker está rodando" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker não está rodando. Inicie o Docker primeiro." -ForegroundColor Red
    exit 1
}

# Verificar se os containers estão rodando
Write-Host "🔍 Verificando containers..." -ForegroundColor Yellow
$containers = docker-compose ps -q
if (-not $containers) {
    Write-Host "⚠️ Containers não estão rodando. Iniciando..." -ForegroundColor Yellow
    docker-compose up -d
    Start-Sleep -Seconds 10
}

# Aguardar o banco de dados estar pronto
Write-Host "⏳ Aguardando banco de dados estar pronto..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Executar migrações
Write-Host "📦 Aplicando migrações..." -ForegroundColor Cyan
try {
    docker-compose exec -T backend npx prisma migrate deploy
    Write-Host "✅ Migrações aplicadas com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao aplicar migrações" -ForegroundColor Red
    exit 1
}

# Gerar cliente Prisma
Write-Host "🔧 Gerando cliente Prisma..." -ForegroundColor Cyan
try {
    docker-compose exec -T backend npx prisma generate
    Write-Host "✅ Cliente Prisma gerado!" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao gerar cliente Prisma" -ForegroundColor Red
    exit 1
}

Write-Host "🎉 Processo de migração concluído com sucesso!" -ForegroundColor Green
