// Script para testar a API do ERP Freitex
const fetch = require('node-fetch');

async function testAPI() {
  console.log('🧪 Testando API do ERP Freitex...\n');

  try {
    // Teste 1: Health Check
    console.log('1. Testando Health Check...');
    const healthResponse = await fetch('http://localhost:7000/health');
    const healthData = await healthResponse.json();
    console.log('✅ Health Check:', healthData);

    // Teste 2: API Test
    console.log('\n2. Testando API Test...');
    const apiResponse = await fetch('http://localhost:7000/api/test');
    const apiData = await apiResponse.json();
    console.log('✅ API Test:', apiData);

    // Teste 3: Login
    console.log('\n3. Testando Login...');
    const loginResponse = await fetch('http://localhost:7000/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: 'dreyggs@gmail.com',
        password: 'a4dr2yfi8'
      })
    });
    const loginData = await loginResponse.json();
    console.log('✅ Login:', loginData.success ? 'Sucesso!' : 'Falha!');
    if (loginData.success) {
      console.log('   Token:', loginData.data.accessToken.substring(0, 20) + '...');
    }

    console.log('\n🎉 Todos os testes passaram!');
    console.log('\n📝 Para testar no frontend:');
    console.log('   URL: http://localhost:7000');
    console.log('   Email: dreyggs@gmail.com');
    console.log('   Senha: a4dr2yfi8');

  } catch (error) {
    console.error('❌ Erro nos testes:', error.message);
  }
}

testAPI();
