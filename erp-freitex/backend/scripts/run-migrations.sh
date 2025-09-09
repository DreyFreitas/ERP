#!/bin/bash

# Script para executar migrations do Prisma
echo "🚀 Executando migrations do Prisma..."

# Navegar para o diretório do backend
cd /app

# Executar migrations
echo "📦 Executando migrations..."
npx prisma migrate deploy

# Verificar status das migrations
echo "📊 Status das migrations:"
npx prisma migrate status

# Gerar cliente Prisma
echo "🔧 Gerando cliente Prisma..."
npx prisma generate

echo "✅ Migrations executadas com sucesso!"
