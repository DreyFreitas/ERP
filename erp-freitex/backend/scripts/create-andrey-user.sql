-- Script para criar usuário master Andrey Freitas
-- Senha: a4dr2yfi8

-- Verificar se o usuário já existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'dreyggs@gmail.com') THEN
        -- Inserir usuário master Andrey Freitas
        INSERT INTO users (id, "companyId", name, email, "passwordHash", role, "isActive", "createdAt", "updatedAt")
        VALUES (
            gen_random_uuid(),
            (SELECT id FROM companies LIMIT 1),
            'Andrey Freitas',
            'dreyggs@gmail.com',
            '$2b$10$/kRXlvU8pZxVppbFsqhQg.1JChF5owB21zCxFvn45V.qcTQEtb4P.',
            'master',
            true,
            NOW(),
            NOW()
        );
        
        RAISE NOTICE 'Usuário Andrey Freitas criado com sucesso!';
    ELSE
        RAISE NOTICE 'Usuário Andrey Freitas já existe!';
    END IF;
END $$;

-- Verificar usuário criado
SELECT 'Usuário criado:' as info;
SELECT id, name, email, role, "isActive" FROM users WHERE email = 'dreyggs@gmail.com';

