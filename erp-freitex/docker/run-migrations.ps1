# Script para executar migrações do Prisma no Docker

Write-Host "🚀 Executando migrações do Prisma..." -ForegroundColor Green

# Aguardar o banco de dados estar pronto
Write-Host "⏳ Aguardando banco de dados..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Executar migrações
Write-Host "📦 Aplicando migrações..." -ForegroundColor Cyan
docker-compose exec backend npx prisma migrate deploy

# Gerar cliente Prisma
Write-Host "🔧 Gerando cliente Prisma..." -ForegroundColor Cyan
docker-compose exec backend npx prisma generate

Write-Host "✅ Migrações concluídas!" -ForegroundColor Green
