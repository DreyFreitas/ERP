# Script de migração segura do banco de dados ERP Freitex (PowerShell)
# Este script faz backup automático antes de qualquer migração

Write-Host "🛡️  MIGRAÇÃO SEGURA - ERP FREITEX" -ForegroundColor Magenta
Write-Host "==================================" -ForegroundColor Magenta

# Fazer backup automático antes da migração
Write-Host "🔄 Fazendo backup automático antes da migração..." -ForegroundColor Yellow
$BackupName = "pre_migration_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Executar script de backup
& ".\backup-database.ps1" $BackupName

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro no backup! Migração cancelada por segurança." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Backup realizado com sucesso!" -ForegroundColor Green
Write-Host ""

# Verificar se há dados importantes antes da migração
Write-Host "🔍 Verificando dados existentes..." -ForegroundColor Cyan
docker compose exec postgres psql -U postgres -d erp_freitex -c "
SELECT 
    'companies' as tabela, COUNT(*) as registros 
FROM companies 
UNION ALL 
SELECT 'users' as tabela, COUNT(*) as registros 
FROM users 
UNION ALL 
SELECT 'customers' as tabela, COUNT(*) as registros 
FROM customers 
UNION ALL 
SELECT 'products' as tabela, COUNT(*) as registros 
FROM products;
"

Write-Host ""
Write-Host "⚠️  ATENÇÃO: Você está prestes a executar uma migração do banco de dados!" -ForegroundColor Red
Write-Host "📁 Backup salvo como: $BackupName" -ForegroundColor Cyan

$confirmation = Read-Host "Deseja continuar com a migração? (s/N)"

if ($confirmation -ne "s" -and $confirmation -ne "S") {
    Write-Host "❌ Migração cancelada pelo usuário." -ForegroundColor Yellow
    Write-Host "💾 Backup mantido em: .\backups\$BackupName.sql" -ForegroundColor Cyan
    exit 1
}

Write-Host "🔄 Executando migração do Prisma..." -ForegroundColor Yellow

# Executar migração do Prisma
docker compose exec backend npx prisma migrate dev

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Migração concluída com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔍 Verificando integridade após migração..." -ForegroundColor Cyan
    
    # Verificar se os dados ainda estão intactos
    docker compose exec postgres psql -U postgres -d erp_freitex -c "
    SELECT 
        'companies' as tabela, COUNT(*) as registros 
    FROM companies 
    UNION ALL 
    SELECT 'users' as tabela, COUNT(*) as registros 
    FROM users 
    UNION ALL 
    SELECT 'customers' as tabela, COUNT(*) as registros 
    FROM customers 
    UNION ALL 
    SELECT 'products' as tabela, COUNT(*) as registros 
    FROM products;
    "
    
    Write-Host ""
    Write-Host "✅ Migração segura concluída!" -ForegroundColor Green
    Write-Host "💾 Backup disponível em: .\backups\$BackupName.sql" -ForegroundColor Cyan
} else {
    Write-Host "❌ Erro na migração!" -ForegroundColor Red
    Write-Host "🔄 Restaurando backup..." -ForegroundColor Yellow
    & ".\restore-database.ps1" ".\backups\$BackupName.sql"
    Write-Host "✅ Backup restaurado com sucesso!" -ForegroundColor Green
    exit 1
}
