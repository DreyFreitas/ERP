# Scripts de Gerenciamento do Banco de Dados - ERP Freitex

Este diretório contém scripts para gerenciar o banco de dados de forma segura.

## 📋 Scripts Disponíveis

### 1. `backup-database.sh`
**Função:** Fazer backup completo do banco de dados PostgreSQL

**Uso:**
```bash
./backup-database.sh [nome_do_backup]
```

**Exemplo:**
```bash
./backup-database.sh backup_diario
```

### 2. `restore-database.sh`
**Função:** Restaurar banco de dados a partir de um backup

**Uso:**
```bash
./restore-database.sh [arquivo_backup]
```

**Exemplo:**
```bash
./restore-database.sh ./backups/backup_diario.sql
```

### 3. `safe-migration.sh`
**Função:** Executar migrações do Prisma de forma segura (com backup automático)

**Uso:**
```bash
./safe-migration.sh
```

## 🛡️ Proteções Implementadas

### Backup Automático
- ✅ Backup automático antes de qualquer migração
- ✅ Verificação de integridade dos dados
- ✅ Restore automático em caso de erro

### Verificações de Segurança
- ✅ Confirmação do usuário antes de operações críticas
- ✅ Verificação de existência de arquivos
- ✅ Validação de integridade dos dados

## 📁 Estrutura de Backups

```
scripts/
├── backups/                    # Diretório de backups
│   ├── backup_20240816_120000.sql
│   ├── pre_migration_20240816_120500.sql
│   └── ...
├── backup-database.sh          # Script de backup
├── restore-database.sh         # Script de restore
├── safe-migration.sh           # Script de migração segura
└── README.md                   # Esta documentação
```

## 🚨 Regras Importantes

1. **SEMPRE use `safe-migration.sh`** para migrações do Prisma
2. **NUNCA execute migrações** sem backup prévio
3. **Mantenha backups regulares** do banco de dados
4. **Teste restores** em ambiente de desenvolvimento

## 🔧 Como Usar

### Windows (PowerShell)
```powershell
cd scripts
.\backup-database.ps1 meu_backup
.\safe-migration.ps1
.\restore-database.ps1 .\backups\meu_backup.sql
```

### Linux/Mac (Bash)
```bash
cd scripts
chmod +x backup-database.sh
./backup-database.sh meu_backup
./safe-migration.sh
./restore-database.sh ./backups/meu_backup.sql
```

## 📊 Monitoramento

Os scripts incluem verificações automáticas:
- Contagem de registros nas tabelas principais
- Verificação de integridade após operações
- Logs detalhados de todas as operações

## ⚠️ Avisos Importantes

- **Backups são essenciais** antes de qualquer mudança no banco
- **Teste sempre** em ambiente de desenvolvimento primeiro
- **Mantenha múltiplos backups** em locais diferentes
- **Documente todas as operações** realizadas no banco
