#!/bin/bash

# Script para verificar se as tabelas foram criadas corretamente

echo "🔍 Verificando tabelas do banco de dados ERP Freitex..."

# Verificar se o PostgreSQL está rodando
if ! docker-compose ps postgres | grep -q "Up"; then
    echo "❌ PostgreSQL não está rodando!"
    exit 1
fi

echo "📋 Listando todas as tabelas:"
docker-compose exec postgres psql -U postgres -d erp_freitex -c "\dt"

echo ""
echo "📊 Contando tabelas:"
TABLE_COUNT=$(docker-compose exec postgres psql -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | tr -d ' ')

echo "📈 Total de tabelas: $TABLE_COUNT"

if [ "$TABLE_COUNT" -gt 0 ]; then
    echo "✅ Tabelas encontradas!"
    
    echo ""
    echo "📋 Listando tabelas específicas do ERP:"
    docker-compose exec postgres psql -U postgres -d erp_freitex -c "
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name IN (
        'companies', 'users', 'categories', 'products', 'product_variations',
        'stock_movements', 'customers', 'sales', 'sale_items', 'sale_installments',
        'financial_accounts', 'financial_transactions', 'payment_methods', 
        'payment_terms', 'printers', 'backups', 'subscriptions'
    )
    ORDER BY table_name;"
    
    echo ""
    echo "🔧 Verificando extensões:"
    docker-compose exec postgres psql -U postgres -d erp_freitex -c "SELECT * FROM pg_extension;"
    
    echo ""
    echo "🎉 Banco de dados configurado corretamente!"
    
else
    echo "❌ Nenhuma tabela encontrada!"
    echo "💡 Execute o script run-migrations.sh para criar as tabelas"
    exit 1
fi
