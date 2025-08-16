-- Script para adicionar variações de produtos com estoque
-- Este script adiciona variações para produtos existentes

-- Variação 1: Jaqueta M Azul
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
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b',
    'M',
    'Azul',
    'Casual',
    'JAC-M-AZU-001',
    89.90,
    15,
    true,
    NOW(),
    NOW()
);

-- Variação 2: Jaqueta L Azul
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
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b',
    'L',
    'Azul',
    'Casual',
    'JAC-L-AZU-001',
    89.90,
    12,
    true,
    NOW(),
    NOW()
);

-- Variação 3: Jaqueta M Preto
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
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b',
    'M',
    'Preto',
    'Casual',
    'JAC-M-PRE-001',
    89.90,
    8,
    true,
    NOW(),
    NOW()
);

-- Variação 4: Jaqueta L Preto
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
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b',
    'L',
    'Preto',
    'Casual',
    'JAC-L-PRE-001',
    89.90,
    5,
    true,
    NOW(),
    NOW()
);

-- Variação 5: Jaqueta P Cinza
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
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b',
    'P',
    'Cinza',
    'Casual',
    'JAC-P-CIN-001',
    89.90,
    0,
    true,
    NOW(),
    NOW()
);
