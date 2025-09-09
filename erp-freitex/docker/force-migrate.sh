#!/bin/bash

# Script alternativo para forçar execução das migrations
# Use este script se o migrate-database.sh não funcionar

echo "🚀 Forçando execução das migrations..."

# Parar todos os containers
echo "⏹️  Parando containers..."
docker-compose down

# Remover volumes problemáticos (CUIDADO: isso remove dados!)
echo "🗑️  Removendo volumes do PostgreSQL..."
docker volume rm erp-freitex_postgres_data 2>/dev/null || true

# Iniciar containers novamente
echo "🚀 Iniciando containers..."
docker-compose up -d

# Aguardar inicialização
echo "⏳ Aguardando inicialização..."
sleep 30

# Executar migrations
echo "📦 Executando migrations..."
docker-compose exec backend npx prisma migrate deploy

# Gerar cliente
echo "🔧 Gerando cliente Prisma..."
docker-compose exec backend npx prisma generate

# Verificar resultado
echo "📋 Verificando tabelas..."
docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"

echo "✅ Processo concluído!"
