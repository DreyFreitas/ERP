-- Script para criar usuário master
-- Senha: a4dr2yfi8 (hash bcrypt)

INSERT INTO users (
  id,
  name,
  email,
  "passwordHash",
  role,
  permissions,
  "isActive",
  "createdAt",
  "updatedAt"
) VALUES (
  gen_random_uuid(),
  'Andrey Freitas',
  'dreyggs@gmail.com',
  '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/5KqQKqG', -- hash da senha a4dr2yfi8
  'master',
  '{}',
  true,
  NOW(),
  NOW()
);

-- Verificar se foi criado
SELECT id, name, email, role, "isActive", "createdAt" 
FROM users 
WHERE email = 'dreyggs@gmail.com';
