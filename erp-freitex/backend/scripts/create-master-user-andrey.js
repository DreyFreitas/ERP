const bcrypt = require('bcrypt');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function createMasterUser() {
    try {
        console.log('🔐 Criando usuário master...');
        
        // Dados do usuário
        const userData = {
            name: 'Andrey Freitas',
            email: 'dreyggs@gmail.com',
            role: 'MASTER',
            password: '#A4dr2yFI8'
        };
        
        // Gerar hash da senha
        const saltRounds = 12;
        const passwordHash = await bcrypt.hash(userData.password, saltRounds);
        
        console.log('✅ Hash da senha gerado com sucesso');
        
        // Verificar se o usuário já existe
        const existingUser = await prisma.user.findUnique({
            where: { email: userData.email }
        });
        
        if (existingUser) {
            console.log('⚠️  Usuário já existe. Atualizando...');
            
            const updatedUser = await prisma.user.update({
                where: { email: userData.email },
                data: {
                    name: userData.name,
                    passwordHash: passwordHash,
                    role: userData.role,
                    isActive: true
                }
            });
            
            console.log('✅ Usuário atualizado com sucesso!');
            console.log('📋 Dados do usuário:');
            console.log(`   Nome: ${updatedUser.name}`);
            console.log(`   Email: ${updatedUser.email}`);
            console.log(`   Role: ${updatedUser.role}`);
            console.log(`   ID: ${updatedUser.id}`);
            console.log(`   Ativo: ${updatedUser.isActive}`);
            
        } else {
            console.log('🆕 Criando novo usuário...');
            
            const newUser = await prisma.user.create({
                data: {
                    name: userData.name,
                    email: userData.email,
                    passwordHash: passwordHash,
                    role: userData.role,
                    isActive: true
                }
            });
            
            console.log('✅ Usuário criado com sucesso!');
            console.log('📋 Dados do usuário:');
            console.log(`   Nome: ${newUser.name}`);
            console.log(`   Email: ${newUser.email}`);
            console.log(`   Role: ${newUser.role}`);
            console.log(`   ID: ${newUser.id}`);
            console.log(`   Ativo: ${newUser.isActive}`);
        }
        
        console.log('');
        console.log('🎉 Usuário master criado/atualizado com sucesso!');
        console.log('🔑 Credenciais de acesso:');
        console.log(`   Email: ${userData.email}`);
        console.log(`   Senha: ${userData.password}`);
        console.log('');
        console.log('🌐 Acesse o sistema em: http://localhost:7000');
        
    } catch (error) {
        console.error('❌ Erro ao criar usuário master:', error);
        process.exit(1);
    } finally {
        await prisma.$disconnect();
    }
}

// Executar função
createMasterUser();
