# 🤖 Context AI - ERP Freitex Softwares

## 📋 Visão Geral do Projeto

**Nome**: ERP Freitex Softwares  
**Tipo**: Sistema ERP web-based multi-tenant  
**Foco**: Pequenas e médias empresas (inicialmente lojas de roupas)  
**Escalabilidade**: Sistema escalável para outros segmentos  
**Acesso**: Web-based via Docker  
**Portas**: A partir da 7000  

## 🎯 Objetivo Principal

Criar um sistema ERP completo para a loja de roupas do pai do desenvolvedor, mas com arquitetura escalável para atender outras empresas através de modelo SaaS (Software as a Service).

## 🏗️ Stack Tecnológica Definida

### Frontend
- **Framework**: React.js + TypeScript
- **UI Library**: Material-UI (MUI)
- **Design System**: Cores da marca (#001f40, #00c7cd) + paleta complementar
- **Estado**: Context API ou Redux Toolkit
- **Roteamento**: React Router
- **Formulários**: React Hook Form + Yup

### Backend
- **Runtime**: Node.js + TypeScript
- **Framework**: Express.js
- **ORM**: Prisma
- **Autenticação**: JWT + Refresh Tokens
- **Validação**: Joi ou Zod

### Banco de Dados
- **SGBD**: PostgreSQL
- **Multi-tenancy**: Schema isolation (tenant_{id})
- **Migrations**: Prisma Migrate
- **Seeding**: Prisma Seed

### Infraestrutura
- **Containerização**: Docker + Docker Compose
- **Cache**: Redis (opcional)
- **Monitoramento**: Winston (logs)
- **Deploy**: DigitalOcean/AWS

## 🔧 Configuração de Portas

- **Frontend**: 7000
- **Backend API**: 7001
- **PostgreSQL**: 7002
- **Redis**: 7003 (opcional)
- **Adminer**: 7004 (gerenciamento do banco)

## 📦 Módulos do Sistema

### 1. 🏢 Multi-Tenancy (Sistema)
- Cadastro e gestão de empresas
- Controle de planos e assinaturas
- Isolamento de dados por empresa
- Dashboard administrativo master

### 2. 👥 Gestão de Usuários
- Usuário Master (administrador do sistema)
- Usuários por empresa (admin, vendedor, estoque, financeiro)
- Sistema de permissões granular
- Convites por email
- Recuperação de senha

### 3. 📦 Cadastro de Produtos
- Categorias e subcategorias hierárquicas
- Variações (tamanho, cor, modelo)
- Códigos de barras e SKUs
- Upload de múltiplas imagens
- Preços (custo, venda, promoção)
- Fornecedores

### 4. 📊 Controle de Estoque
- Entrada e saída de mercadorias
- Inventário físico
- Alertas de estoque baixo
- Movimentação entre lojas
- Relatórios de estoque

### 5. 🛒 Módulo PDV
- Interface touch-friendly
- Busca rápida de produtos
- Carrinho de compras
- Aplicação de descontos
- Múltiplas formas de pagamento
- Impressão de cupom fiscal
- Devoluções

### 6. 💰 Módulo Financeiro
- Contas a pagar e receber
- Fluxo de caixa
- Relatórios financeiros
- Integração com vendas
- Controle de comissões

### 7. 📈 Relatórios e Analytics
- Dashboard de vendas
- Produtos mais vendidos
- Performance por vendedor
- Margem de lucro
- Relatórios exportáveis

### 8. 🔔 Sistema de Notificações
- Alertas de estoque
- Vencimento de contas
- Relatórios automáticos
- Notificações push

## 🗄️ Estrutura do Banco de Dados

### Schema: `public` (Sistema)
- `companies` - Empresas cadastradas
- `users` - Usuários do sistema
- `company_settings` - Configurações por empresa

### Schema: `tenant_{id}` (Por Empresa)
- `categories` - Categorias de produtos
- `suppliers` - Fornecedores
- `products` - Produtos
- `product_variations` - Variações de produtos
- `stock_movements` - Movimentações de estoque
- `customers` - Clientes
- `sales` - Vendas
- `sale_items` - Itens das vendas
- `financial_accounts` - Contas financeiras
- `financial_transactions` - Transações financeiras
- `stores` - Lojas/filiais

## 💰 Modelo de Negócio

### Planos de Assinatura
1. **Básico**: R$ 99/mês
   - 1 loja, 3 usuários
   - Módulos básicos

2. **Profissional**: R$ 199/mês
   - 3 lojas, 10 usuários
   - Todos os módulos
   - Relatórios avançados

3. **Enterprise**: R$ 399/mês
   - Lojas ilimitadas
   - Usuários ilimitados
   - Suporte prioritário
   - API completa

## 🗺️ Roadmap de Desenvolvimento

### Fase 1: Fundação (Meses 1-2)
- Setup inicial e autenticação
- Sistema multi-tenant
- Gestão de usuários
- Configurações básicas

### Fase 2: Produtos e Estoque (Meses 3-4)
- Cadastro de produtos
- Controle de estoque
- Relatórios básicos

### Fase 3: PDV (Meses 5-6)
- Sistema de vendas
- Cadastro de clientes
- Interface PDV

### Fase 4: Financeiro (Meses 7-8)
- Gestão financeira
- Fluxo de caixa
- Relatórios financeiros

### Fase 5: Melhorias (Meses 9-10)
- Notificações
- Integrações
- Performance e deploy

## 🎯 Prioridades Atuais

### Sprint 1-2: MVP Básico
- [ ] Configurar ambiente Docker
- [ ] Estruturar projeto frontend/backend
- [ ] Implementar autenticação JWT
- [ ] CRUD básico de empresas
- [ ] Sistema de usuários

### Próximos Passos Imediatos
1. **Definir stack final** ✅
2. **Configurar ambiente Docker** 🔄
3. **Criar estrutura base** 📋
4. **Implementar autenticação** 🔐
5. **Primeiro módulo (produtos)** 📦

## 🔐 Segurança e Boas Práticas

### Autenticação
- JWT com refresh tokens
- Middleware de autenticação
- Controle de permissões por módulo
- Rate limiting

### Dados
- Isolamento por tenant
- Validação de entrada
- Sanitização de dados
- Backup automático

### Performance
- Índices otimizados
- Paginação
- Cache Redis (futuro)
- Lazy loading

## 📁 Estrutura de Pastas

```
erp-freitex/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── services/
│   │   ├── utils/
│   │   ├── types/
│   │   ├── contexts/
│   │   ├── styles/
│   │   │   ├── theme.ts
│   │   │   ├── global.css
│   │   │   └── components.css
│   │   └── assets/
│   ├── public/
│   └── package.json
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── models/
│   │   ├── middleware/
│   │   ├── routes/
│   │   ├── utils/
│   │   └── types/
│   ├── prisma/
│   └── package.json
├── docker/
│   ├── docker-compose.yml
│   ├── Dockerfile.frontend
│   └── Dockerfile.backend
├── docs/
│   ├── DESIGN_SYSTEM.md
│   ├── API_DOCS.md
│   └── DEPLOYMENT.md
└── scripts/
```

## 🧪 Testes e Qualidade

### Testes
- Unit tests (Jest)
- Integration tests (Supertest)
- E2E tests (Cypress)

### Qualidade
- ESLint + Prettier
- Husky (git hooks)
- TypeScript strict mode
- Code review obrigatório

## 🚀 Deploy e Monitoramento

### Ambiente de Desenvolvimento
- Docker Compose local
- Hot reload
- Debug mode

### Ambiente de Produção
- DigitalOcean/AWS
- CI/CD pipeline
- Monitoramento com logs
- Backup automático

## 📞 Contato e Suporte

### Desenvolvedor
- **Nome**: [Nome do desenvolvedor]
- **Email**: [Email]
- **GitHub**: [GitHub]

### Cliente Piloto
- **Empresa**: Loja de roupas do pai
- **Feedback**: Contínuo durante desenvolvimento
- **Testes**: Ambiente real de produção

## 📝 Notas Importantes

### Regras de Negócio
- Cada empresa tem isolamento completo de dados
- Usuário master pode gerenciar todas as empresas
- Sistema de assinatura com corte automático
- Backup diário de todos os dados

### Limitações Técnicas
- PostgreSQL como único banco de dados
- Frontend em React (SPA)
- Backend em Node.js
- Docker obrigatório para deploy

### Futuras Expansões
- E-commerce integrado
- App mobile
- Integrações com sistemas fiscais
- IA para previsão de demanda
- Multi-idioma

---

**Última atualização**: [Data atual]  
**Versão**: 1.0  
**Status**: Em desenvolvimento
