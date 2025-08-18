-- Criar empresa de exemplo
INSERT INTO companies (id, name, email, "isActive", "createdAt", "updatedAt") 
VALUES (gen_random_uuid(), 'Empresa Exemplo', 'exemplo@empresa.com', true, NOW(), NOW());

-- Verificar se foi criada
SELECT 'Empresa criada:' as info;
SELECT id, name, email FROM companies;
