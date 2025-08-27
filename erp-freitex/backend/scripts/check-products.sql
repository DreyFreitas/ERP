-- Script para verificar produtos e variações
-- Verifica se os produtos têm variações cadastradas

-- Listar todos os produtos
SELECT 
    p.id,
    p.name,
    p.sku,
    p."companyId",
    COUNT(pv.id) as variation_count
FROM products p
LEFT JOIN product_variations pv ON p.id = pv."productId"
GROUP BY p.id, p.name, p.sku, p."companyId"
ORDER BY p.name;

-- Listar produtos com variações
SELECT 
    p.name as product_name,
    pv.id as variation_id,
    pv.size,
    pv.color,
    pv.model,
    pv.sku as variation_sku,
    pv."stockQuantity"
FROM products p
INNER JOIN product_variations pv ON p.id = pv."productId"
WHERE p.name LIKE '%Blusa%'
ORDER BY p.name, pv.size, pv.color;

-- Verificar se há produtos sem variações
SELECT 
    p.name,
    p.sku,
    'Sem variações' as status
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM product_variations pv 
    WHERE pv."productId" = p.id
)
ORDER BY p.name;
