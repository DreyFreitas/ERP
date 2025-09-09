# 🚀 Deploy para Docker Hub - ERP Freitex

Este guia explica como fazer o build e push das imagens Docker para o Docker Hub.

## 📋 Pré-requisitos

1. **Conta no Docker Hub**: Crie uma conta em [hub.docker.com](https://hub.docker.com)
2. **Docker instalado**: Docker Desktop ou Docker Engine
3. **Login no Docker Hub**: Execute `docker login` e insira suas credenciais

## 🔧 Configuração

### 1. Configurar seu username

**Para Linux/Mac (bash):**
```bash
# Edite o arquivo build-and-push.sh
nano scripts/build-and-push.sh

# Altere a linha:
DOCKER_USERNAME="seu-username-aqui"  # ALTERE AQUI SEU USERNAME DO DOCKER HUB
# Para:
DOCKER_USERNAME="seu-username-real"
```

**Para Windows (PowerShell):**
```powershell
# Execute o script com seu username
.\scripts\build-and-push.ps1 -DockerUsername "seu-username-real"
```

### 2. Configurar docker-compose.prod.yml

Edite o arquivo `docker/docker-compose.prod.yml` e substitua `seu-username` pelo seu username real:

```yaml
services:
  nginx:
    image: seu-username-real/erp-freitex-nginx:latest
  frontend:
    image: seu-username-real/erp-freitex-frontend:latest
  backend:
    image: seu-username-real/erp-freitex-backend:latest
```

## 🚀 Executando o Build e Push

### Linux/Mac
```bash
# Tornar o script executável
chmod +x scripts/build-and-push.sh

# Executar o script
./scripts/build-and-push.sh
```

### Windows
```powershell
# Executar o script PowerShell
.\scripts\build-and-push.ps1 -DockerUsername "seu-username"
```

## 📦 O que o script faz

1. **Verifica dependências**: Docker rodando e login no Docker Hub
2. **Build das imagens**:
   - `erp-freitex-frontend:latest`
   - `erp-freitex-backend:latest`
   - `erp-freitex-nginx:latest`
3. **Push para Docker Hub**: Envia todas as imagens
4. **Relatório final**: Mostra as tags das imagens criadas

## 🎯 Usando as imagens

### Desenvolvimento (local)
```bash
# Usar docker-compose.yml (build local)
docker-compose up
```

### Produção (Docker Hub)
```bash
# Usar docker-compose.prod.yml (imagens do Docker Hub)
docker-compose -f docker/docker-compose.prod.yml up
```

## 🔄 Atualizando imagens

Para atualizar as imagens no Docker Hub:

1. Faça as alterações no código
2. Execute o script de build e push novamente
3. As imagens serão atualizadas com a tag `latest`

## 🏷️ Tags e Versionamento

### Tags disponíveis:
- `latest`: Última versão (padrão)
- `v1.0.0`: Versão específica
- `dev`: Versão de desenvolvimento

### Criando versão específica:
```bash
# Linux/Mac
./scripts/build-and-push.sh v1.0.0

# Windows
.\scripts\build-and-push.ps1 -DockerUsername "seu-username" -Version "v1.0.0"
```

## 🐛 Troubleshooting

### Erro: "Docker não está rodando"
```bash
# Inicie o Docker Desktop ou Docker Engine
sudo systemctl start docker  # Linux
```

### Erro: "Não está logado no Docker Hub"
```bash
# Faça login no Docker Hub
docker login
# Insira seu username e password
```

### Erro: "Permission denied"
```bash
# Linux/Mac - Tornar script executável
chmod +x scripts/build-and-push.sh
```

### Erro: "Build failed"
- Verifique se todos os arquivos estão presentes
- Verifique se o Dockerfile está correto
- Verifique se as dependências estão instaladas

## 📊 Monitoramento

### Verificar imagens locais:
```bash
docker images | grep erp-freitex
```

### Verificar imagens no Docker Hub:
- Acesse [hub.docker.com](https://hub.docker.com)
- Vá para seu repositório
- Verifique as tags disponíveis

### Logs do build:
```bash
# Ver logs detalhados do build
docker build --no-cache -f docker/Dockerfile.frontend -t test frontend
```

## 🔐 Segurança

### Variáveis de ambiente sensíveis:
- **NUNCA** inclua senhas ou chaves no Dockerfile
- Use arquivos `.env` ou variáveis de ambiente
- Configure secrets no Docker Compose

### Exemplo de .env:
```env
# .env (não versionar)
DATABASE_URL=postgresql://user:password@host:port/db
JWT_SECRET=your-super-secret-key
```

## 🚀 CI/CD (Futuro)

Para automatizar o processo, você pode configurar:

1. **GitHub Actions**: Build automático no push
2. **Docker Hub Automated Builds**: Build automático no Docker Hub
3. **Webhooks**: Notificações de deploy

### Exemplo GitHub Actions:
```yaml
name: Build and Push
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and push
        run: ./scripts/build-and-push.sh
```

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs do Docker
2. Verifique se todas as dependências estão instaladas
3. Verifique se o Docker Hub está acessível
4. Consulte a documentação do Docker

---

**Última atualização**: Dezembro 2024  
**Versão**: 1.0
