# Script de restore do banco de dados ERP Freitex (PowerShell)
# Uso: .\restore-database.ps1 [arquivo_backup]

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

if (!(Test-Path $BackupFile)) {
    Write-Host "❌ Erro: Arquivo de backup não encontrado: $BackupFile" -ForegroundColor Red
    exit 1
}

Write-Host "⚠️  ATENÇÃO: Esta operação irá substituir todos os dados atuais!" -ForegroundColor Red
Write-Host "📁 Arquivo de backup: $BackupFile" -ForegroundColor Cyan

$confirmation = Read-Host "Tem certeza que deseja continuar? (s/N)"

if ($confirmation -ne "s" -and $confirmation -ne "S") {
    Write-Host "❌ Operação cancelada pelo usuário." -ForegroundColor Yellow
    exit 1
}

Write-Host "🔄 Iniciando restore do banco de dados..." -ForegroundColor Yellow

# Fazer restore do banco de dados
try {
    Get-Content $BackupFile | docker compose exec -T postgres psql -U postgres -d erp_freitex
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Restore realizado com sucesso!" -ForegroundColor Green
        Write-Host "🔄 Verificando integridade dos dados..." -ForegroundColor Cyan
        
        # Verificar se as tabelas principais têm dados
        docker compose exec postgres psql -U postgres -d erp_freitex -c "SELECT 'companies' as tabela, COUNT(*) as registros FROM companies UNION ALL SELECT 'users' as tabela, COUNT(*) as registros FROM users UNION ALL SELECT 'customers' as tabela, COUNT(*) as registros FROM customers;"
    } else {
        Write-Host "❌ Erro ao realizar restore!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erro ao realizar restore: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
