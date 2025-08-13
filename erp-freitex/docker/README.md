# 🐳 Docker Setup - ERP Freitex

## 📋 Visão Geral

Este diretório contém todos os arquivos necessários para executar o ERP Freitex usando Docker.

## 🚀 Quick Start

### Pré-requisitos
- Docker Desktop instalado e rodando
- Docker Compose disponível

### Iniciar o Sistema
```bash
# No Windows (PowerShell)
.\start.ps1 start

# No Linux/Mac (Bash)
./start.sh start
```

## 🏗️ Serviços

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| Frontend | 7000 | Interface React |
| Backend | 7001 | API Node.js |
| PostgreSQL | 7002 | Banco de dados |
| Redis | 7003 | Cache (opcional) |
| Adminer | 7004 | Gerenciamento do banco |

## 📁 Estrutura de Arquivos

```
docker/
├── docker-compose.yml    # Configuração principal
├── Dockerfile.frontend   # Imagem do frontend
├── Dockerfile.backend    # Imagem do backend
├── init-db.sql          # Script de inicialização do banco
├── start.sh             # Script bash para gerenciar containers
├── start.ps1            # Script PowerShell para Windows
└── README.md            # Esta documentação
```

## 🔧 Comandos Docker Compose

### Comandos Básicos
```bash
# Iniciar todos os serviços
docker-compose up -d

# Parar todos os serviços
docker-compose down

# Ver logs
docker-compose logs -f

# Reconstruir imagens
docker-compose build
```

### Comandos Avançados
```bash
# Executar comando no container backend
docker-compose exec backend npm run migrate

# Acessar banco de dados
docker-compose exec postgres psql -U postgres -d erp_freitex

# Limpar tudo (cuidado!)
docker-compose down -v
docker system prune -f
```

## 🗄️ Acesso ao Banco de Dados

### Via Adminer
- URL: http://localhost:7004
- Sistema: PostgreSQL
- Servidor: postgres
- Usuário: postgres
- Senha: postgres
- Banco: erp_freitex

### Via linha de comando
```bash
docker-compose exec postgres psql -U postgres -d erp_freitex
```

## 🔍 Troubleshooting

### Problemas Comuns

1. **Porta já em uso**
   ```bash
   # Verificar portas em uso
   netstat -ano | findstr :7000
   
   # Parar processo que está usando a porta
   taskkill /PID <PID> /F
   ```

2. **Container não inicia**
   ```bash
   # Ver logs do container
   docker-compose logs <service-name>
   
   # Reconstruir imagem
   docker-compose build --no-cache <service-name>
   ```

3. **Banco de dados não conecta**
   ```bash
   # Verificar se PostgreSQL está rodando
   docker-compose ps postgres
   
   # Reiniciar apenas o banco
   docker-compose restart postgres
   ```

### Logs Úteis
```bash
# Logs de todos os serviços
docker-compose logs

# Logs de um serviço específico
docker-compose logs backend

# Logs em tempo real
docker-compose logs -f frontend
```

## 🔄 Desenvolvimento

### Hot Reload
- Frontend: Alterações são refletidas automaticamente
- Backend: Usa nodemon para reiniciar automaticamente

### Variáveis de Ambiente
As variáveis de ambiente estão definidas no `docker-compose.yml`:
- `DATABASE_URL`: Conexão com PostgreSQL
- `JWT_SECRET`: Chave para JWT
- `PORT`: Porta do serviço

## 📝 Notas Importantes

- **Volumes**: Os dados do PostgreSQL e Redis são persistidos em volumes Docker
- **Rede**: Todos os serviços estão na rede `erp-network`
- **Dependências**: Backend depende do PostgreSQL e Redis
- **Frontend**: Depende do backend estar rodando

## 🆘 Suporte

Se encontrar problemas:
1. Verifique se o Docker Desktop está rodando
2. Execute `docker-compose logs` para ver erros
3. Tente `docker-compose down && docker-compose up -d`
4. Se persistir, use `docker-compose build --no-cache`
