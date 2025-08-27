-- Script para popular dados iniciais após migração
-- Este script deve ser executado APENAS UMA VEZ após a migração

-- 1. Verificar se já existe uma empresa
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM companies LIMIT 1) THEN
        -- Inserir empresa padrão
        INSERT INTO companies (id, name, email, cnpj, phone, address, "planType", "planStatus", "trialEndsAt", "subscriptionEndsAt", "isActive", "createdAt", "updatedAt")
        VALUES (
            gen_random_uuid(),
            'Empresa Padrão',
            'contato@empresa.com',
            '12.345.678/0001-90',
            '(11) 99999-9999',
            'Rua Exemplo, 123 - São Paulo, SP',
            'basic',
            'active',
            NOW() + INTERVAL '30 days',
            NOW() + INTERVAL '30 days',
            true,
            NOW(),
            NOW()
        );
    END IF;
END $$;

-- 2. Verificar se já existe um usuário master
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE role = 'master' LIMIT 1) THEN
        -- Inserir usuário master
        INSERT INTO users (id, "companyId", name, email, "passwordHash", role, "isActive", "createdAt", "updatedAt")
        VALUES (
            gen_random_uuid(),
            (SELECT id FROM companies LIMIT 1),
            'Administrador',
            'admin@empresa.com',
            '$2b$10$rQZ8K9vX2mN3pL4qR5sT6uV7wX8yZ9aA0bB1cC2dE3fF4gG5hH6iI7jJ8kK9lL0mM1nN2oO3pP4qQ5rR6sS7tT8uU9vV0wW1xX2yY3zZ',
            'master',
            true,
            NOW(),
            NOW()
        );
    END IF;
END $$;

-- 3. Inserir categorias padrão
INSERT INTO categories (id, "companyId", name, description, "isActive", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    (SELECT id FROM companies LIMIT 1),
    name,
    description,
    true,
    NOW(),
    NOW()
FROM (VALUES 
    ('Eletrônicos', 'Produtos eletrônicos e tecnológicos'),
    ('Vestuário', 'Roupas e acessórios'),
    ('Casa e Jardim', 'Produtos para casa e jardim'),
    ('Esportes', 'Produtos esportivos e fitness'),
    ('Livros', 'Livros e materiais educacionais'),
    ('Alimentos', 'Produtos alimentícios'),
    ('Beleza', 'Produtos de beleza e cuidados pessoais'),
    ('Automotivo', 'Produtos automotivos'),
    ('Brinquedos', 'Brinquedos e jogos'),
    ('Outros', 'Outros produtos')
) AS cat_data(name, description)
WHERE NOT EXISTS (
    SELECT 1 FROM categories 
    WHERE categories.name = cat_data.name 
    AND categories."companyId" = (SELECT id FROM companies LIMIT 1)
);

-- 4. Inserir métodos de pagamento padrão
INSERT INTO payment_methods (id, "companyId", name, description, "isActive", "fee", "color", "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    (SELECT id FROM companies LIMIT 1),
    name,
    description,
    true,
    fee,
    color,
    "sortOrder",
    NOW(),
    NOW()
FROM (VALUES 
    ('Dinheiro', 'Pagamento em dinheiro', 0.00, '#28a745', 1),
    ('PIX', 'Pagamento via PIX', 0.00, '#007bff', 2),
    ('Cartão de Crédito', 'Pagamento com cartão de crédito', 2.99, '#ffc107', 3),
    ('Cartão de Débito', 'Pagamento com cartão de débito', 1.99, '#17a2b8', 4),
    ('Transferência', 'Transferência bancária', 0.00, '#6f42c1', 5)
) AS pm_data(name, description, fee, color, "sortOrder")
WHERE NOT EXISTS (
    SELECT 1 FROM payment_methods 
    WHERE payment_methods.name = pm_data.name 
    AND payment_methods."companyId" = (SELECT id FROM companies LIMIT 1)
);

-- 5. Inserir condições de pagamento padrão
INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", "interest", "sortOrder", "createdAt", "updatedAt")
SELECT 
    gen_random_uuid(),
    (SELECT id FROM companies LIMIT 1),
    name,
    days,
    description,
    true,
    interest,
    "sortOrder",
    NOW(),
    NOW()
FROM (VALUES 
    ('À vista', 0, 'Pagamento imediato', 0.00, 1),
    ('30 dias', 30, 'Pagamento em 30 dias', 0.00, 2),
    ('60 dias', 60, 'Pagamento em 60 dias', 0.00, 3),
    ('90 dias', 90, 'Pagamento em 90 dias', 0.00, 4)
) AS pt_data(name, days, description, interest, "sortOrder")
WHERE NOT EXISTS (
    SELECT 1 FROM payment_terms 
    WHERE payment_terms.name = pt_data.name 
    AND payment_terms."companyId" = (SELECT id FROM companies LIMIT 1)
);

-- 6. Verificar dados inseridos
SELECT 'Empresas:' as info;
SELECT id, name, email FROM companies;

SELECT 'Usuários:' as info;
SELECT id, name, email, role FROM users;

SELECT 'Categorias:' as info;
SELECT id, name, description FROM categories WHERE "isActive" = true;

SELECT 'Métodos de Pagamento:' as info;
SELECT id, name, description FROM payment_methods WHERE "isActive" = true;

SELECT 'Condições de Pagamento:' as info;
SELECT id, name, days FROM payment_terms WHERE "isActive" = true;

SELECT 'Contagem final:' as info;
SELECT
    (SELECT COUNT(*) FROM companies) as total_companies,
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM categories WHERE "isActive" = true) as total_categories,
    (SELECT COUNT(*) FROM payment_methods WHERE "isActive" = true) as total_payment_methods,
    (SELECT COUNT(*) FROM payment_terms WHERE "isActive" = true) as total_payment_terms;
