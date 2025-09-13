# 🚀 ERP Freitex - Modo Desenvolvimento Ultra-Rápido

## ⚡ Início Rápido

### Opção 1 - Script Automatizado (Recomendado)
```bash
# Windows
start-fast.bat

# Linux/Mac
./start-dev.sh
```

### Opção 2 - Comando Direto
```bash
docker-compose -f docker-compose.dev.yml up -d
```

## 🌐 URLs de Acesso

- **Frontend**: http://localhost:7000 (via Nginx)
- **Backend API**: http://localhost:7000/api (via Nginx)
- **PostgreSQL**: localhost:7002
- **Adminer**: http://localhost:7004

## 🔥 Vantagens do Modo Desenvolvimento

✅ **Ultra-rápido**: 8 segundos vs 700+ segundos  
✅ **Hot-reload**: Mudanças no código são refletidas automaticamente  
✅ **Sem builds**: Usa volumes em vez de rebuilds  
✅ **Igual produção**: Acesso via Nginx na porta 7000  
✅ **Desenvolvimento real**: React Dev Server + Node Dev Server  

## 🛠️ Como Funciona

### Frontend
- Usa `node:18-alpine` com volume mount
- React Dev Server na porta 3000 (interno)
- Nginx proxy para porta 7000 (externo)
- Hot-reload automático

### Backend
- Usa `node:18-alpine` com volume mount
- Node Dev Server com nodemon na porta 7001 (interno)
- Nginx proxy para porta 7000/api (externo)
- Restart automático em mudanças

### Banco de Dados
- PostgreSQL 15 com dados persistentes
- Redis para cache
- Adminer para gerenciamento

## 📁 Estrutura de Arquivos

```
erp-freitex/
├── docker/
│   ├── docker-compose.dev.yml    # Modo desenvolvimento
│   ├── docker-compose.yml        # Modo produção
│   ├── start-fast.bat           # Script Windows
│   ├── start-dev.sh             # Script Linux/Mac
│   └── README-DEV.md            # Esta documentação
├── frontend/                    # Código React (volume mount)
└── backend/                     # Código Node.js (volume mount)
```

## 🔧 Comandos Úteis

### Parar os serviços
```bash
docker-compose -f docker-compose.dev.yml down
```

### Ver logs em tempo real
```bash
# Todos os serviços
docker-compose -f docker-compose.dev.yml logs -f

# Apenas frontend
docker-compose -f docker-compose.dev.yml logs -f frontend

# Apenas backend
docker-compose -f docker-compose.dev.yml logs -f backend
```

### Reiniciar um serviço específico
```bash
docker-compose -f docker-compose.dev.yml restart frontend
docker-compose -f docker-compose.dev.yml restart backend
```

### Entrar no container
```bash
# Frontend
docker-compose -f docker-compose.dev.yml exec frontend sh

# Backend
docker-compose -f docker-compose.dev.yml exec backend sh
```

## 🐛 Troubleshooting

### Frontend não carrega
1. Verifique se o React Dev Server está rodando:
   ```bash
   docker-compose -f docker-compose.dev.yml logs frontend
   ```

2. Reinicie o frontend:
   ```bash
   docker-compose -f docker-compose.dev.yml restart frontend
   ```

### Backend não responde
1. Verifique se o Node Dev Server está rodando:
   ```bash
   docker-compose -f docker-compose.dev.yml logs backend
   ```

2. Reinicie o backend:
   ```bash
   docker-compose -f docker-compose.dev.yml restart backend
   ```

### Banco de dados não conecta
1. Verifique se o PostgreSQL está healthy:
   ```bash
   docker-compose -f docker-compose.dev.yml ps
   ```

2. Reinicie o banco:
   ```bash
   docker-compose -f docker-compose.dev.yml restart postgres
   ```

## 🚀 Migração para Produção

Para usar em produção, use o docker-compose.yml original:
```bash
docker-compose -f docker-compose.dev.yml down
docker-compose up -d --build
```

## 📝 Notas Importantes

- **Desenvolvimento**: Use `docker-compose.dev.yml` (hot-reload)
- **Produção**: Use `docker-compose.yml` (build otimizado)
- **Dados**: PostgreSQL e Redis mantêm dados entre reinicializações
- **Performance**: Modo dev é 100x mais rápido que build completo
