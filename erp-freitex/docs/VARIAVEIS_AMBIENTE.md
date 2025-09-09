# 🔧 Configuração de Variáveis de Ambiente - ERP Freitex

## 📋 Visão Geral

Este documento descreve como configurar as variáveis de ambiente necessárias para o funcionamento do sistema ERP Freitex.

## 🚨 **IMPORTANTE - SEGURANÇA**

**NUNCA** commite arquivos `.env` no git! Use sempre variáveis de ambiente do sistema ou docker-compose.

## 🔑 Variáveis Obrigatórias

### Banco de Dados
```bash
DATABASE_URL="postgresql://postgres:postgres@postgres:5432/erp_freitex?schema=public"
```

### Autenticação JWT
```bash
JWT_SECRET="your-super-secret-jwt-key-change-in-production"
```

## ⚙️ Variáveis Opcionais

### Servidor
```bash
PORT=7001
NODE_ENV=production
```

### Upload de Arquivos
```bash
UPLOAD_DIR=uploads
MAX_FILE_SIZE=10485760  # 10MB
```

### Backup
```bash
BACKUP_DIR=backups
BACKUP_RETENTION_DAYS=30
```

### Redis (Cache)
```bash
REDIS_URL="redis://redis:6379"
```

### Logs
```bash
LOG_LEVEL=info  # error, warn, info, debug
```

## 🐳 Configuração no Docker Compose

As variáveis são configuradas automaticamente no `docker-compose.yml`:

```yaml
backend:
  environment:
    - PORT=7001
    - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/erp_freitex?schema=public
    - JWT_SECRET=your-super-secret-jwt-key-change-in-production
    - NODE_ENV=production
    # ... outras variáveis
```

## 🔒 Segurança em Produção

### 1. **Altere o JWT_SECRET**
```bash
# Gere uma chave segura
openssl rand -base64 32
```

### 2. **Use Variáveis de Ambiente do Sistema**
```bash
export JWT_SECRET="sua-chave-super-secreta-aqui"
export DATABASE_URL="postgresql://user:pass@host:port/db"
```

### 3. **Use Docker Secrets (Recomendado)**
```yaml
secrets:
  jwt_secret:
    external: true
  db_password:
    external: true

services:
  backend:
    secrets:
      - jwt_secret
      - db_password
    environment:
      - JWT_SECRET_FILE=/run/secrets/jwt_secret
```

## 🛠️ Solução de Problemas

### Problema: "Tabelas não são criadas"
**Causa**: DATABASE_URL incorreta ou PostgreSQL não acessível
**Solução**: Verificar se o PostgreSQL está rodando e a URL está correta

### Problema: "Erro de autenticação JWT"
**Causa**: JWT_SECRET não configurado ou inválido
**Solução**: Verificar se JWT_SECRET está definido

### Problema: "Upload de arquivos falha"
**Causa**: UPLOAD_DIR não existe ou sem permissão
**Solução**: Verificar se o diretório existe e tem permissões corretas

## 📝 Exemplo de Arquivo .env (Desenvolvimento)

```bash
# Banco de Dados
DATABASE_URL="postgresql://postgres:postgres@localhost:7002/erp_freitex?schema=public"

# JWT
JWT_SECRET="dev-secret-key-change-in-production"

# Servidor
PORT=7001
NODE_ENV=development

# Upload
UPLOAD_DIR=uploads
MAX_FILE_SIZE=10485760

# Backup
BACKUP_DIR=backups
BACKUP_RETENTION_DAYS=7

# Redis
REDIS_URL="redis://localhost:7003"

# Logs
LOG_LEVEL=debug
```

## 🚀 Deploy em Produção

### 1. **Criar arquivo .env.production**
```bash
cp .env.example .env.production
# Editar com valores de produção
```

### 2. **Usar variáveis de ambiente do sistema**
```bash
export JWT_SECRET="$(openssl rand -base64 32)"
export DATABASE_URL="postgresql://user:pass@prod-host:5432/erp_freitex"
```

### 3. **Docker Compose com secrets**
```yaml
version: '3.8'
services:
  backend:
    environment:
      - JWT_SECRET_FILE=/run/secrets/jwt_secret
    secrets:
      - jwt_secret
secrets:
  jwt_secret:
    file: ./secrets/jwt_secret.txt
```

## ✅ Checklist de Segurança

- [ ] JWT_SECRET alterado para produção
- [ ] DATABASE_URL com credenciais seguras
- [ ] Arquivo .env não commitado no git
- [ ] Variáveis de ambiente do sistema configuradas
- [ ] Logs não expõem informações sensíveis
- [ ] Backup das configurações seguras

---

**Última atualização**: Janeiro 2025  
**Versão**: 1.0
