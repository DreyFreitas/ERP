-- Script para adicionar clientes de exemplo com contas em aberto
-- Este script adiciona clientes e vendas a prazo para demonstrar a funcionalidade

-- Cliente 1: João Silva (com contas em aberto)
INSERT INTO customers (
    id, 
    "companyId", 
    name, 
    "cpfCnpj", 
    email, 
    phone, 
    address, 
    city, 
    state, 
    "zipCode", 
    gender, 
    notes, 
    "isActive", 
    "createdAt", 
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa (substitua pelo ID correto)
    'João Silva',
    '123.456.789-00',
    'joao.silva@email.com',
    '(11) 99999-9999',
    'Rua das Flores, 123',
    'São Paulo',
    'SP',
    '01234-567',
    'M',
    'Cliente preferencial',
    true,
    NOW(),
    NOW()
);

-- Cliente 2: Maria Santos (com contas em aberto)
INSERT INTO customers (
    id, 
    "companyId", 
    name, 
    "cpfCnpj", 
    email, 
    phone, 
    address, 
    city, 
    state, 
    "zipCode", 
    gender, 
    notes, 
    "isActive", 
    "createdAt", 
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa (substitua pelo ID correto)
    'Maria Santos',
    '987.654.321-00',
    'maria.santos@email.com',
    '(11) 88888-8888',
    'Av. Paulista, 1000',
    'São Paulo',
    'SP',
    '01310-100',
    'F',
    'Cliente VIP',
    true,
    NOW(),
    NOW()
);

-- Cliente 3: Pedro Oliveira (sem contas em aberto)
INSERT INTO customers (
    id, 
    "companyId", 
    name, 
    "cpfCnpj", 
    email, 
    phone, 
    address, 
    city, 
    state, 
    "zipCode", 
    gender, 
    notes, 
    "isActive", 
    "createdAt", 
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa (substitua pelo ID correto)
    'Pedro Oliveira',
    '456.789.123-00',
    'pedro.oliveira@email.com',
    '(11) 77777-7777',
    'Rua Augusta, 500',
    'São Paulo',
    'SP',
    '01212-000',
    'M',
    'Cliente regular',
    true,
    NOW(),
    NOW()
);

-- Cliente 4: Ana Costa (inativo)
INSERT INTO customers (
    id, 
    "companyId", 
    name, 
    "cpfCnpj", 
    email, 
    phone, 
    address, 
    city, 
    state, 
    "zipCode", 
    gender, 
    notes, 
    "isActive", 
    "createdAt", 
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa (substitua pelo ID correto)
    'Ana Costa',
    '789.123.456-00',
    'ana.costa@email.com',
    '(11) 66666-6666',
    'Rua Oscar Freire, 200',
    'São Paulo',
    'SP',
    '01426-000',
    'F',
    'Cliente inativo',
    false,
    NOW(),
    NOW()
);

-- Agora vamos adicionar algumas vendas a prazo para demonstrar contas em aberto
-- Primeiro, vamos obter os IDs dos clientes que acabamos de criar
-- (Você precisará substituir estes IDs pelos IDs reais gerados acima)

-- Venda a prazo para João Silva (PENDENTE)
INSERT INTO sales (
    id,
    "companyId",
    "customerId",
    "saleNumber",
    "totalAmount",
    "paymentMethod",
    "paymentStatus",
    "saleStatus",
    "dueDate",
    notes,
    "isActive",
    "createdAt",
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa
    (SELECT id FROM customers WHERE name = 'João Silva' LIMIT 1), -- ID do cliente
    'VDA-2024-001',
    1250.00,
    'BANK_TRANSFER',
    'PENDING',
    'COMPLETED',
    '2024-02-15', -- Vencimento em 30 dias
    'Venda a prazo - 30 dias',
    true,
    NOW(),
    NOW()
);

-- Venda a prazo para Maria Santos (PENDENTE)
INSERT INTO sales (
    id,
    "companyId",
    "customerId",
    "saleNumber",
    "totalAmount",
    "paymentMethod",
    "paymentStatus",
    "saleStatus",
    "dueDate",
    notes,
    "isActive",
    "createdAt",
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa
    (SELECT id FROM customers WHERE name = 'Maria Santos' LIMIT 1), -- ID do cliente
    'VDA-2024-002',
    890.00,
    'PIX',
    'PENDING',
    'COMPLETED',
    '2024-02-10', -- Vencimento em 25 dias
    'Venda a prazo - 25 dias',
    true,
    NOW(),
    NOW()
);

-- Venda a prazo para João Silva (PENDENTE) - segunda venda
INSERT INTO sales (
    id,
    "companyId",
    "customerId",
    "saleNumber",
    "totalAmount",
    "paymentMethod",
    "paymentStatus",
    "saleStatus",
    "dueDate",
    notes,
    "isActive",
    "createdAt",
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa
    (SELECT id FROM customers WHERE name = 'João Silva' LIMIT 1), -- ID do cliente
    'VDA-2024-003',
    750.00,
    'CREDIT_CARD',
    'PENDING',
    'COMPLETED',
    '2024-02-20', -- Vencimento em 35 dias
    'Venda a prazo - 35 dias',
    true,
    NOW(),
    NOW()
);

-- Venda à vista para Pedro Oliveira (PAGA)
INSERT INTO sales (
    id,
    "companyId",
    "customerId",
    "saleNumber",
    "totalAmount",
    "paymentMethod",
    "paymentStatus",
    "saleStatus",
    "dueDate",
    notes,
    "isActive",
    "createdAt",
    "updatedAt"
) VALUES (
    gen_random_uuid(),
    '61984ead-9a44-42fe-bba6-f4349d559b1b', -- ID da empresa
    (SELECT id FROM customers WHERE name = 'Pedro Oliveira' LIMIT 1), -- ID do cliente
    'VDA-2024-004',
    2100.00,
    'CASH',
    'PAID',
    'COMPLETED',
    NULL, -- Venda à vista não tem vencimento
    'Venda à vista',
    true,
    NOW(),
    NOW()
);
