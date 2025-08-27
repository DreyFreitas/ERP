# 📦 Sistema de Estoque com Variações - ERP Freitex

## Visão Geral

O sistema de estoque do ERP Freitex possui suporte completo a variações de produtos, permitindo controle granular de estoque por tamanho, cor, modelo e outras características específicas de cada produto.

## 🏗️ Arquitetura

### Banco de Dados

#### Tabela `products`
- Produto principal com informações gerais
- Estoque mínimo e máximo configuráveis
- Relacionamento com categorias e fornecedores

#### Tabela `product_variations`
- Variações específicas de cada produto
- Controle individual de estoque por variação
- Campos: tamanho, cor, modelo, SKU, código de barras
- Constraints únicos por produto (permite valores nulos)

#### Tabela `stock_movements`
- Histórico completo de movimentações
- Suporte a variações específicas (`variationId`)
- Tipos: ENTRY, EXIT, ADJUSTMENT, TRANSFER
- Rastreamento de custos e documentos de referência

## 🔧 Funcionalidades

### 1. Entrada de Estoque

#### Entrada Simples (Produto sem Variações)
```json
POST /api/stock/entry
{
  "productId": "uuid",
  "quantity": 10,
  "unitCost": 25.50,
  "referenceDocument": "NF-001",
  "notes": "Entrada inicial"
}
```

#### Entrada por Variação
```json
POST /api/stock/entry
{
  "productId": "uuid",
  "variationId": "uuid",
  "quantity": 5,
  "unitCost": 25.50,
  "referenceDocument": "NF-001",
  "notes": "Entrada camiseta P azul"
}
```

#### Entrada em Lote (Múltiplas Variações)
```json
POST /api/stock/entry/batch
{
  "productId": "uuid",
  "entries": [
    {
      "variationId": "uuid-1",
      "quantity": 5,
      "unitCost": 25.50
    },
    {
      "variationId": "uuid-2", 
      "quantity": 3,
      "unitCost": 25.50
    }
  ],
  "referenceDocument": "NF-001",
  "notes": "Entrada em lote"
}
```

### 2. Saída de Estoque

#### Saída Simples
```json
POST /api/stock/exit
{
  "productId": "uuid",
  "quantity": 2,
  "referenceDocument": "Venda-001",
  "notes": "Venda para cliente"
}
```

#### Saída por Variação
```json
POST /api/stock/exit
{
  "productId": "uuid",
  "variationId": "uuid",
  "quantity": 1,
  "referenceDocument": "Venda-001",
  "notes": "Venda camiseta P azul"
}
```

### 3. Ajuste de Estoque

#### Ajuste Simples
```json
POST /api/stock/adjust
{
  "productId": "uuid",
  "newQuantity": 15,
  "reason": "Inventário físico",
  "notes": "Ajuste após contagem"
}
```

#### Ajuste por Variação
```json
POST /api/stock/adjust
{
  "productId": "uuid",
  "variationId": "uuid",
  "newQuantity": 8,
  "reason": "Inventário físico",
  "notes": "Ajuste camiseta P azul"
}
```

## 📊 Consultas e Relatórios

### Estoque Atual
```http
GET /api/stock/current?categoryId=uuid&lowStock=true&outOfStock=true
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "uuid",
        "name": "Camiseta Básica",
        "sku": "CAM001",
        "category": { "id": "uuid", "name": "Roupas" },
        "variations": [
          {
            "id": "uuid",
            "size": "P",
            "color": "Azul",
            "stockQuantity": 10,
            "salePrice": 29.90
          }
        ],
        "totalStock": 10,
        "totalValue": 299.00,
        "hasLowStock": false,
        "isOutOfStock": false
      }
    ],
    "stats": {
      "totalProducts": 1,
      "totalStock": 10,
      "totalValue": 299.00,
      "lowStockCount": 0,
      "outOfStockCount": 0
    }
  }
}
```

### Movimentações de Estoque
```http
GET /api/stock/movements?productId=uuid&movementType=ENTRY&startDate=2024-01-01&endDate=2024-12-31
```

**Resposta:**
```json
{
  "success": true,
  "data": {
    "movements": [
      {
        "id": "uuid",
        "productId": "uuid",
        "variationId": "uuid",
        "movementType": "ENTRY",
        "quantity": 10,
        "unitCost": 25.50,
        "totalCost": 255.00,
        "referenceDocument": "NF-001",
        "notes": "Entrada inicial",
        "createdAt": "2024-01-15T10:30:00Z",
        "product": {
          "id": "uuid",
          "name": "Camiseta Básica",
          "sku": "CAM001"
        },
        "variation": {
          "id": "uuid",
          "size": "P",
          "color": "Azul",
          "model": "Básica"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 1,
      "pages": 1
    }
  }
}
```

