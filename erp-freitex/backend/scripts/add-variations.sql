-- Script para adicionar variações ao produto "Blusa de frio"
-- Primeiro, vamos pegar o ID do produto

-- Adicionar variações ao produto "Blusa de frio"
INSERT INTO product_variations (
    id,
    "productId",
    size,
    color,
    model,
    sku,
    "salePrice",
    "stockQuantity",
    "isActive",
    "createdAt",
    "updatedAt"
)
SELECT 
    gen_random_uuid(),
    p.id,
    'P',
    'Azul',
    'Básica',
    'BLU004-P-AZUL',
    79.90,
    0,
    true,
    NOW(),
    NOW()
FROM products p
WHERE p.name = 'Blusa de frio'
AND p."companyId" = '591c05e2-97f2-4697-ad38-7f7475a57255';

INSERT INTO product_variations (
    id,
    "productId",
    size,
    color,
    model,
    sku,
    "salePrice",
    "stockQuantity",
    "isActive",
    "createdAt",
    "updatedAt"
)
SELECT 
    gen_random_uuid(),
    p.id,
    'M',
    'Azul',
    'Básica',
    'BLU004-M-AZUL',
    79.90,
    0,
    true,
    NOW(),
    NOW()
FROM products p
WHERE p.name = 'Blusa de frio'
AND p."companyId" = '591c05e2-97f2-4697-ad38-7f7475a57255';

INSERT INTO product_variations (
    id,
    "productId",
    size,
    color,
    model,
    sku,
    "salePrice",
    "stockQuantity",
    "isActive",
    "createdAt",
    "updatedAt"
)
SELECT 
    gen_random_uuid(),
    p.id,
    'G',
    'Azul',
    'Básica',
    'BLU004-G-AZUL',
    79.90,
    0,
    true,
    NOW(),
    NOW()
FROM products p
WHERE p.name = 'Blusa de frio'
AND p."companyId" = '591c05e2-97f2-4697-ad38-7f7475a57255';

INSERT INTO product_variations (
    id,
    "productId",
    size,
    color,
    model,
    sku,
    "salePrice",
    "stockQuantity",
    "isActive",
    "createdAt",
    "updatedAt"
)
SELECT 
    gen_random_uuid(),
    p.id,
    'P',
    'Vermelho',
    'Básica',
    'BLU004-P-VERM',
    79.90,
    0,
    true,
    NOW(),
    NOW()
FROM products p
WHERE p.name = 'Blusa de frio'
AND p."companyId" = '591c05e2-97f2-4697-ad38-7f7475a57255';

-- Verificar se as variações foram criadas
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
WHERE p.name = 'Blusa de frio'
ORDER BY pv.size, pv.color;

SELECT 'Variações adicionadas com sucesso!' as resultado;
