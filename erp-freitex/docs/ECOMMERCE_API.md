# 🛒 E-commerce API - ERP Freitex

## 📋 Visão Geral

A funcionalidade de E-commerce API permite que empresas integrem seus sistemas de e-commerce com o ERP Freitex, fornecendo acesso programático aos dados de produtos, estoque, clientes e vendas.

## 🚀 Funcionalidades Implementadas

### ✅ Sistema de API Keys
- **Geração de API Keys**: Criação de chaves únicas para autenticação
- **Controle de Permissões**: Sistema granular de permissões por endpoint
- **Gerenciamento**: Ativação/desativação, exclusão e monitoramento de uso
- **Segurança**: Chaves criptograficamente seguras com prefixo identificador

### ✅ Endpoints da API
- **Produtos**: Listagem, detalhes e verificação de estoque
- **Categorias**: Listagem de categorias hierárquicas
- **Clientes**: Listagem e criação de clientes
- **Vendas**: Consulta de vendas com filtros por data
- **Health Check**: Verificação de status da API

### ✅ Interface de Gerenciamento
- **Dashboard**: Estatísticas de uso e monitoramento
- **Gerenciamento de Keys**: Interface intuitiva para criar e gerenciar API Keys
- **Documentação Integrada**: Documentação completa dos endpoints
- **Testes**: Exemplos de uso para cada endpoint

## 🔧 Como Usar

### 1. Acessar a Funcionalidade
1. Faça login no sistema ERP
2. Navegue para **E-commerce** no menu lateral
3. A interface mostrará estatísticas e opções de gerenciamento

### 2. Criar uma API Key
1. Clique em **"Nova API Key"**
2. Digite um nome descritivo (ex: "E-commerce Principal")
3. Selecione as permissões necessárias:
   - `products:read` - Ler produtos
   - `products:write` - Escrever produtos
   - `stock:read` - Ler estoque
   - `stock:write` - Escrever estoque
   - `customers:read` - Ler clientes
   - `customers:write` - Escrever clientes
   - `sales:read` - Ler vendas
   - `sales:write` - Escrever vendas
   - `categories:read` - Ler categorias
   - `categories:write` - Escrever categorias
4. Clique em **"Criar API Key"**
5. **IMPORTANTE**: Copie e salve a chave gerada (ela não será mostrada novamente)

### 3. Usar a API
A API está disponível em: `https://erp.freitexsoftwares.com.br/api/v1/`

**Desenvolvimento Local:** `http://localhost:7000/api/v1/`

#### Autenticação
```http
Authorization: Bearer sua_api_key_aqui
```

#### Exemplos de Uso

**Listar Produtos:**
```http
GET https://erp.freitexsoftwares.com.br/api/v1/products?page=1&limit=10&category=roupas&search=camiseta
Authorization: Bearer sk_live_1234567890abcdef
```

**Verificar Estoque:**
```http
GET https://erp.freitexsoftwares.com.br/api/v1/products/123/stock
Authorization: Bearer sk_live_1234567890abcdef
```

**Criar Cliente:**
```http
POST https://erp.freitexsoftwares.com.br/api/v1/customers
Authorization: Bearer sk_live_1234567890abcdef
Content-Type: application/json

{
  "name": "João Silva",
  "email": "joao@email.com",
  "phone": "(11) 99999-9999",
  "cpfCnpj": "123.456.789-00"
}
```

## 📊 Endpoints Disponíveis

### Produtos
- `GET /api/v1/products` - Listar produtos
- `GET /api/v1/products/:id` - Obter produto específico
- `GET /api/v1/products/:id/stock` - Verificar estoque

### Categorias
- `GET /api/v1/categories` - Listar categorias

### Clientes
- `GET /api/v1/customers` - Listar clientes
- `POST /api/v1/customers` - Criar cliente

### Vendas
- `GET /api/v1/sales` - Listar vendas

### Sistema
- `GET /api/v1/health` - Health check

## 🔐 Segurança

### Controle de Acesso
- **API Keys únicas**: Cada chave é criptograficamente segura
- **Permissões granulares**: Controle fino sobre o que cada chave pode acessar
- **Isolamento por empresa**: Cada empresa só acessa seus próprios dados
- **Rate limiting**: Proteção contra abuso (implementado no servidor)

### Boas Práticas
1. **Nunca compartilhe suas API Keys** em código público
2. **Use HTTPS** para todas as requisições
3. **Monitore o uso** através do dashboard
4. **Revogue chaves** que não estão mais sendo usadas
5. **Use permissões mínimas** necessárias para cada integração

## 📈 Monitoramento

### Dashboard
O dashboard mostra:
- **Total de API Keys**: Quantas chaves foram criadas
- **Chaves Ativas**: Quantas estão atualmente ativas
- **Requisições**: Total de requisições feitas
- **Endpoints**: Quantos endpoints estão disponíveis

### Logs de Uso
Cada API Key mantém:
- **Último uso**: Data e hora da última requisição
- **Contador de uso**: Total de requisições feitas
- **Status**: Ativa ou inativa

## 🛠️ Desenvolvimento

### Estrutura do Backend
```
backend/src/
├── controllers/
│   └── apiKeyController.ts      # Gerenciamento de API Keys
├── routes/
│   ├── apiKeyRoutes.ts          # Rotas de gerenciamento
│   └── ecommerceApiRoutes.ts    # Rotas da API pública
└── types/
    └── index.ts                 # Tipos TypeScript
```

### Estrutura do Frontend
```
frontend/src/
├── pages/
│   └── CompanyEcommerce.tsx     # Página principal
└── services/
    └── apiKeyService.ts         # Serviço de API
```

### Banco de Dados
```sql
CREATE TABLE api_keys (
  id TEXT PRIMARY KEY,
  company_id TEXT NOT NULL REFERENCES companies(id),
  name TEXT NOT NULL,
  key TEXT UNIQUE NOT NULL,
  permissions TEXT[] NOT NULL,
  is_active BOOLEAN DEFAULT true,
  last_used TIMESTAMP,
  usage_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## 🚀 Próximos Passos

### Funcionalidades Futuras
- [ ] **Webhooks**: Notificações em tempo real
- [ ] **Rate Limiting**: Controle de taxa de requisições
- [ ] **Logs Detalhados**: Histórico completo de requisições
- [ ] **SDKs**: Bibliotecas para diferentes linguagens
- [ ] **Sandbox**: Ambiente de testes
- [ ] **Analytics**: Relatórios de uso da API

### Integrações Planejadas
- [ ] **Shopify**: Integração com lojas Shopify
- [ ] **WooCommerce**: Plugin para WordPress
- [ ] **Magento**: Extensão para Magento
- [ ] **PrestaShop**: Módulo para PrestaShop
- [ ] **Nuvemshop**: Integração com Nuvemshop

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a documentação integrada na interface
2. Verifique os logs de erro no dashboard
3. Entre em contato com o suporte técnico

---

**Última atualização**: Dezembro 2024  
**Versão**: 1.0  
**Status**: ✅ Implementado e Funcionando
