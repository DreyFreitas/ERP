#!/bin/bash

# Script para executar migrations no Portainer
# Execute este script na VM onde o Portainer está rodando

echo "🚀 Executando migrations no Portainer..."

# Verificar se o container do backend está rodando
BACKEND_CONTAINER=$(docker ps --filter "name=erp-freitex-backend" --format "{{.Names}}")

if [ -z "$BACKEND_CONTAINER" ]; then
    echo "❌ Container do backend não encontrado!"
    echo "📋 Containers rodando:"
    docker ps --filter "name=erp-freitex"
    exit 1
fi

echo "📦 Container encontrado: $BACKEND_CONTAINER"

# Executar migrations
echo "📦 Executando migrations..."
docker exec $BACKEND_CONTAINER npx prisma migrate deploy

if [ $? -eq 0 ]; then
    echo "✅ Migrations executadas com sucesso!"
else
    echo "❌ Erro ao executar migrations!"
    exit 1
fi

# Gerar cliente Prisma
echo "🔧 Gerando cliente Prisma..."
docker exec $BACKEND_CONTAINER npx prisma generate

if [ $? -eq 0 ]; then
    echo "✅ Cliente Prisma gerado com sucesso!"
else
    echo "❌ Erro ao gerar cliente Prisma!"
    exit 1
fi

# Verificar tabelas
echo "📋 Verificando tabelas criadas..."
POSTGRES_CONTAINER=$(docker ps --filter "name=erp-freitex-postgres" --format "{{.Names}}")

if [ -n "$POSTGRES_CONTAINER" ]; then
    docker exec $POSTGRES_CONTAINER psql -U postgres -d erp_freitex -c "\dt"
else
    echo "⚠️  Container do PostgreSQL não encontrado para verificação"
fi

echo "🎉 Processo concluído!"
echo "🌐 Sistema pronto para uso!"
