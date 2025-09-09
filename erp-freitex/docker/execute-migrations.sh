#!/bin/bash

# Script simples para executar migrations do Prisma
# Execute este script na VM Linux

echo "🚀 Executando migrations do Prisma..."

# Verificar se os containers estão rodando
echo "🔍 Verificando containers..."
docker-compose ps

echo ""
echo "📦 Executando migrations no container do backend..."
docker-compose exec backend npx prisma migrate deploy

echo ""
echo "🔧 Gerando cliente Prisma..."
docker-compose exec backend npx prisma generate

echo ""
echo "📋 Verificando tabelas criadas..."
docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"

echo ""
echo "✅ Processo concluído!"
echo "🌐 Sistema pronto para uso!"
