#!/bin/bash

# Script de inicialização do backend
# Executa migrations e inicia o servidor

echo "🚀 Iniciando backend ERP Freitex..."

# Aguardar PostgreSQL estar disponível
echo "⏳ Aguardando PostgreSQL estar disponível..."
until npx prisma db pull --print >/dev/null 2>&1; do
  echo "⏳ PostgreSQL não está disponível ainda, aguardando..."
  sleep 2
done

echo "✅ PostgreSQL está disponível!"

# Executar migrations
echo "📦 Executando migrations do Prisma..."
npx prisma migrate deploy

if [ $? -eq 0 ]; then
    echo "✅ Migrations executadas com sucesso!"
else
    echo "❌ Erro ao executar migrations!"
    exit 1
fi

# Gerar cliente Prisma
echo "🔧 Gerando cliente Prisma..."
npx prisma generate

if [ $? -eq 0 ]; then
    echo "✅ Cliente Prisma gerado com sucesso!"
else
    echo "❌ Erro ao gerar cliente Prisma!"
    exit 1
fi

# Iniciar servidor
echo "🌐 Iniciando servidor..."
npm start
