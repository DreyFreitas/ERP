#!/bin/bash

# Script de backup do banco de dados ERP Freitex
# Uso: ./backup-database.sh [nome_do_backup]

BACKUP_NAME=${1:-"backup_$(date +%Y%m%d_%H%M%S)"}
BACKUP_DIR="./backups"
BACKUP_FILE="$BACKUP_DIR/$BACKUP_NAME.sql"

echo "🔄 Iniciando backup do banco de dados..."
echo "📁 Arquivo: $BACKUP_FILE"

# Criar diretório de backup se não existir
mkdir -p "$BACKUP_DIR"

# Fazer backup do banco de dados
docker compose exec -T postgres pg_dump -U postgres erp_freitex > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Backup realizado com sucesso!"
    echo "📊 Tamanho do arquivo: $(du -h "$BACKUP_FILE" | cut -f1)"
    echo "📍 Localização: $BACKUP_FILE"
else
    echo "❌ Erro ao realizar backup!"
    exit 1
fi
