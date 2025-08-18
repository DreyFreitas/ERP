-- Script para inserir dados de exemplo de formas de pagamento e prazos
-- Executar dentro do container PostgreSQL

-- Inserir formas de pagamento de exemplo
INSERT INTO payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    'Dinheiro',
    'Pagamento em dinheiro',
    true,
    null,
    '#4CAF50',
    1,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    'PIX',
    'Pagamento via PIX',
    true,
    null,
    '#2196F3',
    2,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    'Cartão de Débito',
    'Pagamento com cartão de débito',
    true,
    2.5,
    '#FF9800',
    3,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    'Cartão de Crédito',
    'Pagamento com cartão de crédito',
    true,
    3.5,
    '#9C27B0',
    4,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    'Transferência Bancária',
    'Pagamento via transferência',
    true,
    null,
    '#607D8B',
    5,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

-- Inserir prazos de pagamento de exemplo
INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    'À vista',
    0,
    'Pagamento imediato',
    true,
    null,
    1,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    '7 dias',
    7,
    'Pagamento em 7 dias',
    true,
    null,
    2,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    '15 dias',
    15,
    'Pagamento em 15 dias',
    true,
    null,
    3,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    '30 dias',
    30,
    'Pagamento em 30 dias',
    true,
    2.0,
    4,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    c.id,
    '60 dias',
    60,
    'Pagamento em 60 dias',
    true,
    3.0,
    5,
    NOW(),
    NOW()
FROM companies c
WHERE c."isActive" = true;

-- Verificar se foram inseridos
SELECT 'Formas de pagamento inseridas:' as info;
SELECT c.name as empresa, pm.name as forma_pagamento, pm.fee as taxa
FROM payment_methods pm
JOIN companies c ON pm."companyId" = c.id
ORDER BY c.name, pm."sortOrder";

SELECT 'Prazos de pagamento inseridos:' as info;
SELECT c.name as empresa, pt.name as prazo, pt.days as dias, pt.interest as juros
FROM payment_terms pt
JOIN companies c ON pt."companyId" = c.id
ORDER BY c.name, pt."sortOrder";
