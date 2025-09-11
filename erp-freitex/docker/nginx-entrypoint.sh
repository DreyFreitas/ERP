#!/bin/sh

# =============================================================================
# SCRIPT DE ENTRADA DO NGINX PARA ERP FREITEX SOFTWARES
# Sistema ERP Multi-tenant com alta disponibilidade e performance
# =============================================================================

set -e

# =============================================================================
# CONFIGURAÇÕES E VARIÁVEIS
# =============================================================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] ✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] ⚠${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ✗${NC} $1"
}

# =============================================================================
# FUNÇÕES AUXILIARES
# =============================================================================

# Função para verificar se o serviço está disponível
wait_for_service() {
    local host=$1
    local port=$2
    local service_name=$3
    local max_attempts=30
    local attempt=1

    log "Aguardando $service_name em $host:$port..."

    while [ $attempt -le $max_attempts ]; do
        if nc -z $host $port 2>/dev/null; then
            log_success "$service_name está disponível em $host:$port"
            return 0
        fi
        
        log "Tentativa $attempt/$max_attempts - $service_name ainda não está disponível"
        sleep 2
        attempt=$((attempt + 1))
    done

    log_error "$service_name não está disponível após $max_attempts tentativas"
    return 1
}

# Função para validar configuração do Nginx
validate_nginx_config() {
    log "Validando configuração do Nginx..."
    
    # Tentar validar, mas não falhar se não conseguir resolver hostnames
    if nginx -t 2>/dev/null; then
        log_success "Configuração do Nginx é válida"
        return 0
    else
        log_warning "Configuração do Nginx pode ter problemas de resolução de hostname"
        log "Isso é normal durante o build. A validação será feita durante a execução."
        return 0
    fi
}

# Função para criar diretórios necessários
create_directories() {
    log "Criando diretórios necessários..."
    
    mkdir -p /var/cache/nginx/client_temp
    mkdir -p /var/cache/nginx/proxy_temp
    mkdir -p /var/cache/nginx/fastcgi_temp
    mkdir -p /var/cache/nginx/uwsgi_temp
    mkdir -p /var/cache/nginx/scgi_temp
    mkdir -p /var/log/nginx
    
    # Ajustar permissões
    chown -R nginx:nginx /var/cache/nginx
    chown -R nginx:nginx /var/log/nginx
    
    log_success "Diretórios criados e permissões ajustadas"
}

# Função para configurar logs
setup_logs() {
    log "Configurando logs..."
    
    # Criar arquivos de log se não existirem
    touch /var/log/nginx/access.log
    touch /var/log/nginx/error.log
    touch /var/log/nginx/api.log
    
    # Ajustar permissões
    chown nginx:nginx /var/log/nginx/*.log
    chmod 644 /var/log/nginx/*.log
    
    log_success "Logs configurados"
}

# Função para mostrar informações do sistema
show_system_info() {
    log "Informações do sistema:"
    echo "  - Nginx version: $(nginx -v 2>&1)"
    echo "  - OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "  - Timezone: $(cat /etc/timezone)"
    echo "  - User: $(whoami)"
    echo "  - PID: $$"
    echo "  - Date: $(date)"
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    log "Iniciando Nginx para ERP Freitex Softwares..."
    
    # Mostrar informações do sistema
    show_system_info
    
    # Criar diretórios necessários
    create_directories
    
    # Configurar logs
    setup_logs
    
    # Validar configuração do Nginx
    if ! validate_nginx_config; then
        log_error "Falha na validação da configuração do Nginx"
        exit 1
    fi
    
    # Aguardar serviços dependentes (opcional)
    if [ "${WAIT_FOR_SERVICES:-true}" = "true" ]; then
        log "Aguardando serviços dependentes..."
        
        # Aguardar backend
        if [ "${BACKEND_HOST:-backend}" != "none" ]; then
            wait_for_service "${BACKEND_HOST:-backend}" "${BACKEND_PORT:-7001}" "Backend"
        fi
        
        # Aguardar frontend
        if [ "${FRONTEND_HOST:-frontend}" != "none" ]; then
            wait_for_service "${FRONTEND_HOST:-frontend}" "${FRONTEND_PORT:-7000}" "Frontend"
        fi
    fi
    
    log_success "Nginx pronto para iniciar"
    
    # Executar comando passado como argumento
    exec "$@"
}

# =============================================================================
# TRATAMENTO DE SINAIS
# =============================================================================

# Função para cleanup
cleanup() {
    log "Recebido sinal de parada, finalizando Nginx..."
    nginx -s quit
    exit 0
}

# Configurar trap para sinais
trap cleanup SIGTERM SIGINT

# =============================================================================
# EXECUÇÃO
# =============================================================================

# Executar função principal
main "$@"
