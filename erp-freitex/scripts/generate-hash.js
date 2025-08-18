const bcrypt = require('bcryptjs');

const password = 'a4dr2yfi8';
const saltRounds = 12;

bcrypt.hash(password, saltRounds).then(hash => {
  console.log('Hash gerado:', hash);
  
  // Testar se o hash está correto
  bcrypt.compare(password, hash).then(isMatch => {
    console.log('Hash válido:', isMatch);
  });
});
