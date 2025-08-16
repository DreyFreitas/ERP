-- Script para atualizar dados existentes com companyId
-- Este script deve ser executado APENAS UMA VEZ

-- 1. Primeiro, vamos verificar se há empresas no sistema
SELECT 'Verificando empresas existentes:' as info;
SELECT id, name, email FROM companies WHERE isActive = true;

-- 2. Verificar produtos existentes
SELECT 'Verificando produtos existentes:' as info;
SELECT id, name, sku FROM products WHERE isActive = true;

-- 3. Verificar categorias existentes
SELECT 'Verificando categorias existentes:' as info;
SELECT id, name FROM categories WHERE isActive = true;

-- 4. Atualizar produtos existentes para associar à primeira empresa ativa
-- (Assumindo que há pelo menos uma empresa no sistema)
UPDATE products 
SET "companyId" = (SELECT id FROM companies WHERE isActive = true LIMIT 1)
WHERE "companyId" IS NULL;

-- 5. Atualizar categorias existentes para associar à primeira empresa ativa
UPDATE categories 
SET "companyId" = (SELECT id FROM companies WHERE isActive = true LIMIT 1)
WHERE "companyId" IS NULL;

-- 6. Verificar se as atualizações foram feitas corretamente
SELECT 'Verificando produtos após atualização:' as info;
SELECT p.id, p.name, p.sku, c.name as company_name 
FROM products p 
JOIN companies c ON p."companyId" = c.id 
WHERE p.isActive = true;

SELECT 'Verificando categorias após atualização:' as info;
SELECT cat.id, cat.name, c.name as company_name 
FROM categories cat 
JOIN companies c ON cat."companyId" = c.id 
WHERE cat.isActive = true;

-- 7. Contagem final
SELECT 'Contagem final:' as info;
SELECT 
    (SELECT COUNT(*) FROM products WHERE isActive = true) as total_products,
    (SELECT COUNT(*) FROM categories WHERE isActive = true) as total_categories,
    (SELECT COUNT(*) FROM companies WHERE isActive = true) as total_companies;
