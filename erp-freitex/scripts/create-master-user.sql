-- Script para criar usuário master
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
    'master-user-001',
    'Andrey Freitas',
    'dreyggs@gmail.com',
    '$2b$10$odaX5Yd8lT6SUlmp/vwoZuFllqXRIFXEmvqyR3DsvvAFVl1fV0sUC',
    'master',
    true,
    NOW(),
    NOW()
);
