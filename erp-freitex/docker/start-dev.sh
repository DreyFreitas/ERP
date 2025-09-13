#!/bin/bash

# Script para iniciar o ERP Freitex em modo DESENVOLVIMENTO ULTRA-RÁPIDO
# Usa volumes para hot-reload - SEM BUILD!

echo "🚀 Iniciando ERP Freitex em modo DESENVOLVIMENTO ULTRA-RÁPIDO..."

# Parar containers existentes
echo "📦 Parando containers existentes..."
docker-compose -f docker-compose.dev.yml down

# Iniciar em modo desenvolvimento (SEM BUILD!)
echo "⚡ Iniciando em modo desenvolvimento (SEM BUILD!)..."
docker-compose -f docker-compose.dev.yml up -d

echo "✅ ERP Freitex iniciado em modo desenvolvimento!"
echo "🌐 Frontend (via Nginx): http://localhost:7000"
echo "🔧 Backend (via Nginx): http://localhost:7000/api"
echo "🗄️  PostgreSQL: localhost:7002"
echo "📊 Adminer: http://localhost:7004"
echo ""
echo "🔥 HOT-RELOAD ATIVO:"
echo "   - Frontend: Mudanças no código são refletidas automaticamente"
echo "   - Backend: Mudanças no código reiniciam o servidor automaticamente"
echo "   - Acesso via Nginx na porta 7000 (igual produção)"
echo ""
echo "💡 Para parar: docker-compose -f docker-compose.dev.yml down"
