#!/bin/bash

# Script para executar migrations do Prisma no ERP Freitex
# Execute este script após o PostgreSQL estar funcionando

echo "🚀 Iniciando execução das migrations do Prisma..."

# Verificar se o PostgreSQL está rodando
echo "🔍 Verificando se o PostgreSQL está rodando..."
if ! docker-compose ps postgres | grep -q "Up"; then
    echo "❌ PostgreSQL não está rodando. Iniciando..."
    docker-compose up -d postgres
    echo "⏳ Aguardando PostgreSQL inicializar..."
    sleep 10
fi

# Verificar se o backend está rodando
echo "🔍 Verificando se o backend está rodando..."
if ! docker-compose ps backend | grep -q "Up"; then
    echo "❌ Backend não está rodando. Iniciando..."
    docker-compose up -d backend
    echo "⏳ Aguardando backend inicializar..."
    sleep 15
fi

# Executar migrations no container do backend
echo "📦 Executando migrations do Prisma..."
docker-compose exec backend npx prisma migrate deploy

# Verificar se as migrations foram executadas com sucesso
if [ $? -eq 0 ]; then
    echo "✅ Migrations executadas com sucesso!"
    
    # Executar seed se existir
    echo "🌱 Verificando se existe seed para executar..."
    if docker-compose exec backend test -f "prisma/seed.js" || docker-compose exec backend test -f "prisma/seed.ts"; then
        echo "🌱 Executando seed..."
        docker-compose exec backend npx prisma db seed
    fi
    
    # Gerar cliente Prisma
    echo "🔧 Gerando cliente Prisma..."
    docker-compose exec backend npx prisma generate
    
    echo "🎉 Processo concluído com sucesso!"
    echo "📋 Verificando tabelas criadas..."
    
    # Verificar tabelas criadas
    docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"
    
else
    echo "❌ Erro ao executar migrations!"
    echo "📋 Logs do backend:"
    docker-compose logs --tail=20 backend
    exit 1
fi

echo "🌐 Sistema pronto para uso!"
echo "🔗 Acesse: http://localhost:7000"
echo "🗄️  Adminer: http://localhost:7004"