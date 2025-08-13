# Script PowerShell para gerenciar o ambiente Docker do ERP Freitex

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "logs", "build", "clean")]
    [string]$Action = "start"
)

Write-Host "🚀 ERP Freitex Softwares - Gerenciador Docker" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

switch ($Action) {
    "start" {
        Write-Host "📦 Iniciando todos os serviços..." -ForegroundColor Yellow
        docker-compose up -d
        Write-Host "✅ Serviços iniciados!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🌐 Acesse:" -ForegroundColor White
        Write-Host "   Frontend: http://localhost:7000" -ForegroundColor Green
        Write-Host "   Backend API: http://localhost:7001" -ForegroundColor Green
        Write-Host "   Adminer (DB): http://localhost:7004" -ForegroundColor Green
        Write-Host ""
        Write-Host "📊 Para ver os logs: docker-compose logs -f" -ForegroundColor Gray
    }
    "stop" {
        Write-Host "🛑 Parando todos os serviços..." -ForegroundColor Yellow
        docker-compose down
        Write-Host "✅ Serviços parados!" -ForegroundColor Green
    }
    "restart" {
        Write-Host "🔄 Reiniciando todos os serviços..." -ForegroundColor Yellow
        docker-compose down
        docker-compose up -d
        Write-Host "✅ Serviços reiniciados!" -ForegroundColor Green
    }
    "logs" {
        Write-Host "📋 Mostrando logs..." -ForegroundColor Yellow
        docker-compose logs -f
    }
    "build" {
        Write-Host "🔨 Reconstruindo imagens..." -ForegroundColor Yellow
        docker-compose build --no-cache
        Write-Host "✅ Imagens reconstruídas!" -ForegroundColor Green
    }
    "clean" {
        Write-Host "🧹 Limpando containers e volumes..." -ForegroundColor Yellow
        docker-compose down -v
        docker system prune -f
        Write-Host "✅ Limpeza concluída!" -ForegroundColor Green
    }
}

if (-not $Action) {
    Write-Host "❓ Uso: .\start.ps1 {start|stop|restart|logs|build|clean}" -ForegroundColor Red
    Write-Host ""
    Write-Host "Comandos disponíveis:" -ForegroundColor White
    Write-Host "  start   - Inicia todos os serviços" -ForegroundColor Gray
    Write-Host "  stop    - Para todos os serviços" -ForegroundColor Gray
    Write-Host "  restart - Reinicia todos os serviços" -ForegroundColor Gray
    Write-Host "  logs    - Mostra logs em tempo real" -ForegroundColor Gray
    Write-Host "  build   - Reconstrói as imagens" -ForegroundColor Gray
    Write-Host "  clean   - Limpa containers e volumes" -ForegroundColor Gray
}
