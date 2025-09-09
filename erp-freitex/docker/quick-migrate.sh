#!/bin/bash

# Script rápido para executar migrations
echo "🚀 Executando migrations..."

# Executar migrations
docker-compose exec backend npx prisma migrate deploy

# Gerar cliente
docker-compose exec backend npx prisma generate

# Verificar tabelas
echo "📋 Tabelas criadas:"
docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"

echo "✅ Pronto!"
