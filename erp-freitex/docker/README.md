# 🐳 Docker - ERP Freitex Softwares

## 📋 Visão Geral

Este diretório contém toda a configuração Docker para rodar o ERP Freitex Softwares localmente.

## 🚀 Início Rápido

### Pré-requisitos
- Docker Desktop instalado e rodando
- Docker Compose disponível

### Comandos Básicos

#### Windows (PowerShell)
```powershell
# Navegar para o diretório docker
cd docker

# Iniciar todos os serviços
.\start.ps1 start

# Ver logs
.\start.ps1 logs

# Parar serviços
.\start.ps1 stop
```

#### Linux/Mac (Bash)
```bash
# Navegar para o diretório docker
cd docker

# Dar permissão de execução
chmod +x start.sh

# Iniciar todos os serviços
./start.sh start

# Ver logs
./start.sh logs

# Parar serviços
./start.sh stop
```

## 🌐 Serviços Disponíveis

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| **Frontend** | 7000 | Interface React do ERP |
| **Backend** | 7001 | API Node.js |
| **PostgreSQL** | 7002 | Banco de dados |
| **Redis** | 7003 | Cache (opcional) |
| **Adminer** | 7004 | Gerenciamento do banco |

## 📁 Estrutura de Arquivos

```
docker/
├── docker-compose.yml      # Configuração principal
├── Dockerfile.frontend     # Imagem do frontend
├── Dockerfile.backend      # Imagem do backend
├── init-db.sql            # Script de inicialização do banco
├── start.sh               # Script bash para gerenciamento
├── start.ps1              # Script PowerShell para Windows
└── README.md              # Esta documentação
```

## 🔧 Comandos Docker Compose

### Iniciar Serviços
```bash
docker-compose up -d
```

### Parar Serviços
```bash
docker-compose down
```

### Ver Logs
```bash
# Todos os serviços
docker-compose logs -f

# Serviço específico
docker-compose logs -f frontend
docker-compose logs -f backend
```

### Reconstruir Imagens
```bash
docker-compose build --no-cache
```

### Limpar Tudo
```bash
docker-compose down -v
docker system prune -f
```

## 🗄️ Banco de Dados

### Acesso via Adminer
- **URL**: http://localhost:7004
- **Sistema**: PostgreSQL
- **Servidor**: postgres
- **Usuário**: postgres
- **Senha**: postgres
- **Banco**: erp_freitex

### Acesso Direto
```bash
docker-compose exec postgres psql -U postgres -d erp_freitex
```

## 🔍 Troubleshooting

### Porta já em uso
Se alguma porta estiver em uso, pare o serviço que está usando:
```bash
# Windows
netstat -ano | findstr :7000
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :7000
kill -9 <PID>
```

### Containers não iniciam
```bash
# Verificar logs detalhados
docker-compose logs

# Reconstruir imagens
docker-compose build --no-cache

# Limpar volumes
docker-compose down -v
```

### Problemas de permissão (Linux/Mac)
```bash
# Dar permissão aos scripts
chmod +x start.sh

# Ajustar permissões do Docker
sudo usermod -aG docker $USER
```

## 📊 Monitoramento

### Status dos Containers
```bash
docker-compose ps
```

### Uso de Recursos
```bash
docker stats
```

### Volumes
```bash
docker volume ls
```

## 🔐 Variáveis de Ambiente

### Frontend (.env)
```
PORT=7000
REACT_APP_API_URL=http://localhost:7001
```

### Backend (docker-compose.yml)
```
DATABASE_URL=postgresql://postgres:postgres@postgres:7002/erp_freitex
JWT_SECRET=your-super-secret-jwt-key-change-in-production
NODE_ENV=development
```

## 🚀 Deploy em Produção

Para deploy em produção, considere:

1. **Alterar senhas** no docker-compose.yml
2. **Configurar HTTPS** com nginx reverse proxy
3. **Usar volumes externos** para persistência
4. **Configurar backup** automático do banco
5. **Monitoramento** com logs estruturados

## 📞 Suporte

Em caso de problemas:

1. Verifique os logs: `docker-compose logs`
2. Consulte esta documentação
3. Verifique se o Docker está rodando
4. Reinicie os serviços: `docker-compose restart`

---

**Próximo passo**: Execute `.\start.ps1 start` (Windows) ou `./start.sh start` (Linux/Mac) para iniciar o ambiente completo!
