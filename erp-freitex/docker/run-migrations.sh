#!/bin/bash

echo "🚀 Executando migrações do Prisma..."

# Aguardar o banco de dados estar pronto
echo "⏳ Aguardando banco de dados..."
sleep 5

# Executar migrações
echo "📦 Aplicando migrações..."
npx prisma migrate deploy

# Gerar cliente Prisma
echo "🔧 Gerando cliente Prisma..."
npx prisma generate

echo "✅ Migrações concluídas!"
