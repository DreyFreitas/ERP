#!/bin/bash

# Script para build e push das imagens Docker para Docker Hub
# ERP Freitex Softwares

set -e

# Configurações
DOCKER_USERNAME="seu-username-aqui"  # ALTERE AQUI SEU USERNAME DO DOCKER HUB
PROJECT_NAME="erp-freitex"
VERSION="latest"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 ERP Freitex - Build e Push para Docker Hub${NC}"
echo -e "${BLUE}==============================================${NC}"

# Verificar se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker não está rodando. Por favor, inicie o Docker Desktop.${NC}"
    exit 1
fi

# Verificar se está logado no Docker Hub
if ! docker info | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  Você não está logado no Docker Hub.${NC}"
    echo -e "${YELLOW}   Execute: docker login${NC}"
    echo -e "${YELLOW}   E insira suas credenciais do Docker Hub.${NC}"
    read -p "Pressione Enter para continuar após fazer login..."
fi

# Verificar se o username foi configurado
if [ "$DOCKER_USERNAME" = "seu-username-aqui" ]; then
    echo -e "${RED}❌ Por favor, configure seu username do Docker Hub no script.${NC}"
    echo -e "${YELLOW}   Edite o arquivo e altere a variável DOCKER_USERNAME${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Username configurado: ${DOCKER_USERNAME}${NC}"

# Tags das imagens
FRONTEND_TAG="${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:${VERSION}"
BACKEND_TAG="${DOCKER_USERNAME}/${PROJECT_NAME}-backend:${VERSION}"
NGINX_TAG="${DOCKER_USERNAME}/${PROJECT_NAME}-nginx:${VERSION}"

echo -e "${BLUE}📦 Tags das imagens:${NC}"
echo -e "   Frontend: ${FRONTEND_TAG}"
echo -e "   Backend:  ${BACKEND_TAG}"
echo -e "   Nginx:    ${NGINX_TAG}"
echo ""

# Função para build
build_image() {
    local context=$1
    local dockerfile=$2
    local tag=$3
    local name=$4
    
    echo -e "${BLUE}🔨 Fazendo build da imagem ${name}...${NC}"
    echo -e "   Context: ${context}"
    echo -e "   Dockerfile: ${dockerfile}"
    echo -e "   Tag: ${tag}"
    
    if docker build -f "${dockerfile}" -t "${tag}" "${context}"; then
        echo -e "${GREEN}✅ Build da imagem ${name} concluído com sucesso!${NC}"
    else
        echo -e "${RED}❌ Erro no build da imagem ${name}${NC}"
        exit 1
    fi
    echo ""
}

# Função para push
push_image() {
    local tag=$1
    local name=$2
    
    echo -e "${BLUE}📤 Fazendo push da imagem ${name}...${NC}"
    echo -e "   Tag: ${tag}"
    
    if docker push "${tag}"; then
        echo -e "${GREEN}✅ Push da imagem ${name} concluído com sucesso!${NC}"
    else
        echo -e "${RED}❌ Erro no push da imagem ${name}${NC}"
        exit 1
    fi
    echo ""
}

# Navegar para o diretório do projeto
cd "$(dirname "$0")/.."

echo -e "${BLUE}📁 Diretório atual: $(pwd)${NC}"
echo ""

# Build das imagens
echo -e "${YELLOW}🔨 Iniciando build das imagens...${NC}"
echo ""

# Build Frontend
build_image "frontend" "docker/Dockerfile.frontend" "${FRONTEND_TAG}" "Frontend"

# Build Backend
build_image "backend" "docker/Dockerfile.backend" "${BACKEND_TAG}" "Backend"

# Build Nginx
build_image "docker" "docker/Dockerfile.nginx" "${NGINX_TAG}" "Nginx"

echo -e "${GREEN}🎉 Todos os builds concluídos com sucesso!${NC}"
echo ""

# Push das imagens
echo -e "${YELLOW}📤 Iniciando push das imagens...${NC}"
echo ""

# Push Frontend
push_image "${FRONTEND_TAG}" "Frontend"

# Push Backend
push_image "${BACKEND_TAG}" "Backend"

# Push Nginx
push_image "${NGINX_TAG}" "Nginx"

echo -e "${GREEN}🎉 Todas as imagens foram enviadas para o Docker Hub com sucesso!${NC}"
echo ""
echo -e "${BLUE}📋 Resumo das imagens:${NC}"
echo -e "   Frontend: ${FRONTEND_TAG}"
echo -e "   Backend:  ${BACKEND_TAG}"
echo -e "   Nginx:    ${NGINX_TAG}"
echo ""
echo -e "${YELLOW}💡 Próximos passos:${NC}"
echo -e "   1. Atualize o docker-compose.yml com as novas tags"
echo -e "   2. Teste as imagens em outro ambiente"
echo -e "   3. Configure CI/CD para builds automáticos"
echo ""
echo -e "${GREEN}✅ Processo concluído!${NC}"
