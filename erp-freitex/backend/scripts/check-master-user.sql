-- Verificar se o usuário master foi criado
SELECT 
    id,
    name,
    email,
    role,
    "isActive",
    "createdAt"
FROM users 
WHERE email = 'dreyggs@gmail.com';

-- Verificar todos os usuários
SELECT 
    id,
    name,
    email,
    role,
    "isActive"
FROM users;
