# 🧪 Exemplos de Uso da API E-commerce

## 📋 Pré-requisitos

1. **API Key válida** criada no dashboard
2. **URL base**: 
   - **Produção**: `https://erp.freitexsoftwares.com.br/api/v1/`
   - **Desenvolvimento**: `http://localhost:7000/api/v1/`
3. **Headers obrigatórios**:
   ```http
   Authorization: Bearer sua_api_key_aqui
   Content-Type: application/json
   ```

## 🔍 Testando com cURL

### 1. Health Check
```bash
# Desenvolvimento
curl -X GET "http://localhost:7000/api/v1/health" \
  -H "Authorization: Bearer sk_live_1234567890abcdef"

# Produção
curl -X GET "https://erp.freitexsoftwares.com.br/api/v1/health" \
  -H "Authorization: Bearer sk_live_1234567890abcdef"
```

**Resposta esperada:**
```json
{
  "success": true,
  "message": "API funcionando corretamente",
  "timestamp": "2024-12-20T14:30:00.000Z",
  "company": "Nome da Empresa"
}
```

### 2. Listar Produtos
```bash
curl -X GET "http://localhost:7000/api/v1/products?page=1&limit=5" \
  -H "Authorization: Bearer sk_live_1234567890abcdef"
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": [
    {
      "id": "123",
      "name": "Camiseta Polo",
      "description": "Camiseta polo masculina",
      "sku": "CAM001",
      "salePrice": 89.90,
      "costPrice": 45.00,
      "category": {
        "id": "cat1",
        "name": "Roupas"
      },
      "variations": [
        {
          "id": "var1",
          "size": "M",
          "color": "Azul",
          "stockQuantity": 10
        }
      ]
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 5,
    "total": 25,
    "pages": 5
  }
}
```

### 3. Verificar Estoque
```bash
curl -X GET "http://localhost:7000/api/v1/products/123/stock" \
  -H "Authorization: Bearer sk_live_1234567890abcdef"
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": {
    "productId": "123",
    "productName": "Camiseta Polo",
    "totalStock": 10,
    "variations": [
      {
        "id": "var1",
        "size": "M",
        "color": "Azul",
        "stockQuantity": 10
      }
    ],
    "hasStock": true
  }
}
```

### 4. Listar Categorias
```bash
curl -X GET "http://localhost:7000/api/v1/categories" \
  -H "Authorization: Bearer sk_live_1234567890abcdef"
```

### 5. Criar Cliente
```bash
curl -X POST "http://localhost:7000/api/v1/customers" \
  -H "Authorization: Bearer sk_live_1234567890abcdef" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@email.com",
    "phone": "(11) 99999-9999",
    "cpfCnpj": "123.456.789-00",
    "address": "Rua das Flores, 123",
    "city": "São Paulo",
    "state": "SP"
  }'
```

**Resposta esperada:**
```json
{
  "success": true,
  "data": {
    "id": "customer123",
    "name": "João Silva",
    "email": "joao@email.com",
    "phone": "(11) 99999-9999",
    "cpfCnpj": "123.456.789-00",
    "createdAt": "2024-12-20T14:30:00.000Z"
  },
  "message": "Cliente criado com sucesso"
}
```

### 6. Listar Vendas
```bash
curl -X GET "http://localhost:7000/api/v1/sales?page=1&limit=10&date_from=2024-01-01&date_to=2024-12-31" \
  -H "Authorization: Bearer sk_live_1234567890abcdef"
```

## 🧪 Testando com JavaScript/Node.js

```javascript
const axios = require('axios');

// Escolha a URL base conforme o ambiente
const API_BASE_URL = 'https://erp.freitexsoftwares.com.br/api/v1'; // Produção
// const API_BASE_URL = 'http://localhost:7000/api/v1'; // Desenvolvimento
const API_KEY = 'sk_live_1234567890abcdef';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Authorization': `Bearer ${API_KEY}`,
    'Content-Type': 'application/json'
  }
});

// Função para testar todos os endpoints
async function testAPI() {
  try {
    console.log('🧪 Testando API E-commerce...\n');

    // 1. Health Check
    console.log('1. Health Check...');
    const health = await api.get('/health');
    console.log('✅ Health Check:', health.data.message);

    // 2. Listar Produtos
    console.log('\n2. Listando Produtos...');
    const products = await api.get('/products?limit=3');
    console.log(`✅ Encontrados ${products.data.data.length} produtos`);

    // 3. Verificar Estoque (se houver produtos)
    if (products.data.data.length > 0) {
      const productId = products.data.data[0].id;
      console.log(`\n3. Verificando Estoque do Produto ${productId}...`);
      const stock = await api.get(`/products/${productId}/stock`);
      console.log(`✅ Estoque total: ${stock.data.data.totalStock}`);
    }

    // 4. Listar Categorias
    console.log('\n4. Listando Categorias...');
    const categories = await api.get('/categories');
    console.log(`✅ Encontradas ${categories.data.data.length} categorias`);

    // 5. Listar Clientes
    console.log('\n5. Listando Clientes...');
    const customers = await api.get('/customers?limit=3');
    console.log(`✅ Encontrados ${customers.data.data.length} clientes`);

    // 6. Listar Vendas
    console.log('\n6. Listando Vendas...');
    const sales = await api.get('/sales?limit=3');
    console.log(`✅ Encontradas ${sales.data.data.length} vendas`);

    console.log('\n🎉 Todos os testes passaram!');

  } catch (error) {
    console.error('❌ Erro no teste:', error.response?.data || error.message);
  }
}

// Executar testes
testAPI();
```

