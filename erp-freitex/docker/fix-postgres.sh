#!/bin/bash

# Script para corrigir problemas do PostgreSQL no ERP Freitex
# Execute este script se o PostgreSQL não estiver funcionando corretamente

echo "🔧 Iniciando correção do PostgreSQL..."

# Parar o container do PostgreSQL
echo "⏹️  Parando container PostgreSQL..."
docker-compose stop postgres

# Remover o container PostgreSQL (mantendo o volume)
echo "🗑️  Removendo container PostgreSQL..."
docker-compose rm -f postgres

# Limpar volumes problemáticos (CUIDADO: isso remove todos os dados!)
read -p "⚠️  Deseja limpar os dados do PostgreSQL? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 Limpando volumes do PostgreSQL..."
    docker volume rm erp-freitex_postgres_data 2>/dev/null || true
fi

# Recriar e iniciar o PostgreSQL
echo "🚀 Recriando e iniciando PostgreSQL..."
docker-compose up -d postgres

# Aguardar o PostgreSQL inicializar
echo "⏳ Aguardando PostgreSQL inicializar..."
sleep 10

# Verificar se o PostgreSQL está funcionando
echo "🔍 Verificando status do PostgreSQL..."
docker-compose ps postgres

# Verificar logs do PostgreSQL
echo "📋 Últimos logs do PostgreSQL:"
docker-compose logs --tail=20 postgres

echo "✅ Correção concluída!"
echo "🌐 PostgreSQL deve estar disponível em: localhost:7002"
echo "🔑 Credenciais: postgres / postgres"
echo "🗄️  Banco: erp_freitex"
