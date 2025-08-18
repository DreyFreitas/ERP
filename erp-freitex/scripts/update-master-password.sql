-- Script para atualizar a senha do usuário master
-- Senha: a4dr2yfi8
-- Hash correto gerado pelo bcrypt no container

UPDATE users 
SET "passwordHash" = '$2b$12$xEhsv9PTN8VL6U7gMzfy7usP4yFYjlicHPuwWwa4LAtARHEuDqGRC'
WHERE email = 'dreyggs@gmail.com';

-- Verificar se foi atualizado
SELECT name, email, role, "isActive" 
FROM users 
WHERE email = 'dreyggs@gmail.com';

