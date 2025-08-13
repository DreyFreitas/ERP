// Script para testar a API do ERP Freitex
async function testAPI() {
  try {
    // Importar fetch dinamicamente
    const fetch = (await import('node-fetch')).default;

    // Testar health check
    console.log('🔍 Testando health check...');
    const healthResponse = await fetch('http://localhost:7001/health');
    const healthData = await healthResponse.json();
    console.log('✅ Health check:', healthData);

    // Testar API principal
    console.log('\n🔍 Testando API principal...');
    const apiResponse = await fetch('http://localhost:7001/api');
    const apiData = await apiResponse.json();
    console.log('✅ API principal:', apiData);

    // Criar usuário master
    console.log('\n🔍 Criando usuário master...');
    const createMasterResponse = await fetch('http://localhost:7001/api/auth/create-master', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name: 'Administrador Master',
        email: 'admin@erpfreitex.com',
        password: 'admin123'
      })
    });
    const masterData = await createMasterResponse.json();
    console.log('✅ Usuário master criado:', masterData);

    // Testar login
    console.log('\n🔍 Testando login...');
    const loginResponse = await fetch('http://localhost:7001/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: 'admin@erpfreitex.com',
        password: 'admin123'
      })
    });
    const loginData = await loginResponse.json();
    console.log('✅ Login:', loginData.success ? 'Sucesso!' : 'Falhou!');
    
    if (loginData.success) {
      console.log('🔑 Token recebido:', loginData.data.accessToken.substring(0, 20) + '...');
    }

  } catch (error) {
    console.error('❌ Erro:', error.message);
  }
}

testAPI();
