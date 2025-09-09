-- Script para diagnosticar problemas no banco de dados
-- Execute este script para verificar o estado atual

-- 1. Verificar se as tabelas existem
SELECT 
    table_name,
    table_schema
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. Verificar usuários
SELECT 
    id,
    name,
    email,
    role,
    "companyId",
    "isActive",
    "createdAt"
FROM users
ORDER BY "createdAt" DESC;

-- 3. Verificar empresas
SELECT 
    id,
    name,
    email,
    "planType",
    "planStatus",
    "isActive",
    "createdAt"
FROM companies
ORDER BY "createdAt" DESC;

-- 4. Verificar se há usuários sem empresa
SELECT 
    u.id,
    u.name,
    u.email,
    u.role,
    u."companyId",
    c.name as company_name
FROM users u
LEFT JOIN companies c ON u."companyId" = c.id
WHERE u."companyId" IS NULL OR c.id IS NULL;

-- 5. Contar registros por tabela
SELECT 
    'users' as tabela,
    COUNT(*) as total
FROM users
UNION ALL
SELECT 
    'companies' as tabela,
    COUNT(*) as total
FROM companies
UNION ALL
SELECT 
    'products' as tabela,
    COUNT(*) as total
FROM products
UNION ALL
SELECT 
    'categories' as tabela,
    COUNT(*) as total
FROM categories;
