# 🏢 ERP Freitex Softwares

Sistema ERP web-based multi-tenant para pequenas e médias empresas, com foco inicial em lojas de roupas.

## 🎯 Sobre o Projeto

O ERP Freitex é um sistema completo de gestão empresarial desenvolvido para atender pequenas e médias empresas, especialmente lojas de roupas. O sistema oferece funcionalidades de gestão de produtos, estoque, vendas, financeiro e muito mais.

## 🚀 Tecnologias Utilizadas

### Frontend
- **React 18** + **TypeScript**
- **Material-UI (MUI)** - Componentes UI
- **React Router** - Roteamento
- **React Hook Form** + **Yup** - Formulários e validação
- **Axios** - Cliente HTTP

### Backend
- **Node.js** + **TypeScript**
- **Express.js** - Framework web
- **Prisma** - ORM
- **PostgreSQL** - Banco de dados
- **JWT** - Autenticação
- **Redis** - Cache (opcional)

### Infraestrutura
- **Docker** + **Docker Compose**
- **Nginx** - Servidor web
- **Adminer** - Gerenciamento do banco

## 📦 Módulos do Sistema

- 🏢 **Multi-Tenancy** - Gestão de empresas
- 👥 **Usuários** - Controle de permissões
- 📦 **Produtos** - Cadastro e variações
- 📊 **Estoque** - Controle completo
- 🛒 **PDV** - Sistema de vendas
- 💰 **Financeiro** - Gestão financeira
- 📈 **Relatórios** - Analytics e insights
- 🔔 **Notificações** - Alertas e comunicações

## 🎨 Design System

O sistema utiliza as cores da marca ERP Freitex:
- **Azul Escuro**: `#001f40` (cor principal)
- **Azul Ciano**: `#00c7cd` (cor secundária)

## 🛠️ Instalação e Configuração

### Pré-requisitos
- Docker e Docker Compose
- Node.js 18+ (para desenvolvimento local)

### 1. Clone o repositório
```bash
git clone <url-do-repositorio>
cd erp-freitex
```

### 2. Configure as variáveis de ambiente
```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Edite as variáveis conforme necessário
nano .env
```

### 3. Execute com Docker
```bash
# Na pasta raiz do projeto
docker-compose -f docker/docker-compose.yml up -d
```

### 4. Acesse o sistema
- **Frontend**: http://localhost:7000
- **Backend API**: http://localhost:7001
- **PostgreSQL**: localhost:7002
- **Adminer**: http://localhost:7004

### Credenciais padrão
- **Email**: admin@erpfreitex.com
- **Senha**: admin123

## 🏗️ Estrutura do Projeto

```
erp-freitex/
├── frontend/                 # Aplicação React
│   ├── src/
│   │   ├── components/      # Componentes reutilizáveis
│   │   ├── pages/          # Páginas da aplicação
│   │   ├── hooks/          # Custom hooks
│   │   ├── services/       # Serviços de API
│   │   ├── contexts/       # Contextos React
│   │   ├── types/          # Tipos TypeScript
│   │   └── styles/         # Estilos e tema
│   └── public/
├── backend/                 # API Node.js
│   ├── src/
│   │   ├── controllers/    # Controladores
│   │   ├── services/       # Lógica de negócio
│   │   ├── models/         # Modelos de dados
│   │   ├── middleware/     # Middlewares
│   │   ├── routes/         # Rotas da API
│   │   └── utils/          # Utilitários
│   └── prisma/             # Schema e migrations
├── docker/                 # Configurações Docker
│   ├── docker-compose.yml
│   ├── Dockerfile.frontend
│   └── nginx.conf
└── docs/                   # Documentação
```

## 🚀 Desenvolvimento

### Frontend (Desenvolvimento local)
```bash
cd frontend
npm install
npm start
```

### Backend (Desenvolvimento local)
```bash
cd backend
npm install
npm run dev
```

### Banco de dados
```bash
# Acesse o Adminer
http://localhost:7004

# Ou conecte diretamente
psql -h localhost -p 7002 -U postgres -d erp_freitex
```

## 📋 Roadmap

### ✅ Fase 1: Fundação (Concluída)
- [x] Setup inicial e autenticação
- [x] Sistema multi-tenant
- [x] Gestão de usuários
- [x] Configurações básicas

### 🔄 Fase 2: Produtos e Estoque (Em desenvolvimento)
- [ ] Cadastro de produtos
- [ ] Controle de estoque
- [ ] Relatórios básicos

### 📅 Próximas Fases
- **Fase 3**: PDV (Meses 5-6)
- **Fase 4**: Financeiro (Meses 7-8)
- **Fase 5**: Melhorias (Meses 9-10)

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Suporte

- **Email**: suporte@erpfreitex.com
- **Documentação**: [docs.erpfreitex.com](https://docs.erpfreitex.com)
- **Issues**: [GitHub Issues](https://github.com/erpfreitex/issues)

---

**ERP Freitex Softwares** - Transformando a gestão empresarial 🚀
