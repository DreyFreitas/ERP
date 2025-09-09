#!/bin/bash

# Script de diagnóstico para verificar o estado do sistema

echo "🔍 Diagnóstico do Sistema ERP Freitex"
echo "======================================"

echo ""
echo "📋 Status dos containers:"
docker-compose ps

echo ""
echo "🔍 Verificando conexão com PostgreSQL..."
if docker-compose exec postgres psql -U postgres -d erp_freitex -c "SELECT version();" >/dev/null 2>&1; then
    echo "✅ PostgreSQL está funcionando"
else
    echo "❌ PostgreSQL não está acessível"
fi

echo ""
echo "🔍 Verificando se o backend consegue conectar..."
if docker-compose exec backend npx prisma db pull --print >/dev/null 2>&1; then
    echo "✅ Backend consegue conectar no PostgreSQL"
else
    echo "❌ Backend não consegue conectar no PostgreSQL"
fi

echo ""
echo "📋 Verificando migrations pendentes..."
docker-compose exec backend npx prisma migrate status

echo ""
echo "📋 Logs do backend (últimas 10 linhas):"
docker-compose logs --tail=10 backend

echo ""
echo "📋 Logs do PostgreSQL (últimas 10 linhas):"
docker-compose logs --tail=10 postgres

echo ""
echo "🔍 Verificando arquivos de migration..."
docker-compose exec backend ls -la prisma/migrations/

echo ""
echo "📋 Verificando schema do Prisma..."
docker-compose exec backend cat prisma/schema.prisma | head -20

echo ""
echo "✅ Diagnóstico concluído!"
