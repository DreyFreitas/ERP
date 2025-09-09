#!/bin/bash

# Script de inicialização automática para Portainer
# Executa migrations e inicia o servidor automaticamente

echo "🚀 Iniciando backend ERP Freitex no Portainer..."

# Função para configurar variáveis de ambiente
setup_environment() {
    echo "🔧 Configurando variáveis de ambiente..."
    
    # Criar arquivo .env com variáveis de ambiente do Docker
    cat > .env << EOF
DATABASE_URL="${DATABASE_URL}"
JWT_SECRET="${JWT_SECRET}"
PORT="${PORT:-7001}"
NODE_ENV="${NODE_ENV:-production}"
UPLOAD_DIR="${UPLOAD_DIR:-uploads}"
MAX_FILE_SIZE="${MAX_FILE_SIZE:-10485760}"
BACKUP_DIR="${BACKUP_DIR:-backups}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"
REDIS_URL="${REDIS_URL:-redis://redis:6379}"
LOG_LEVEL="${LOG_LEVEL:-info}"
EOF
    
    echo "✅ Variáveis de ambiente configuradas com sucesso!"
}

# Função para aguardar PostgreSQL
wait_for_postgres() {
    echo "⏳ Aguardando PostgreSQL estar disponível..."
    local max_attempts=60
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        # Tentar conectar usando psql diretamente
        if PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -c "SELECT 1;" >/dev/null 2>&1; then
            echo "✅ PostgreSQL está disponível!"
            return 0
        fi
        
        echo "⏳ Tentativa $attempt/$max_attempts - PostgreSQL não está disponível ainda..."
        sleep 3
        attempt=$((attempt + 1))
    done
    
    echo "❌ Timeout aguardando PostgreSQL!"
    return 1
}

# Função para executar migrations
run_migrations() {
    echo "📦 Executando migrations do Prisma..."
    
    # Verificar se existem migrations pendentes
    echo "🔍 Verificando migrations pendentes..."
    if npx prisma migrate status >/dev/null 2>&1; then
        echo "📋 Status das migrations:"
        npx prisma migrate status
    fi
    
    # Executar migrations
    if npx prisma migrate deploy; then
        echo "✅ Migrations executadas com sucesso!"
        
        # Verificar se as tabelas foram criadas
        echo "📋 Verificando tabelas criadas..."
        local table_count=$(PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' \n\r')
        
        if [ -n "$table_count" ] && [ "$table_count" -gt 0 ]; then
            echo "✅ $table_count tabelas criadas com sucesso!"
        else
            echo "⚠️  Nenhuma tabela encontrada após migrations"
            echo "📋 Listando tabelas existentes:"
            PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -c "\dt" 2>/dev/null || echo "Erro ao listar tabelas"
        fi
        
        return 0
    else
        echo "❌ Erro ao executar migrations!"
        echo "📋 Tentando executar migrations com reset..."
        
        # Tentar reset e deploy em caso de erro
        if npx prisma migrate reset --force; then
            echo "✅ Migrations resetadas e executadas com sucesso!"
            return 0
        else
            echo "❌ Erro ao resetar migrations!"
            return 1
        fi
    fi
}

# Função para gerar cliente Prisma
generate_client() {
    echo "🔧 Gerando cliente Prisma..."
    
    if npx prisma generate; then
        echo "✅ Cliente Prisma gerado com sucesso!"
        return 0
    else
        echo "❌ Erro ao gerar cliente Prisma!"
        return 1
    fi
}

# Função para verificar tabelas
verify_tables() {
    echo "📋 Verificando tabelas criadas..."
    
    local table_count=$(PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' \n\r')
    
    if [ -n "$table_count" ] && [ "$table_count" -gt 0 ]; then
        echo "✅ $table_count tabelas encontradas!"
        echo "📋 Listando tabelas:"
        PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -c "\dt" 2>/dev/null || echo "Erro ao listar tabelas"
        return 0
    else
        echo "⚠️  Nenhuma tabela encontrada ou erro na verificação"
        echo "📋 Tentando listar tabelas diretamente:"
        PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -c "\dt" 2>/dev/null || echo "Erro ao listar tabelas"
        return 1
    fi
}

# Função para iniciar servidor
start_server() {
    echo "🌐 Iniciando servidor Node.js..."
    exec npm start
}

# Processo principal
main() {
    echo "🔍 Iniciando processo de inicialização..."
    
    # Configurar variáveis de ambiente
    setup_environment
    
    # Aguardar PostgreSQL
    if ! wait_for_postgres; then
        echo "❌ Falha ao conectar com PostgreSQL. Tentando continuar..."
    fi
    
    # Executar migrations
    if ! run_migrations; then
        echo "❌ Falha nas migrations. Tentando continuar..."
    fi
    
    # Gerar cliente Prisma
    if ! generate_client; then
        echo "❌ Falha ao gerar cliente Prisma. Tentando continuar..."
    fi
    
    # Verificar tabelas
    verify_tables
    
    # Verificar e criar tabela de backup se necessário
    echo "🔍 Verificando tabela de backups..."
    if [ -f "./scripts/ensure-backup-table.sql" ]; then
        echo "📋 Executando script de verificação da tabela backups..."
        if PGPASSWORD=postgres psql -h postgres -U postgres -d erp_freitex -f ./scripts/ensure-backup-table.sql; then
            echo "✅ Tabela de backups verificada/criada com sucesso!"
        else
            echo "❌ Erro ao verificar/criar tabela de backups"
        fi
    fi
    
    # Iniciar servidor
    echo "🎉 Iniciando servidor..."
    start_server
}

# Executar processo principal
main "$@"
