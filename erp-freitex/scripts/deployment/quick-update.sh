#!/bin/bash

# Script de Atualização Rápida - ERP Freitex
# Use este script quando fizer pequenas alterações

set -e

# Configurações
DOCKER_USERNAME="dreyfreitas"
PROJECT_NAME="erp-freitex"
VERSION="latest"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Atualização Rápida - ERP Freitex${NC}"
echo -e "${BLUE}===================================${NC}"

# Verificar parâmetros
UPDATE_FRONTEND=true
UPDATE_BACKEND=true
UPDATE_NGINX=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --frontend-only)
            UPDATE_FRONTEND=true
            UPDATE_BACKEND=false
            UPDATE_NGINX=false
            shift
            ;;
        --backend-only)
            UPDATE_FRONTEND=false
            UPDATE_BACKEND=true
            UPDATE_NGINX=false
            shift
            ;;
        --nginx-only)
            UPDATE_FRONTEND=false
            UPDATE_BACKEND=false
            UPDATE_NGINX=true
            shift
            ;;
        --version)
            VERSION="$2"
            shift 2
            ;;
        *)
            echo "Uso: $0 [--frontend-only|--backend-only|--nginx-only] [--version VERSION]"
            exit 1
            ;;
    esac
done

echo -e "${GREEN}Username: ${DOCKER_USERNAME}${NC}"
echo -e "${GREEN}Versão: ${VERSION}${NC}"
echo ""

# Tags das imagens
FRONTEND_TAG="${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:${VERSION}"
BACKEND_TAG="${DOCKER_USERNAME}/${PROJECT_NAME}-backend:${VERSION}"
NGINX_TAG="${DOCKER_USERNAME}/${PROJECT_NAME}-nginx:${VERSION}"

# Função para build e push rápido
update_image() {
    local context=$1
    local dockerfile=$2
    local tag=$3
    local name=$4
    
    echo -e "${YELLOW}🔄 Atualizando ${name}...${NC}"
    
    # Build
    echo -e "${BLUE}   📦 Fazendo build...${NC}"
    if docker build -f "${dockerfile}" -t "${tag}" "${context}"; then
        echo -e "${GREEN}   ✅ Build concluído${NC}"
        
        # Push
        echo -e "${BLUE}   📤 Fazendo push...${NC}"
        if docker push "${tag}"; then
            echo -e "${GREEN}   ✅ Push concluído${NC}"
        else
            echo -e "${RED}   ❌ Erro no push${NC}"
            return 1
        fi
    else
        echo -e "${RED}   ❌ Erro no build${NC}"
        return 1
    fi
    
    echo ""
    return 0
}

# Navegar para o diretório do projeto
cd "$(dirname "$0")/.."

SUCCESS=true

# Atualizar Frontend
if [ "$UPDATE_FRONTEND" = true ]; then
    if ! update_image "frontend" "docker/Dockerfile.frontend" "${FRONTEND_TAG}" "Frontend"; then
        SUCCESS=false
    fi
fi

# Atualizar Backend
if [ "$UPDATE_BACKEND" = true ]; then
    if ! update_image "backend" "docker/Dockerfile.backend" "${BACKEND_TAG}" "Backend"; then
        SUCCESS=false
    fi
fi

# Atualizar Nginx
if [ "$UPDATE_NGINX" = true ]; then
    if ! update_image "docker" "docker/Dockerfile.nginx" "${NGINX_TAG}" "Nginx"; then
        SUCCESS=false
    fi
fi

# Resultado final
if [ "$SUCCESS" = true ]; then
    echo -e "${GREEN}🎉 Atualização concluída com sucesso!${NC}"
    echo ""
    echo -e "${BLUE}📋 Imagens atualizadas:${NC}"
    if [ "$UPDATE_FRONTEND" = true ]; then echo -e "   Frontend: ${FRONTEND_TAG}"; fi
    if [ "$UPDATE_BACKEND" = true ]; then echo -e "   Backend:  ${BACKEND_TAG}"; fi
    if [ "$UPDATE_NGINX" = true ]; then echo -e "   Nginx:    ${NGINX_TAG}"; fi
else
    echo -e "${RED}❌ Algumas atualizações falharam${NC}"
fi

echo ""
echo -e "${YELLOW}💡 Dica: Use --frontend-only, --backend-only ou --nginx-only para atualizar apenas um serviço${NC}"
