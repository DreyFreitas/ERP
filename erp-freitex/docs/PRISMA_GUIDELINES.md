# 🚨 Guia de Boas Práticas - Prisma

## ⚠️ NUNCA APAGUE O BANCO DE DADOS EM PRODUÇÃO

### ❌ COMANDOS PROIBIDOS EM PRODUÇÃO:
```bash
npx prisma migrate reset  # APAGA TUDO!
npx prisma db push --force-reset  # APAGA TUDO!
```

### ✅ COMANDOS SEGUROS:

#### 1. **Desenvolvimento (apenas quando não há dados importantes)**
```bash
# Criar nova migration
npx prisma migrate dev --name nome_da_mudanca

# Aplicar migrations pendentes
npx prisma migrate deploy

# Gerar cliente Prisma
npx prisma generate
```

#### 2. **Produção (sempre usar)**
```bash
# Aplicar migrations sem reset
npx prisma migrate deploy

# Gerar cliente Prisma
npx prisma generate
```

### 🔄 Fluxo Correto para Mudanças no Schema:

1. **Fazer mudanças no `schema.prisma`**
2. **Criar migration:**
   ```bash
   npx prisma migrate dev --name descricao_da_mudanca
   ```
3. **Verificar se a migration foi criada corretamente**
4. **Em produção, aplicar com:**
   ```bash
   npx prisma migrate deploy
   ```

### 🛡️ Backup Antes de Qualquer Mudança:

```bash
# Backup do banco (PostgreSQL)
pg_dump -h localhost -U postgres -d erp_freitex > backup_$(date +%Y%m%d_%H%M%S).sql

# Restaurar se necessário
psql -h localhost -U postgres -d erp_freitex < backup_arquivo.sql
```

### 📋 Checklist Antes de Fazer Mudanças:

- [ ] Backup do banco atual
- [ ] Verificar se há dados importantes
- [ ] Testar em ambiente de desenvolvimento
- [ ] Usar `migrate dev` em vez de `migrate reset`
- [ ] Verificar se a migration foi criada corretamente

### 🚨 Quando o Prisma Detecta "Drift":

Se aparecer a mensagem "Drift detected", NÃO use reset. Em vez disso:

1. **Verificar o que mudou:**
   ```bash
   npx prisma migrate diff --from-schema-datamodel prisma/schema.prisma --to-database-url DATABASE_URL
   ```

2. **Criar migration específica:**
   ```bash
   npx prisma migrate dev --name fix_drift_issues
   ```

3. **Se necessário, fazer ajustes manuais no SQL da migration**

### 🔧 Scripts Úteis:

```bash
# Verificar status das migrations
npx prisma migrate status

# Ver histórico de migrations
npx prisma migrate diff --from-empty --to-schema-datamodel prisma/schema.prisma

# Validar schema
npx prisma validate
```

### 📞 Em Caso de Emergência:

Se algo der errado e você precisar reverter:

1. **NÃO use reset**
2. **Use o backup criado**
3. **Crie uma migration de rollback**
4. **Consulte a documentação do Prisma**

---

**Lembre-se: Dados de produção são sagrados! Sempre faça backup antes de qualquer mudança.**
