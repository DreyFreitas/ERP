#!/bin/bash

# Script para executar migrations diretamente no container do backend
# Use este script se o run-migrations.sh não funcionar

echo "🚀 Executando migrations diretamente no container..."

# Verificar se o container do backend está rodando
BACKEND_CONTAINER=$(docker-compose ps -q backend)

if [ -z "$BACKEND_CONTAINER" ]; then
    echo "❌ Container do backend não encontrado. Iniciando..."
    docker-compose up -d backend
    sleep 15
    BACKEND_CONTAINER=$(docker-compose ps -q backend)
fi

if [ -z "$BACKEND_CONTAINER" ]; then
    echo "❌ Não foi possível iniciar o container do backend"
    exit 1
fi

echo "📦 Container do backend: $BACKEND_CONTAINER"

# Executar migrations
echo "📦 Executando migrations..."
docker exec $BACKEND_CONTAINER npx prisma migrate deploy

# Verificar resultado
if [ $? -eq 0 ]; then
    echo "✅ Migrations executadas com sucesso!"
    
    # Gerar cliente Prisma
    echo "🔧 Gerando cliente Prisma..."
    docker exec $BACKEND_CONTAINER npx prisma generate
    
    # Executar seed se existir
    echo "🌱 Verificando seed..."
    docker exec $BACKEND_CONTAINER sh -c "if [ -f prisma/seed.js ] || [ -f prisma/seed.ts ]; then npx prisma db seed; fi"
    
    echo "🎉 Processo concluído!"
    
    # Verificar tabelas
    echo "📋 Verificando tabelas criadas..."
    docker exec $(docker-compose ps -q postgres) psql -U postgres -d erp_freitex -c "\dt"
    
else
    echo "❌ Erro ao executar migrations!"
    echo "📋 Logs do container:"
    docker logs $BACKEND_CONTAINER --tail=20
    exit 1
fi
