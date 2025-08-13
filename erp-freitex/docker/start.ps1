# Script PowerShell para gerenciar containers Docker do ERP Freitex

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart", "logs", "build", "clean")]
    [string]$Action
)

switch ($Action) {
    "start" {
        Write-Host "Iniciando containers..." -ForegroundColor Green
        docker-compose up -d
    }
    "stop" {
        Write-Host "Parando containers..." -ForegroundColor Yellow
        docker-compose down
    }
    "restart" {
        Write-Host "Reiniciando containers..." -ForegroundColor Blue
        docker-compose down
        docker-compose up -d
    }
    "logs" {
        Write-Host "Mostrando logs..." -ForegroundColor Cyan
        docker-compose logs -f
    }
    "build" {
        Write-Host "Construindo imagens..." -ForegroundColor Magenta
        docker-compose build
    }
    "clean" {
        Write-Host "Limpando containers e volumes..." -ForegroundColor Red
        docker-compose down -v
        docker system prune -f
    }
}

if ($Action -eq $null) {
    Write-Host "Uso: .\start.ps1 {start|stop|restart|logs|build|clean}" -ForegroundColor White
    Write-Host ""
    Write-Host "Comandos disponíveis:" -ForegroundColor White
    Write-Host "  start   - Inicia todos os containers" -ForegroundColor Gray
    Write-Host "  stop    - Para todos os containers" -ForegroundColor Gray
    Write-Host "  restart - Reinicia todos os containers" -ForegroundColor Gray
    Write-Host "  logs    - Mostra logs em tempo real" -ForegroundColor Gray
    Write-Host "  build   - Reconstrói as imagens" -ForegroundColor Gray
    Write-Host "  clean   - Remove containers e volumes" -ForegroundColor Gray
}
