-- Criar usuário master Andrey Freitas
-- Senha: a4dr2yfi8

INSERT INTO users (id, "companyId", name, email, "passwordHash", role, "isActive", "createdAt", "updatedAt")
VALUES (
    gen_random_uuid(),
    (SELECT id FROM companies LIMIT 1),
    'Andrey Freitas',
    'dreyggs@gmail.com',
    '$2b$10$qD6EFCTCnqq7fPqIfjcQ7Okqx0l0Eur.tLWr0m8Oy7t74.oa3IWwi',
    'master',
    true,
    NOW(),
    NOW()
) ON CONFLICT (email) DO NOTHING;

-- Verificar usuário criado
SELECT 'Usuário criado:' as info;
SELECT id, name, email, role, "isActive" FROM users WHERE email = 'dreyggs@gmail.com';
