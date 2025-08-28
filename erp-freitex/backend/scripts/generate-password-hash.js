const bcrypt = require('bcrypt');

// Senha que você quer usar
const password = 'a4dr2yfi8';

// Gerar hash da senha
async function generateHash() {
  try {
    const saltRounds = 10;
    const hash = await bcrypt.hash(password, saltRounds);
    
    console.log('=== HASH GERADO ===');
    console.log('Senha:', password);
    console.log('Hash:', hash);
    console.log('===================');
    
    // Verificar se o hash está correto
    const isValid = await bcrypt.compare(password, hash);
    console.log('Hash válido:', isValid);
    
    // Salvar em arquivo para copiar facilmente
    const fs = require('fs');
    fs.writeFileSync('password-hash.txt', hash);
    console.log('Hash salvo em: password-hash.txt');
    
  } catch (error) {
    console.error('Erro ao gerar hash:', error);
  }
}

generateHash();
