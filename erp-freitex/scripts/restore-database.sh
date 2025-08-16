#!/bin/bash

# Script de restore do banco de dados ERP Freitex
# Uso: ./restore-database.sh [arquivo_backup]

if [ -z "$1" ]; then
    echo "❌ Erro: Especifique o arquivo de backup!"
    echo "Uso: ./restore-database.sh [arquivo_backup]"
    exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Erro: Arquivo de backup não encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  ATENÇÃO: Esta operação irá substituir todos os dados atuais!"
echo "📁 Arquivo de backup: $BACKUP_FILE"
read -p "Tem certeza que deseja continuar? (s/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "❌ Operação cancelada pelo usuário."
    exit 1
fi

echo "🔄 Iniciando restore do banco de dados..."

# Fazer restore do banco de dados
docker compose exec -T postgres psql -U postgres -d erp_freitex < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Restore realizado com sucesso!"
    echo "🔄 Verificando integridade dos dados..."
    
    # Verificar se as tabelas principais têm dados
    docker compose exec postgres psql -U postgres -d erp_freitex -c "SELECT 'companies' as tabela, COUNT(*) as registros FROM companies UNION ALL SELECT 'users' as tabela, COUNT(*) as registros FROM users UNION ALL SELECT 'customers' as tabela, COUNT(*) as registros FROM customers;"
else
    echo "❌ Erro ao realizar restore!"
    exit 1
fi
