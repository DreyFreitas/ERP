# Scripts de Automação - ERP Freitex Softwares

Este diretório contém scripts para automatizar tarefas comuns do ambiente de desenvolvimento.

## 📋 Scripts Disponíveis

### 🚀 `start-with-migrations.ps1` (Windows)
Script completo para iniciar o ambiente Docker e aplicar migrações automaticamente.

**Uso:**
```powershell
.\scripts\start-with-migrations.ps1
```

**O que faz:**
- ✅ Verifica se o Docker está rodando
- ✅ Inicia todos os containers com `docker-compose up -d`
- ✅ Aplica migrações do Prisma automaticamente
- ✅ Gera o cliente Prisma
- ✅ Verifica se os serviços estão funcionando
- ✅ Exibe URLs de acesso

### 🔄 `apply-migrations.ps1` (Windows)
Script para aplicar migrações do Prisma quando o ambiente já está rodando.

**Uso:**
```powershell
.\scripts\apply-migrations.ps1
```

**O que faz:**
- ✅ Verifica se o container do backend está rodando
- ✅ Aplica migrações pendentes
- ✅ Regenera o cliente Prisma
- ✅ Reinicia o backend
- ✅ Verifica se está funcionando

### 🔄 `apply-migrations.sh` (Linux/Mac)
Versão bash do script de migrações para sistemas Unix.

**Uso:**
```bash
chmod +x scripts/apply-migrations.sh
./scripts/apply-migrations.sh
```

## 🎯 Quando Usar

### Primeira vez ou após mudanças no schema:
```powershell
.\scripts\start-with-migrations.ps1
```

### Apenas aplicar migrações (ambiente já rodando):
```powershell
.\scripts\apply-migrations.ps1
```

### Após alterações no schema.prisma:
```powershell
.\scripts\apply-migrations.ps1
```

## 🔧 Comandos Manuais

Se preferir executar manualmente:

```powershell
# Aplicar migrações
docker exec docker-backend-1 npx prisma migrate deploy

# Gerar cliente Prisma
docker exec docker-backend-1 npx prisma generate

# Reiniciar backend
docker restart docker-backend-1
```

## 🚨 Solução de Problemas

### Erro: "Container não está rodando"
```powershell
# Inicie o ambiente primeiro
cd docker
docker-compose up -d
```

### Erro: "Tabela não existe"
```powershell
# Execute o script de migrações
.\scripts\apply-migrations.ps1
```

### Erro: "Docker não está rodando"
- Inicie o Docker Desktop
- Aguarde a inicialização completa
- Execute o script novamente

## 📝 Logs e Debug

Para ver logs em tempo real:
```powershell
cd docker
docker-compose logs -f
```

Para ver logs de um serviço específico:
```powershell
docker logs docker-backend-1 -f
```

## 🔄 Fluxo de Desenvolvimento Recomendado

1. **Iniciar ambiente:**
   ```powershell
   .\scripts\start-with-migrations.ps1
   ```

2. **Fazer alterações no schema.prisma**

3. **Criar nova migração:**
   ```powershell
   docker exec docker-backend-1 npx prisma migrate dev --name nome_da_migracao
   ```

4. **Aplicar migrações:**
   ```powershell
   .\scripts\apply-migrations.ps1
   ```

5. **Desenvolver e testar**

## 🎉 Benefícios

- ✅ **Automatização completa** - Não precisa lembrar comandos
- ✅ **Verificação de erros** - Scripts param se algo der errado
- ✅ **Feedback visual** - Cores e emojis para facilitar leitura
- ✅ **Cross-platform** - Scripts para Windows e Unix
- ✅ **Prevenção de erros** - Evita problemas de migrações não aplicadas

---

**💡 Dica:** Sempre execute os scripts após fazer alterações no schema do Prisma para evitar erros de tabelas não existentes!
