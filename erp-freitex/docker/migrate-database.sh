#!/bin/bash

# Script para executar migrations do Prisma no servidor
# Execute este script na VM Linux onde o Docker está rodando

echo "🚀 Iniciando processo de criação das tabelas..."

# Verificar se estamos no diretório correto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Arquivo docker-compose.yml não encontrado!"
    echo "💡 Certifique-se de estar no diretório correto (erp-freitex/docker)"
    exit 1
fi

# Verificar status dos containers
echo "🔍 Verificando status dos containers..."
docker-compose ps

echo ""
echo "📦 Verificando se o backend está rodando..."
if ! docker-compose ps backend | grep -q "Up"; then
    echo "❌ Backend não está rodando. Iniciando..."
    docker-compose up -d backend
    echo "⏳ Aguardando backend inicializar..."
    sleep 20
fi

echo ""
echo "🔍 Verificando se o PostgreSQL está rodando..."
if ! docker-compose ps postgres | grep -q "Up"; then
    echo "❌ PostgreSQL não está rodando. Iniciando..."
    docker-compose up -d postgres
    echo "⏳ Aguardando PostgreSQL inicializar..."
    sleep 15
fi

echo ""
echo "📦 Executando migrations do Prisma..."
echo "⏳ Isso pode levar alguns minutos..."

# Executar migrations
if docker-compose exec backend npx prisma migrate deploy; then
    echo "✅ Migrations executadas com sucesso!"
else
    echo "❌ Erro ao executar migrations!"
    echo "📋 Logs do backend:"
    docker-compose logs --tail=30 backend
    exit 1
fi

echo ""
echo "🔧 Gerando cliente Prisma..."
if docker-compose exec backend npx prisma generate; then
    echo "✅ Cliente Prisma gerado com sucesso!"
else
    echo "❌ Erro ao gerar cliente Prisma!"
    exit 1
fi

echo ""
echo "📋 Verificando tabelas criadas..."
docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"

echo ""
echo "📊 Contando tabelas..."
TABLE_COUNT=$(docker-compose exec postgres psql -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')

if [ "$TABLE_COUNT" -gt 0 ]; then
    echo "🎉 Sucesso! $TABLE_COUNT tabelas foram criadas!"
    echo ""
    echo "🌐 Sistema pronto para uso!"
    echo "🔗 Acesse: http://localhost:7000"
    echo "🗄️  Adminer: http://localhost:7004"
    echo ""
    echo "📋 Tabelas criadas:"
    docker-compose exec postgres psql -U postgres -d erp_freitex -c "
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    ORDER BY table_name;"
else
    echo "❌ Nenhuma tabela foi criada!"
    echo "📋 Verificando logs do backend:"
    docker-compose logs --tail=20 backend
    exit 1
fi
