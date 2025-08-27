-- Script para corrigir constraints únicos permitindo valores nulos
-- Este script resolve o problema de constraint único com valores nulos

-- 1. Remover constraints antigas
DROP INDEX IF EXISTS "unique_variation_sku_per_product";
DROP INDEX IF EXISTS "unique_variation_barcode_per_product";

-- 2. Criar constraints que permitem valores nulos
CREATE UNIQUE INDEX "unique_variation_sku_per_product" 
ON product_variations ("productId", sku) 
WHERE sku IS NOT NULL;

CREATE UNIQUE INDEX "unique_variation_barcode_per_product" 
ON product_variations ("productId", barcode) 
WHERE barcode IS NOT NULL;

-- 3. Verificar se as constraints foram criadas corretamente
SELECT 
    indexname, 
    indexdef 
FROM pg_indexes 
WHERE tablename = 'product_variations' 
AND indexname LIKE '%unique%';

SELECT 'Constraints corrigidas com sucesso!' as resultado;
