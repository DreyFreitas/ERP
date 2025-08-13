#!/bin/bash

# Script para gerenciar o ambiente Docker do ERP Freitex

echo "🚀 ERP Freitex Softwares - Gerenciador Docker"
echo "=============================================="

case "$1" in
    "start")
        echo "📦 Iniciando todos os serviços..."
        docker-compose up -d
        echo "✅ Serviços iniciados!"
        echo ""
        echo "🌐 Acesse:"
        echo "   Frontend: http://localhost:7000"
        echo "   Backend API: http://localhost:7001"
        echo "   Adminer (DB): http://localhost:7004"
        echo ""
        echo "📊 Para ver os logs: docker-compose logs -f"
        ;;
    "stop")
        echo "🛑 Parando todos os serviços..."
        docker-compose down
        echo "✅ Serviços parados!"
        ;;
    "restart")
        echo "🔄 Reiniciando todos os serviços..."
        docker-compose down
        docker-compose up -d
        echo "✅ Serviços reiniciados!"
        ;;
    "logs")
        echo "📋 Mostrando logs..."
        docker-compose logs -f
        ;;
    "build")
        echo "🔨 Reconstruindo imagens..."
        docker-compose build --no-cache
        echo "✅ Imagens reconstruídas!"
        ;;
    "clean")
        echo "🧹 Limpando containers e volumes..."
        docker-compose down -v
        docker system prune -f
        echo "✅ Limpeza concluída!"
        ;;
    *)
        echo "❓ Uso: $0 {start|stop|restart|logs|build|clean}"
        echo ""
        echo "Comandos disponíveis:"
        echo "  start   - Inicia todos os serviços"
        echo "  stop    - Para todos os serviços"
        echo "  restart - Reinicia todos os serviços"
        echo "  logs    - Mostra logs em tempo real"
        echo "  build   - Reconstrói as imagens"
        echo "  clean   - Limpa containers e volumes"
        ;;
esac
