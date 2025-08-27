const bcrypt = require('bcryptjs');

async function createMasterUser() {
    const password = 'a4dr2yfi8';
    const saltRounds = 10;
    
    try {
        const passwordHash = await bcrypt.hash(password, saltRounds);
        
        console.log('Hash da senha gerado:');
        console.log(passwordHash);
        
        console.log('\nScript SQL para inserir o usuário:');
        console.log(`
-- Script para criar usuário master Andrey Freitas
INSERT INTO users (id, "companyId", name, email, "passwordHash", role, "isActive", "createdAt", "updatedAt")
VALUES (
    gen_random_uuid(),
    (SELECT id FROM companies LIMIT 1),
    'Andrey Freitas',
    'dreyggs@gmail.com',
    '${passwordHash}',
    'master',
    true,
    NOW(),
    NOW()
);
        `);
        
    } catch (error) {
        console.error('Erro ao gerar hash:', error);
    }
}

createMasterUser();

