#!/bin/bash

# Script de build e deploy seguro para ERP Freitex
# Resolve o problema de criação de tabelas no Portainer

set -e  # Parar em caso de erro

echo "🚀 Iniciando build e deploy seguro do ERP Freitex..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar se estamos no diretório correto
if [ ! -f "docker/docker-compose.yml" ]; then
    error "Execute este script a partir da raiz do projeto (erp-freitex/)"
    exit 1
fi

# Verificar se Docker está rodando
if ! docker info >/dev/null 2>&1; then
    error "Docker não está rodando. Inicie o Docker e tente novamente."
    exit 1
fi

log "🔍 Verificando configurações..."

# Verificar se as imagens existem
log "📦 Verificando imagens Docker..."
if ! docker images | grep -q "dreyfreitas/erp-freitex-backend"; then
    warning "Imagem backend não encontrada. Será necessário fazer build."
fi

if ! docker images | grep -q "dreyfreitas/erp-freitex-frontend"; then
    warning "Imagem frontend não encontrada. Será necessário fazer build."
fi

if ! docker images | grep -q "dreyfreitas/erp-freitex-nginx"; then
    warning "Imagem nginx não encontrada. Será necessário fazer build."
fi

# Parar containers existentes
log "🛑 Parando containers existentes..."
docker-compose -f docker/docker-compose.yml down --remove-orphans

# Remover volumes antigos (opcional - descomente se necessário)
# log "🗑️  Removendo volumes antigos..."
# docker volume rm erp-freitex_postgres_data erp-freitex_redis_data erp-freitex_uploads_data erp-freitex_backups_data 2>/dev/null || true

# Fazer pull das imagens mais recentes
log "📥 Fazendo pull das imagens mais recentes..."
docker-compose -f docker/docker-compose.yml pull

# Iniciar PostgreSQL primeiro
log "🗄️  Iniciando PostgreSQL..."
docker-compose -f docker/docker-compose.yml up -d postgres

# Aguardar PostgreSQL estar pronto
log "⏳ Aguardando PostgreSQL estar disponível..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if docker-compose -f docker/docker-compose.yml exec -T postgres pg_isready -U postgres -d erp_freitex >/dev/null 2>&1; then
        success "PostgreSQL está disponível!"
        break
    fi
    
    echo "⏳ Tentativa $attempt/$max_attempts - PostgreSQL não está disponível ainda..."
    sleep 3
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    error "Timeout aguardando PostgreSQL!"
    exit 1
fi

# Iniciar Redis
log "🔄 Iniciando Redis..."
docker-compose -f docker/docker-compose.yml up -d redis

# Aguardar Redis estar pronto
log "⏳ Aguardando Redis estar disponível..."
sleep 5

# Iniciar backend
log "🔧 Iniciando backend..."
docker-compose -f docker/docker-compose.yml up -d backend

# Aguardar backend estar pronto
log "⏳ Aguardando backend estar disponível..."
max_attempts=60
attempt=1

while [ $attempt -le $max_attempts ]; do
    if docker-compose -f docker/docker-compose.yml exec -T backend curl -f http://localhost:7001/health >/dev/null 2>&1; then
        success "Backend está disponível!"
        break
    fi
    
    echo "⏳ Tentativa $attempt/$max_attempts - Backend não está disponível ainda..."
    sleep 5
    attempt=$((attempt + 1))
done

if [ $attempt -gt $max_attempts ]; then
    error "Timeout aguardando backend!"
    log "📋 Logs do backend:"
    docker-compose -f docker/docker-compose.yml logs --tail=20 backend
    exit 1
fi

# Verificar se as tabelas foram criadas
log "📋 Verificando se as tabelas foram criadas..."
table_count=$(docker-compose -f docker/docker-compose.yml exec -T postgres psql -U postgres -d erp_freitex -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

if [ -n "$table_count" ] && [ "$table_count" -gt 0 ]; then
    success "$table_count tabelas criadas com sucesso!"
else
    warning "Nenhuma tabela encontrada. Verificando logs..."
    docker-compose -f docker/docker-compose.yml logs --tail=20 backend
fi

# Iniciar frontend
log "🎨 Iniciando frontend..."
docker-compose -f docker/docker-compose.yml up -d frontend

# Iniciar nginx
log "🌐 Iniciando nginx..."
docker-compose -f docker/docker-compose.yml up -d nginx

# Iniciar adminer
log "🗄️  Iniciando Adminer..."
docker-compose -f docker/docker-compose.yml up -d adminer

# Verificar status final
log "📊 Verificando status dos serviços..."
docker-compose -f docker/docker-compose.yml ps

# Verificar saúde dos serviços
log "🏥 Verificando saúde dos serviços..."

# Backend
if docker-compose -f docker/docker-compose.yml exec -T backend curl -f http://localhost:7001/health >/dev/null 2>&1; then
    success "Backend: ✅ Saudável"
else
    warning "Backend: ⚠️  Problemas de saúde"
fi

# Frontend
if docker-compose -f docker/docker-compose.yml exec -T nginx curl -f http://localhost:80 >/dev/null 2>&1; then
    success "Frontend: ✅ Saudável"
else
    warning "Frontend: ⚠️  Problemas de saúde"
fi

# PostgreSQL
if docker-compose -f docker/docker-compose.yml exec -T postgres pg_isready -U postgres -d erp_freitex >/dev/null 2>&1; then
    success "PostgreSQL: ✅ Saudável"
else
    warning "PostgreSQL: ⚠️  Problemas de saúde"
fi

# Mostrar URLs de acesso
echo ""
echo "🎉 Deploy concluído com sucesso!"
echo ""
echo "📋 URLs de acesso:"
echo "🌐 Sistema ERP: http://localhost:7000"
echo "🗄️  Adminer: http://localhost:7004"
echo ""
echo "📊 Status dos serviços:"
docker-compose -f docker/docker-compose.yml ps
echo ""
echo "📋 Para ver logs em tempo real:"
echo "docker-compose -f docker/docker-compose.yml logs -f"
echo ""
echo "🛑 Para parar os serviços:"
echo "docker-compose -f docker/docker-compose.yml down"
echo ""

success "Deploy concluído! Sistema pronto para uso."
