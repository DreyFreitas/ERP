# Script de Conveniência - ERP Freitex
# Acesso rápido aos scripts organizados

param(
    [string]$Action = "help"
)

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Show-Help {
    Write-ColorOutput "ERP Freitex - Scripts Organizados" "Cyan"
    Write-ColorOutput "=====================================" "Cyan"
    Write-Host ""
    
    Write-ColorOutput "Comandos Disponiveis:" "Yellow"
    Write-Host ""
    
    Write-ColorOutput "DOCKER:" "Green"
    Write-ColorOutput "  start     - Iniciar ambiente completo" "White"
    Write-ColorOutput "  migrate   - Aplicar migracoes" "White"
    Write-ColorOutput "  safe      - Migracao segura com backup" "White"
    Write-Host ""
    
    Write-ColorOutput "DATABASE:" "Green"
    Write-ColorOutput "  backup    - Backup do banco de dados" "White"
    Write-ColorOutput "  restore   - Restore do banco de dados" "White"
    Write-Host ""
    
    Write-ColorOutput "DEPLOYMENT:" "Green"
    Write-ColorOutput "  update    - Atualizacao rapida das imagens" "White"
    Write-ColorOutput "  deploy    - Build e push completo" "White"
    Write-Host ""
    
    Write-ColorOutput "TESTING:" "Green"
    Write-ColorOutput "  test      - Testar imagens Docker Hub" "White"
    Write-ColorOutput "  print     - Teste de impressao" "White"
    Write-ColorOutput "  fix       - Diagnostico de impressoras" "White"
    Write-Host ""
    
    Write-ColorOutput "Exemplos:" "Yellow"
    Write-ColorOutput "  .\scripts\run.ps1 start" "White"
    Write-ColorOutput "  .\scripts\run.ps1 update" "White"
    Write-ColorOutput "  .\scripts\run.ps1 backup" "White"
    Write-Host ""
}

# Navegar para o diretório do projeto
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
Set-Location $projectRoot

switch ($Action.ToLower()) {
    "start" {
        Write-ColorOutput "Iniciando ambiente completo..." "Cyan"
        & ".\scripts\docker\start-with-migrations.ps1"
    }
    "migrate" {
        Write-ColorOutput "Aplicando migracoes..." "Cyan"
        & ".\scripts\docker\apply-migrations.ps1"
    }
    "safe" {
        Write-ColorOutput "Migracao segura com backup..." "Cyan"
        & ".\scripts\docker\safe-migration.ps1"
    }
    "backup" {
        Write-ColorOutput "Fazendo backup do banco..." "Cyan"
        & ".\scripts\database\backup-database.ps1"
    }
    "restore" {
        Write-ColorOutput "Restaurando banco de dados..." "Cyan"
        & ".\scripts\database\restore-database.ps1"
    }
    "update" {
        Write-ColorOutput "Atualizacao rapida das imagens..." "Cyan"
        & ".\scripts\deployment\quick-update.ps1"
    }
    "deploy" {
        Write-ColorOutput "Build e push completo..." "Cyan"
        & ".\scripts\deployment\build-and-push.ps1" -DockerUsername "dreyfreitas"
    }
    "test" {
        Write-ColorOutput "Testando imagens Docker Hub..." "Cyan"
        & ".\scripts\testing\test-docker-hub-images.ps1"
    }
    "print" {
        Write-ColorOutput "Teste de impressao..." "Cyan"
        & ".\scripts\testing\test-print-automated.ps1"
    }
    "fix" {
        Write-ColorOutput "Diagnostico de impressoras..." "Cyan"
        & ".\scripts\testing\fix-printer.ps1"
    }
    "help" {
        Show-Help
    }
    default {
        Write-ColorOutput "Comando nao reconhecido: $Action" "Red"
        Write-Host ""
        Show-Help
    }
}
