# Script de backup do banco de dados ERP Freitex (PowerShell)
# Uso: .\backup-database.ps1 [nome_do_backup]

param(
    [string]$BackupName = "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
)

$BackupDir = ".\backups"
$BackupFile = "$BackupDir\$BackupName.sql"

Write-Host "🔄 Iniciando backup do banco de dados..." -ForegroundColor Yellow
Write-Host "📁 Arquivo: $BackupFile" -ForegroundColor Cyan

# Criar diretório de backup se não existir
if (!(Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Fazer backup do banco de dados
try {
    docker compose exec -T postgres pg_dump -U postgres erp_freitex | Out-File -FilePath $BackupFile -Encoding UTF8
    
    if ($LASTEXITCODE -eq 0) {
        $fileSize = (Get-Item $BackupFile).Length
        $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
        
        Write-Host "✅ Backup realizado com sucesso!" -ForegroundColor Green
        Write-Host "📊 Tamanho do arquivo: $fileSizeMB MB" -ForegroundColor Cyan
        Write-Host "📍 Localização: $BackupFile" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Erro ao realizar backup!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Erro ao realizar backup: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
