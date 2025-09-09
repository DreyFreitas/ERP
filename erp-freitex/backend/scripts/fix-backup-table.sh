#!/bin/bash

# Script para verificar e criar a tabela de backups se necessário

echo "🔍 Verificando tabela de backups..."

# Verificar se a tabela existe
TABLE_EXISTS=$(PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'backups');" 2>/dev/null | tr -d ' \n\r')

if [ "$TABLE_EXISTS" = "t" ]; then
    echo "✅ Tabela 'backups' já existe!"
    
    # Verificar quantos backups existem
    BACKUP_COUNT=$(PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM backups;" 2>/dev/null | tr -d ' \n\r')
    echo "📊 Total de backups: $BACKUP_COUNT"
    
else
    echo "⚠️  Tabela 'backups' não existe. Criando..."
    
    # Criar a tabela
    PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -c "
    CREATE TABLE IF NOT EXISTS \"public\".\"backups\" (
        \"id\" TEXT NOT NULL,
        \"filename\" TEXT NOT NULL,
        \"filePath\" TEXT NOT NULL,
        \"size\" TEXT NOT NULL,
        \"status\" TEXT NOT NULL DEFAULT 'completed',
        \"type\" TEXT NOT NULL DEFAULT 'full',
        \"description\" TEXT,
        \"createdAt\" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        \"updatedAt\" TIMESTAMP(3) NOT NULL,
        CONSTRAINT \"backups_pkey\" PRIMARY KEY (\"id\")
    );" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Tabela 'backups' criada com sucesso!"
    else
        echo "❌ Erro ao criar tabela 'backups'!"
        exit 1
    fi
fi

echo "🎉 Verificação da tabela de backups concluída!"
