#!/bin/bash

# Script para aplicar migrações do Prisma no ambiente Docker
# Autor: ERP Freitex Softwares
# Data: 2025-08-21

echo "🔄 Aplicando migrações do Prisma..."

# Verificar se o Docker está rodando
if ! docker ps | grep -q "docker-backend-1"; then
    echo "❌ Container docker-backend-1 não está rodando!"
    echo "💡 Execute 'docker-compose up -d' primeiro"
    exit 1
fi

echo "✅ Container encontrado. Aplicando migrações..."

# Aplicar migrações
echo "📦 Executando 'npx prisma migrate deploy'..."
if docker exec docker-backend-1 npx prisma migrate deploy; then
    echo "✅ Migrações aplicadas com sucesso!"
else
    echo "❌ Erro ao aplicar migrações!"
    exit 1
fi

# Gerar cliente Prisma
echo "🔧 Gerando cliente Prisma..."
if docker exec docker-backend-1 npx prisma generate; then
    echo "✅ Cliente Prisma gerado com sucesso!"
else
    echo "❌ Erro ao gerar cliente Prisma!"
    exit 1
fi

# Reiniciar backend
echo "🔄 Reiniciando container do backend..."
if docker restart docker-backend-1; then
    echo "✅ Backend reiniciado com sucesso!"
else
    echo "❌ Erro ao reiniciar backend!"
    exit 1
fi

# Aguardar inicialização
echo "⏳ Aguardando inicialização do backend..."
sleep 5

# Verificar status
echo "🔍 Verificando status do backend..."
if curl -f -s http://localhost:7000/api/health > /dev/null; then
    echo "✅ Backend está funcionando corretamente!"
else
    echo "⚠️  Não foi possível verificar o status do backend"
fi

echo "🎉 Processo concluído com sucesso!"
echo "💡 Dica: Execute este script sempre que fizer alterações no schema do Prisma"
