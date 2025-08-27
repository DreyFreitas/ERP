-- Script para verificar e corrigir problemas de constraint único
-- Execute este script para identificar e resolver problemas de duplicação

-- 1. Verificar produtos com SKUs duplicados
SELECT 
    "companyId",
    sku,
    COUNT(*) as quantidade
FROM products 
WHERE sku IS NOT NULL
GROUP BY "companyId", sku
HAVING COUNT(*) > 1;

-- 2. Verificar produtos com códigos de barras duplicados
SELECT 
    "companyId",
    barcode,
    COUNT(*) as quantidade
FROM products 
WHERE barcode IS NOT NULL
GROUP BY "companyId", barcode
HAVING COUNT(*) > 1;

-- 3. Verificar variações com SKUs duplicados
SELECT 
    "productId",
    sku,
    COUNT(*) as quantidade
FROM product_variations 
WHERE sku IS NOT NULL
GROUP BY "productId", sku
HAVING COUNT(*) > 1;

-- 4. Verificar variações com códigos de barras duplicados
SELECT 
    "productId",
    barcode,
    COUNT(*) as quantidade
FROM product_variations 
WHERE barcode IS NOT NULL
GROUP BY "productId", barcode
HAVING COUNT(*) > 1;

-- 5. Limpar variações duplicadas (manter apenas a mais recente)
DELETE FROM product_variations 
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER (PARTITION BY "productId", sku ORDER BY "createdAt" DESC) as rn
        FROM product_variations 
        WHERE sku IS NOT NULL
    ) t 
    WHERE t.rn > 1
);

-- 6. Limpar variações com códigos de barras duplicados
DELETE FROM product_variations 
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER (PARTITION BY "productId", barcode ORDER BY "createdAt" DESC) as rn
        FROM product_variations 
        WHERE barcode IS NOT NULL
    ) t 
    WHERE t.rn > 1
);

-- 7. Verificar se os constraints estão funcionando
SELECT 'Verificação concluída!' as resultado;
