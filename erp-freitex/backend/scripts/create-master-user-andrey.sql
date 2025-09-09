-- Script SQL para criar usuário master Andrey Freitas
-- Execute este comando no Adminer ou psql

-- Inserir usuário master
INSERT INTO users (
    id,
    name,
    email,
    "passwordHash",
    role,
    "isActive",
    "createdAt",
    "updatedAt"
) VALUES (
    gen_random_uuid(), -- Gera UUID automático
    'Andrey Freitas',
    'dreyggs@gmail.com',
    '$2b$12$Tsz.Qp6zxyS4lypEZU0o3ObEEx7YlxvGor4dyioA4CNIgk0llF62O', -- Hash da senha #A4dr2yFI8
    'master',
    true,
    NOW(),
    NOW()
) ON CONFLICT (email) DO UPDATE SET
    name = EXCLUDED.name,
    "passwordHash" = EXCLUDED."passwordHash",
    role = EXCLUDED.role,
    "isActive" = EXCLUDED."isActive",
    "updatedAt" = NOW();

-- Verificar se o usuário foi criado
SELECT 
    id,
    name,
    email,
    role,
    "isActive",
    "createdAt"
FROM users 
WHERE email = 'dreyggs@gmail.com';

-- Mostrar mensagem de sucesso
DO $$
BEGIN
    RAISE NOTICE '✅ Usuário master Andrey Freitas criado com sucesso!';
    RAISE NOTICE '📧 Email: dreyggs@gmail.com';
    RAISE NOTICE '🔑 Senha: #A4dr2yFI8';
    RAISE NOTICE '👑 Role: master';
    RAISE NOTICE '🌐 Acesse: http://localhost:7000';
END $$;
