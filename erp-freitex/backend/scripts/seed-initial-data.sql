-- Script para popular dados iniciais após migração
-- Este script deve ser executado APENAS UMA VEZ após a migração

-- 1. Verificar se já existe uma empresa
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM companies LIMIT 1) THEN
        -- Inserir empresa padrão
        INSERT INTO companies (id, name, email, cnpj, phone, address, plan, trialEndsAt, subscriptionEndsAt, "isActive", "createdAt", "updatedAt")
        VALUES (
            gen_random_uuid(),
            'Empresa Padrão',
            'contato@empresa.com',
            '12.345.678/0001-90',
            '(11) 99999-9999',
            'Rua Exemplo, 123 - São Paulo, SP',
            'basic',
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

-- 4. Verificar dados inseridos
SELECT 'Empresas:' as info;
SELECT id, name, email FROM companies;

SELECT 'Usuários:' as info;
SELECT id, name, email, role FROM users;

SELECT 'Categorias:' as info;
SELECT id, name, description FROM categories WHERE "isActive" = true;

SELECT 'Contagem final:' as info;
SELECT
    (SELECT COUNT(*) FROM companies) as total_companies,
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(*) FROM categories WHERE "isActive" = true) as total_categories;
