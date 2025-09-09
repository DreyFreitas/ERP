#!/bin/bash

# Script para build e push das imagens com migrations automáticas

echo "🚀 Iniciando build e push das imagens..."

# Verificar se estamos no diretório correto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Arquivo docker-compose.yml não encontrado!"
    echo "💡 Certifique-se de estar no diretório erp-freitex/docker"
    exit 1
fi

# Build das imagens
echo "📦 Fazendo build das imagens..."
docker-compose build

if [ $? -eq 0 ]; then
    echo "✅ Build concluído com sucesso!"
else
    echo "❌ Erro no build das imagens!"
    exit 1
fi

# Push para Docker Hub
echo "📤 Fazendo push para Docker Hub..."
docker-compose push

if [ $? -eq 0 ]; then
    echo "✅ Push concluído com sucesso!"
    echo ""
    echo "🎉 Imagens atualizadas no Docker Hub!"
    echo "📋 Imagens disponíveis:"
    echo "   - dreyfreitas/erp-freitex-frontend:latest"
    echo "   - dreyfreitas/erp-freitex-backend:latest"
    echo "   - dreyfreitas/erp-freitex-nginx:latest"
    echo ""
    echo "🚀 Para usar no servidor:"
    echo "   1. Faça pull das imagens: docker-compose pull"
    echo "   2. Inicie os containers: docker-compose up -d"
    echo "   3. As migrations serão executadas automaticamente!"
else
    echo "❌ Erro no push para Docker Hub!"
    exit 1
fi
