# 📁 Scripts Organizados - ERP Freitex Softwares

Este diretório contém scripts organizados por categoria para automatizar tarefas do ambiente de desenvolvimento.

## 📂 Estrutura Organizada

```
scripts/
├── 🐳 docker/           # Scripts para Docker e migrações
├── 🗄️ database/         # Scripts para backup e restore
├── 🚀 deployment/       # Scripts para deploy e atualizações
├── 🧪 testing/          # Scripts de teste e diagnóstico
└── 📚 docs/             # Documentação
```

---

## 🐳 **Docker** (`docker/`)

Scripts para gerenciar containers Docker e migrações do banco de dados.

### **Scripts Disponíveis:**

#### `start-with-migrations.ps1` ⭐ **MAIS USADO**
**Inicialização completa do ambiente**
```powershell
.\scripts\docker\start-with-migrations.ps1
```
- ✅ Verifica Docker
- ✅ Inicia containers
- ✅ Aplica migrações
- ✅ Gera cliente Prisma
- ✅ Verifica serviços

#### `apply-migrations.ps1/.sh`
**Aplicar migrações (ambiente já rodando)**
```powershell
.\scripts\docker\apply-migrations.ps1
```
- ✅ Aplica migrações pendentes
- ✅ Regenera cliente Prisma
- ✅ Reinicia backend

#### `safe-migration.ps1/.sh`
**Migração segura com backup**
```powershell
.\scripts\docker\safe-migration.ps1
```
- ✅ Backup automático
- ✅ Aplica migrações
- ✅ Rollback se necessário

---

## 🗄️ **Database** (`database/`)

Scripts para backup, restore e verificação do banco de dados.

### **Scripts Disponíveis:**

#### `backup-database.ps1/.sh`
**Backup completo do banco**
```powershell
.\scripts\database\backup-database.ps1
```
- ✅ Backup com timestamp
- ✅ Compressão automática
- ✅ Verificação de integridade

#### `restore-database.ps1/.sh`
**Restore do banco de dados**
```powershell
.\scripts\database\restore-database.ps1
```
- ✅ Lista backups disponíveis
- ✅ Restore com confirmação
- ✅ Verificação pós-restore

#### `verify-backup.sh`
**Verificar integridade do backup**
```bash
./scripts/database/verify-backup.sh
```

---

## 🚀 **Deployment** (`deployment/`)

Scripts para deploy e atualizações das imagens Docker.

### **Scripts Disponíveis:**

#### `quick-update.ps1/.sh` ⭐ **MAIS USADO**
**Atualização rápida das imagens**
```powershell
# Atualizar todas as imagens
.\scripts\deployment\quick-update.ps1

# Atualizar apenas frontend
.\scripts\deployment\quick-update.ps1 -Frontend

# Atualizar apenas backend
.\scripts\deployment\quick-update.ps1 -Backend

# Atualizar apenas nginx
.\scripts\deployment\quick-update.ps1 -Nginx

# Com versão específica
.\scripts\deployment\quick-update.ps1 -Version "v1.2.0"
```

#### `build-and-push.ps1/.sh`
**Build e push completo para Docker Hub**
```powershell
.\scripts\deployment\build-and-push.ps1 -DockerUsername "dreyfreitas"
```

---

## 🧪 **Testing** (`testing/`)

Scripts para testes e diagnóstico do sistema.

### **Scripts Disponíveis:**

#### `test-docker-hub-images.ps1`
**Testar imagens do Docker Hub**
```powershell
.\scripts\testing\test-docker-hub-images.ps1
```
- ✅ Verifica imagens locais
- ✅ Testa execução
- ✅ Valida funcionamento

#### `test-print-automated.ps1`
**Teste automatizado de impressão**
```powershell
.\scripts\testing\test-print-automated.ps1
```
- ✅ Testa configuração de impressoras
- ✅ Simula impressão de comprovante
- ✅ Verifica funcionamento

#### `fix-printer.ps1`
**Diagnóstico e correção de impressoras**
```powershell
.\scripts\testing\fix-printer.ps1
```
- ✅ Lista impressoras instaladas
- ✅ Verifica status
- ✅ Sugere correções

---

## 🎯 **Fluxo de Trabalho Recomendado**

### **1. Desenvolvimento Diário**
```powershell
# Iniciar ambiente
.\scripts\docker\start-with-migrations.ps1

# Fazer alterações no código...

# Atualizar imagens
.\scripts\deployment\quick-update.ps1
```

### **2. Após Alterações no Schema**
```powershell
# Aplicar migrações
.\scripts\docker\apply-migrations.ps1
```

### **3. Backup Antes de Mudanças Importantes**
```powershell
# Backup completo
.\scripts\database\backup-database.ps1

# Fazer alterações...

# Se necessário, restaurar
.\scripts\database\restore-database.ps1
```

### **4. Deploy para Produção**
```powershell
# Build e push completo
.\scripts\deployment\build-and-push.ps1 -DockerUsername "dreyfreitas"
```

---

## 📚 **Documentação**

- `DEPLOY_SUMMARY.md` - Resumo do deploy para Docker Hub
- `DOCKER_HUB_DEPLOY.md` - Guia completo de deploy

---

## 🚨 **Troubleshooting**

### **Docker não está rodando**
```powershell
# Iniciar Docker Desktop
# Aguardar inicialização completa
# Executar script novamente
```

### **Erro de migração**
```powershell
# Fazer backup primeiro
.\scripts\database\backup-database.ps1

# Aplicar migrações
.\scripts\docker\apply-migrations.ps1
```

### **Erro de push para Docker Hub**
```powershell
# Verificar login
docker login

# Executar push novamente
.\scripts\deployment\quick-update.ps1
```

---

## 💡 **Dicas Importantes**

### **Scripts Mais Usados:**
1. `docker/start-with-migrations.ps1` - Inicialização
2. `deployment/quick-update.ps1` - Atualizações
3. `docker/apply-migrations.ps1` - Migrações
4. `database/backup-database.ps1` - Backup

### **Ordem de Execução:**
1. **Iniciar**: `start-with-migrations.ps1`
2. **Desenvolver**: Fazer alterações
3. **Migrar**: `apply-migrations.ps1` (se necessário)
4. **Atualizar**: `quick-update.ps1`
5. **Testar**: Scripts em `testing/`

### **Backup Regular:**
- ✅ Antes de mudanças importantes
- ✅ Semanalmente
- ✅ Antes de deploys

---

## 🎉 **Benefícios da Organização**

- ✅ **Fácil localização** - Scripts organizados por função
- ✅ **Menos confusão** - Sem duplicatas
- ✅ **Manutenção simples** - Estrutura clara
- ✅ **Documentação atualizada** - Guias específicos
- ✅ **Fluxo otimizado** - Scripts mais usados em destaque

---

**💡 Dica**: Use os scripts em `deployment/` para atualizações e `docker/` para gerenciar o ambiente!

---

**Última atualização**: Dezembro 2024  
**Versão**: 2.0 (Organizada)