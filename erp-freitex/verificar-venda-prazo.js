const axios = require('axios');

const API_BASE_URL = 'http://localhost:7000/api';

async function verificarVendaPrazo() {
  try {
    console.log('🔍 Verificando venda a prazo de 30 dias...\n');
    
    // Login
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
      email: 'rodrigopeixotodefreitas@gmail.com',
      password: 'a4dr2yfi8'
    });
    
    const token = loginResponse.data.data.accessToken;
    
    // 1. Verificar vendas
    console.log('📊 VENDAS:');
    const vendasResponse = await axios.get(`${API_BASE_URL}/sales`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    
    vendasResponse.data.data.sales.forEach(venda => {
      console.log(`- Venda: ${venda.saleNumber}`);
      console.log(`  Cliente: ${venda.customer?.name || 'Sem cliente'}`);
      console.log(`  Valor: R$ ${venda.finalAmount}`);
      console.log(`  Método: ${venda.paymentMethod?.name}`);
      console.log(`  Prazo: ${venda.paymentTerm?.name || 'N/A'}`);
      console.log(`  Vencimento: ${venda.dueDate ? new Date(venda.dueDate).toLocaleDateString('pt-BR') : 'N/A'}`);
      console.log(`  Parcelado: ${venda.paymentTerm?.isInstallment ? 'SIM' : 'NÃO'}`);
      console.log(`  Status: ${venda.paymentStatus}`);
      console.log('');
    });
    
    // 2. Verificar parcelas
    console.log('💳 PARCELAS:');
    const parcelasResponse = await axios.get(`${API_BASE_URL}/financial/accounts-receivable`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    
    console.log('Parcelas encontradas:', parcelasResponse.data.data.length);
    parcelasResponse.data.data.forEach((parcela, index) => {
      console.log(`- Parcela ${index + 1}: ${parcela.saleNumber} - Parcela ${parcela.installmentNumber}`);
      console.log(`  Valor: R$ ${parcela.originalAmount}`);
      console.log(`  Vencimento: ${new Date(parcela.dueDate).toLocaleDateString('pt-BR')}`);
      console.log('');
    });
    
  } catch (error) {
    console.error('❌ Erro:', error.response?.data || error.message);
  }
}

verificarVendaPrazo();