## 🎯 Interface do Usuário

### Modal de Entrada de Estoque

1. **Seleção de Produto**: Dropdown com todos os produtos da empresa
2. **Detecção de Variações**: Sistema detecta automaticamente se o produto tem variações
3. **Interface por Variação**: Se tem variações, mostra entrada individual por variação
4. **Interface Simples**: Se não tem variações, mostra entrada simples
5. **Campos Obrigatórios**:
   - Produto (obrigatório)
   - Quantidade (obrigatório)
   - Custo Unitário (opcional)
   - Documento de Referência (opcional)
   - Observações (opcional)

### Modal de Saída de Estoque

1. **Verificação de Estoque**: Sistema verifica disponibilidade antes de permitir saída
2. **Saída por Variação**: Permite saída específica por variação
3. **Distribuição Automática**: Se não especificar variação, distribui entre variações disponíveis
4. **Validação**: Impede saída maior que estoque disponível

### Modal de Ajuste de Estoque

1. **Ajuste por Variação**: Permite ajustar estoque específico por variação
2. **Cálculo Automático**: Calcula diferença e registra como entrada ou saída
3. **Histórico**: Mantém registro completo do ajuste

## 🔍 Filtros e Busca

### Filtros de Estoque Atual
- **Categoria**: Filtrar por categoria de produto
- **Estoque Baixo**: Mostrar apenas produtos com estoque baixo
- **Sem Estoque**: Mostrar apenas produtos sem estoque

### Filtros de Movimentações
- **Produto**: Filtrar por produto específico
- **Tipo de Movimentação**: ENTRY, EXIT, ADJUSTMENT, TRANSFER
- **Período**: Filtrar por data de início e fim
- **Variação**: Filtrar por variação específica

## 📈 Estatísticas

### Dashboard de Estoque
- **Total de Produtos**: Número total de produtos cadastrados
- **Total em Estoque**: Quantidade total em estoque
- **Estoque Baixo**: Produtos com estoque abaixo do mínimo
- **Sem Estoque**: Produtos com estoque zero

### Relatórios Disponíveis
- Estoque atual por produto e variação
- Histórico de movimentações
- Produtos com estoque baixo
- Valor total em estoque
- Movimentações por período

## 🚀 Melhorias Implementadas

### 1. Constraints Únicos Corrigidos
- Permite valores nulos em SKUs e códigos de barras
- Evita conflitos com variações sem identificação específica

### 2. Entrada em Lote
- Permite registrar entrada para múltiplas variações de uma vez
- Otimiza processo de entrada de mercadorias

### 3. Validações Robustas
- Verifica existência de produtos e variações
- Valida estoque disponível antes de saídas
- Previne movimentações inválidas

### 4. Rastreabilidade Completa
- Histórico completo de todas as movimentações
- Rastreamento de custos e documentos
- Auditoria por usuário e data/hora

## 🔧 Como Usar

### 1. Criar Produto com Variações
1. Acesse "Produtos" no menu
2. Clique em "Novo Produto"
3. Preencha informações básicas
4. Adicione variações (tamanho, cor, modelo)
5. Salve o produto

### 2. Registrar Entrada de Estoque
1. Acesse "Gestão de Estoque"
2. Clique no ícone "+" ao lado do produto
3. Selecione o produto
4. Se tem variações, preencha quantidade por variação
5. Se não tem variações, preencha quantidade geral
6. Adicione custo unitário e documento de referência
7. Clique em "Registrar Entrada"

### 3. Registrar Saída de Estoque
1. Clique no ícone "-" ao lado do produto
2. Selecione o produto
3. Escolha variação específica (se aplicável)
4. Informe quantidade
5. Adicione documento de referência
6. Clique em "Registrar Saída"

### 4. Ajustar Estoque
1. Clique no ícone de edição ao lado do produto
2. Selecione o produto
3. Escolha variação específica (se aplicável)
4. Informe nova quantidade
5. Adicione motivo do ajuste
6. Clique em "Ajustar Estoque"

## 📝 Notas Importantes

- **Estoque Mínimo**: Configure estoque mínimo para alertas automáticos
- **Custos**: Registre custos para cálculo de margem de lucro
- **Documentos**: Sempre informe documento de referência para rastreabilidade
- **Observações**: Use observações para detalhes importantes
- **Variações**: Produtos sem variações usam controle de estoque simples
- **Histórico**: Todas as movimentações são registradas para auditoria

---

**Sistema completo e funcional para controle de estoque com variações!** 🎉
