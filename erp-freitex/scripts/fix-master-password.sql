-- Script para corrigir a senha do usuário master
-- Senha: a4dr2yfi8
-- Hash correto gerado pelo bcrypt

UPDATE users 
SET "passwordHash" = '$2b$12$qBmigWlzGrlMpE/xdZ95i.gEEknGw3WDpLGZ/6uKVt2XaJtxSl.sK'
WHERE email = 'dreyggs@gmail.com';

-- Verificar se foi atualizado
SELECT name, email, role, "isActive" 
FROM users 
WHERE email = 'dreyggs@gmail.com';
