# Scripts de Correção - ERP Freitex

## Problema Resolvido

### Erro de Constraint Único
**Erro**: `Unique constraint failed on the fields: (productId, sku)`

**Causa**: Os constraints únicos na tabela `product_variations` não permitiam valores nulos, causando conflito quando variações eram criadas com SKUs vazios ou nulos.

**Solução**: Criamos constraints únicos condicionais que só se aplicam quando os valores não são nulos.

## Scripts Disponíveis

### 1. `fix-product-constraints.sql`
- Verifica produtos e variações com SKUs/códigos de barras duplicados
- Remove variações duplicadas (mantém apenas a mais recente)
- Útil para limpeza de dados

### 2. `fix-unique-constraints.sql`
- Remove constraints únicos antigas
- Cria constraints únicos condicionais que permitem valores nulos
- Resolve o problema de constraint único

## Como Usar

### Executar Scripts
```bash
# Verificar dados duplicados
Get-Content scripts/fix-product-constraints.sql | docker exec -i docker-postgres-1 psql -U postgres -d erp_freitex

# Corrigir constraints únicos
Get-Content scripts/fix-unique-constraints.sql | docker exec -i docker-postgres-1 psql -U postgres -d erp_freitex
```

### Constraints Corrigidas
- `unique_variation_sku_per_product`: Permite SKUs nulos
- `unique_variation_barcode_per_product`: Permite códigos de barras nulos

## Prevenção

Para evitar problemas futuros:
1. Sempre validar SKUs antes de criar variações
2. Usar filtros para remover SKUs vazios
3. Garantir que SKUs sejam únicos por produto quando não nulos

## Notas Importantes

- Os scripts são seguros e não apagam dados importantes
- Sempre faça backup antes de executar scripts em produção
- Execute os scripts em ambiente de desenvolvimento primeiro
