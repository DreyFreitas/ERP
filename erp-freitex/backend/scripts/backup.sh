#!/bin/bash

# Script de backup automático do banco de dados
# Uso: ./scripts/backup.sh

# Configurações
DB_HOST="localhost"
DB_PORT="7002"
DB_NAME="erp_freitex"
DB_USER="postgres"
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.sql"

# Criar diretório de backup se não existir
mkdir -p $BACKUP_DIR

echo "🔄 Iniciando backup do banco de dados..."
echo "📁 Arquivo: $BACKUP_FILE"

# Fazer backup
PGPASSWORD=postgres pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "✅ Backup concluído com sucesso!"
    echo "📊 Tamanho do arquivo: $(du -h $BACKUP_FILE | cut -f1)"
    
    # Manter apenas os últimos 10 backups
    ls -t $BACKUP_DIR/backup_*.sql | tail -n +11 | xargs -r rm
    
    echo "🧹 Backups antigos removidos (mantidos os últimos 10)"
else
    echo "❌ Erro ao fazer backup!"
    exit 1
fi
