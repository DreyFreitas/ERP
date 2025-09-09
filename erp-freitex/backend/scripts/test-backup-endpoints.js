#!/usr/bin/env node

// Script para testar endpoints de backup
const axios = require('axios');

const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:7001';
const TEST_EMAIL = 'dreyggs@gmail.com';
const TEST_PASSWORD = '123456';

async function testBackupEndpoints() {
  try {
    console.log('🔍 Testando endpoints de backup...');
    
    // 1. Fazer login para obter token
    console.log('📝 Fazendo login...');
    const loginResponse = await axios.post(`${API_BASE_URL}/api/auth/login`, {
      email: TEST_EMAIL,
      password: TEST_PASSWORD
    });
    
    const token = loginResponse.data.data.accessToken;
    console.log('✅ Login realizado com sucesso');
    
    // 2. Testar endpoint de listagem de backups
    console.log('📋 Testando listagem de backups...');
    try {
      const listResponse = await axios.get(`${API_BASE_URL}/api/backup`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      
      console.log('✅ Listagem de backups funcionando!');
      console.log('📊 Resposta:', JSON.stringify(listResponse.data, null, 2));
      
    } catch (error) {
      console.log('❌ Erro na listagem de backups:');
      console.log('Status:', error.response?.status);
      console.log('Headers:', error.response?.headers);
      console.log('Data:', error.response?.data);
    }
    
    // 3. Testar endpoint de criação de backup
    console.log('💾 Testando criação de backup...');
    try {
      const createResponse = await axios.post(`${API_BASE_URL}/api/backup`, {
        description: 'Teste de backup via script'
      }, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });
      
      console.log('✅ Criação de backup funcionando!');
      console.log('📊 Resposta:', JSON.stringify(createResponse.data, null, 2));
      
    } catch (error) {
      console.log('❌ Erro na criação de backup:');
      console.log('Status:', error.response?.status);
      console.log('Headers:', error.response?.headers);
      console.log('Data:', error.response?.data);
    }
    
  } catch (error) {
    console.error('❌ Erro geral:', error.message);
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Data:', error.response.data);
    }
  }
}

// Executar teste
testBackupEndpoints();
