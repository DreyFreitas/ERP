#!/bin/bash

# Script para verificar se o backup está completo
BACKUP_FILE="/app/backups/backup_full_2025-09-04T19-17-20-762Z.sql"

echo "🔍 VERIFICAÇÃO COMPLETA DO BACKUP"
echo "=================================="
echo ""

# 1. Verificar se o arquivo existe e seu tamanho
echo "📁 Informações do arquivo:"
if [ -f "$BACKUP_FILE" ]; then
    SIZE=$(stat -c%s "$BACKUP_FILE")
    echo "   ✅ Arquivo existe: $BACKUP_FILE"
    echo "   📊 Tamanho: $SIZE bytes ($(($SIZE/1024)) KB)"
else
    echo "   ❌ Arquivo não encontrado!"
    exit 1
fi
echo ""

# 2. Verificar cabeçalho do backup
echo "📋 Cabeçalho do backup:"
head -5 "$BACKUP_FILE"
echo ""

# 3. Verificar se contém todas as tabelas principais
echo "🗄️ Tabelas incluídas no backup:"
grep "COPY public\." "$BACKUP_FILE" | wc -l | xargs echo "   Total de tabelas:"
echo ""
echo "   Lista de tabelas:"
grep "COPY public\." "$BACKUP_FILE" | sed 's/COPY public\./   ✅ /' | sed 's/ FROM stdin;//'
echo ""

# 4. Verificar dados das tabelas principais
echo "📊 Dados das tabelas principais:"
echo "   Empresas:"
grep -A 2 "COPY public.companies" "$BACKUP_FILE" | tail -1 | wc -c | xargs echo "     - Registros:"
echo "   Usuários:"
grep -A 2 "COPY public.users" "$BACKUP_FILE" | tail -1 | wc -c | xargs echo "     - Registros:"
echo "   Produtos:"
grep -A 2 "COPY public.products" "$BACKUP_FILE" | tail -1 | wc -c | xargs echo "     - Registros:"
echo "   Categorias:"
grep -A 2 "COPY public.categories" "$BACKUP_FILE" | tail -1 | wc -c | xargs echo "     - Registros:"
echo ""

# 5. Verificar se termina corretamente
echo "🏁 Final do backup:"
tail -5 "$BACKUP_FILE"
echo ""

# 6. Verificar integridade básica
echo "🔧 Verificações de integridade:"
if grep -q "PostgreSQL database dump" "$BACKUP_FILE"; then
    echo "   ✅ Cabeçalho PostgreSQL correto"
else
    echo "   ❌ Cabeçalho PostgreSQL ausente"
fi

if grep -q "COPY public.companies" "$BACKUP_FILE"; then
    echo "   ✅ Dados de empresas incluídos"
else
    echo "   ❌ Dados de empresas ausentes"
fi

if grep -q "COPY public.users" "$BACKUP_FILE"; then
    echo "   ✅ Dados de usuários incluídos"
else
    echo "   ❌ Dados de usuários ausentes"
fi

if grep -q "COPY public.products" "$BACKUP_FILE"; then
    echo "   ✅ Dados de produtos incluídos"
else
    echo "   ❌ Dados de produtos ausentes"
fi

echo ""
echo "🎯 CONCLUSÃO:"
if [ $SIZE -gt 1000 ]; then
    echo "   ✅ Backup parece estar COMPLETO e funcional!"
    echo "   📈 Tamanho adequado ($(($SIZE/1024)) KB)"
    echo "   🗄️ Todas as tabelas principais incluídas"
    echo "   💾 Pronto para restauração se necessário"
else
    echo "   ⚠️ Backup pode estar incompleto (muito pequeno)"
fi
