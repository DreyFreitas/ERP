#!/bin/bash

# Script para gerenciar containers Docker do ERP Freitex

case "$1" in
    start)
        echo "Iniciando containers..."
        docker-compose up -d
        ;;
    stop)
        echo "Parando containers..."
        docker-compose down
        ;;
    restart)
        echo "Reiniciando containers..."
        docker-compose down
        docker-compose up -d
        ;;
    logs)
        echo "Mostrando logs..."
        docker-compose logs -f
        ;;
    build)
        echo "Construindo imagens..."
        docker-compose build
        ;;
    clean)
        echo "Limpando containers e volumes..."
        docker-compose down -v
        docker system prune -f
        ;;
    *)
        echo "Uso: $0 {start|stop|restart|logs|build|clean}"
        echo ""
        echo "Comandos disponíveis:"
        echo "  start   - Inicia todos os containers"
        echo "  stop    - Para todos os containers"
        echo "  restart - Reinicia todos os containers"
        echo "  logs    - Mostra logs em tempo real"
        echo "  build   - Reconstrói as imagens"
        echo "  clean   - Remove containers e volumes"
        exit 1
        ;;
esac