## 🧪 Testando com Python

```python
import requests
import json

# Escolha a URL base conforme o ambiente
API_BASE_URL = 'https://erp.freitexsoftwares.com.br/api/v1'  # Produção
# API_BASE_URL = 'http://localhost:7000/api/v1'  # Desenvolvimento
API_KEY = 'sk_live_1234567890abcdef'

headers = {
    'Authorization': f'Bearer {API_KEY}',
    'Content-Type': 'application/json'
}

def test_api():
    try:
        print('🧪 Testando API E-commerce...\n')

        # 1. Health Check
        print('1. Health Check...')
        response = requests.get(f'{API_BASE_URL}/health', headers=headers)
        if response.status_code == 200:
            print('✅ Health Check:', response.json()['message'])
        else:
            print('❌ Health Check falhou')

        # 2. Listar Produtos
        print('\n2. Listando Produtos...')
        response = requests.get(f'{API_BASE_URL}/products?limit=3', headers=headers)
        if response.status_code == 200:
            products = response.json()['data']
            print(f'✅ Encontrados {len(products)} produtos')
        else:
            print('❌ Falha ao listar produtos')

        # 3. Listar Categorias
        print('\n3. Listando Categorias...')
        response = requests.get(f'{API_BASE_URL}/categories', headers=headers)
        if response.status_code == 200:
            categories = response.json()['data']
            print(f'✅ Encontradas {len(categories)} categorias')
        else:
            print('❌ Falha ao listar categorias')

        print('\n🎉 Testes concluídos!')

    except Exception as e:
        print(f'❌ Erro no teste: {e}')

# Executar testes
test_api()
```

## 🧪 Testando com PHP

```php
<?php

// Escolha a URL base conforme o ambiente
$apiBaseUrl = 'https://erp.freitexsoftwares.com.br/api/v1'; // Produção
// $apiBaseUrl = 'http://localhost:7000/api/v1'; // Desenvolvimento
$apiKey = 'sk_live_1234567890abcdef';

$headers = [
    'Authorization: Bearer ' . $apiKey,
    'Content-Type: application/json'
];

function makeRequest($url, $headers, $method = 'GET', $data = null) {
    $ch = curl_init();
    
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
    
    if ($data) {
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    }
    
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    
    return [
        'status_code' => $httpCode,
        'data' => json_decode($response, true)
    ];
}

echo "🧪 Testando API E-commerce...\n\n";

// 1. Health Check
echo "1. Health Check...\n";
$response = makeRequest($apiBaseUrl . '/health', $headers);
if ($response['status_code'] == 200) {
    echo "✅ Health Check: " . $response['data']['message'] . "\n";
} else {
    echo "❌ Health Check falhou\n";
}

// 2. Listar Produtos
echo "\n2. Listando Produtos...\n";
$response = makeRequest($apiBaseUrl . '/products?limit=3', $headers);
if ($response['status_code'] == 200) {
    $products = $response['data']['data'];
    echo "✅ Encontrados " . count($products) . " produtos\n";
} else {
    echo "❌ Falha ao listar produtos\n";
}

echo "\n🎉 Testes concluídos!\n";

?>
```

## 🔍 Códigos de Erro Comuns

### 401 - Unauthorized
```json
{
  "success": false,
  "message": "API Key não fornecida"
}
```
**Solução**: Verifique se o header `Authorization` está correto.

### 403 - Forbidden
```json
{
  "success": false,
  "message": "Permissão insuficiente para esta operação"
}
```
**Solução**: Verifique se sua API Key tem a permissão necessária.

### 404 - Not Found
```json
{
  "success": false,
  "message": "Produto não encontrado"
}
```
**Solução**: Verifique se o ID do recurso está correto.

### 500 - Internal Server Error
```json
{
  "success": false,
  "message": "Erro interno do servidor"
}
```
**Solução**: Entre em contato com o suporte técnico.

## 📝 Dicas de Debugging

1. **Verifique a API Key**: Certifique-se de que está usando a chave correta
2. **Verifique as permissões**: Cada endpoint requer permissões específicas
3. **Verifique a URL**: Use a URL base correta (`/api/v1/`)
4. **Verifique os headers**: Inclua `Authorization` e `Content-Type`
5. **Verifique os dados**: Para POST/PUT, envie JSON válido
6. **Monitore o dashboard**: Use o dashboard para verificar uso e erros

---

**Última atualização**: Dezembro 2024  
**Versão**: 1.0
