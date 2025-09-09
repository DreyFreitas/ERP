#!/bin/bash

# Script de migração segura do banco de dados ERP Freitex
# Este script faz backup automático antes de qualquer migração

echo "🛡️  MIGRAÇÃO SEGURA - ERP FREITEX"
echo "=================================="

# Fazer backup automático antes da migração
echo "🔄 Fazendo backup automático antes da migração..."
BACKUP_NAME="pre_migration_$(date +%Y%m%d_%H%M%S)"
./backup-database.sh "$BACKUP_NAME"

if [ $? -ne 0 ]; then
    echo "❌ Erro no backup! Migração cancelada por segurança."
    exit 1
fi

echo "✅ Backup realizado com sucesso!"
echo ""

# Verificar se há dados importantes antes da migração
echo "🔍 Verificando dados existentes..."
docker compose exec postgres psql -U postgres -d erp_freitex -c "
SELECT 
    'companies' as tabela, COUNT(*) as registros 
FROM companies 
UNION ALL 
SELECT 'users' as tabela, COUNT(*) as registros 
FROM users 
UNION ALL 
SELECT 'customers' as tabela, COUNT(*) as registros 
FROM customers 
UNION ALL 
SELECT 'products' as tabela, COUNT(*) as registros 
FROM products;
"

echo ""
echo "⚠️  ATENÇÃO: Você está prestes a executar uma migração do banco de dados!"
echo "📁 Backup salvo como: $BACKUP_NAME"
read -p "Deseja continuar com a migração? (s/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "❌ Migração cancelada pelo usuário."
    echo "💾 Backup mantido em: ./backups/$BACKUP_NAME.sql"
    exit 1
fi

echo "🔄 Executando migração do Prisma..."

# Executar migração do Prisma
docker compose exec backend npx prisma migrate dev

if [ $? -eq 0 ]; then
    echo "✅ Migração concluída com sucesso!"
    echo ""
    echo "🔍 Verificando integridade após migração..."
    
    # Verificar se os dados ainda estão intactos
    docker compose exec postgres psql -U postgres -d erp_freitex -c "
    SELECT 
        'companies' as tabela, COUNT(*) as registros 
    FROM companies 
    UNION ALL 
    SELECT 'users' as tabela, COUNT(*) as registros 
    FROM users 
    UNION ALL 
    SELECT 'customers' as tabela, COUNT(*) as registros 
    FROM customers 
    UNION ALL 
    SELECT 'products' as tabela, COUNT(*) as registros 
    FROM products;
    "
    
    echo ""
    echo "✅ Migração segura concluída!"
    echo "💾 Backup disponível em: ./backups/$BACKUP_NAME.sql"
else
    echo "❌ Erro na migração!"
    echo "🔄 Restaurando backup..."
    ./restore-database.sh "./backups/$BACKUP_NAME.sql"
    echo "✅ Backup restaurado com sucesso!"
    exit 1
fi
