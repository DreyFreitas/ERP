# 🛒 PDV com Suporte a Variações

## 🎯 Funcionalidade Implementada

O PDV (Ponto de Venda) agora suporta produtos com variações, permitindo que o usuário selecione a variação específica (tamanho, cor, modelo) ao adicionar um produto ao carrinho.

## 🔄 Fluxo de Funcionamento

### 1. **Seleção de Produto**
```
Usuário clica em produto → Sistema verifica se tem variações
```

### 2. **Produto SEM Variações**
```
Produto adicionado diretamente ao carrinho
```

### 3. **Produto COM Variações**
```
Modal de seleção abre → Usuário escolhe variação → Define quantidade → Adiciona ao carrinho
```

## 🎨 Interface do Usuário

### **Card do Produto**
- **Indicador de Variações**: Chip azul mostra "X variação(ões)" quando aplicável
- **Preço Base**: Mostra o preço base do produto
- **Status**: Chip verde "Disponível"

### **Modal de Seleção de Variações**
- **Título**: "Selecionar Variação" + nome do produto
- **Lista de Variações**: Cards clicáveis com:
  - Tamanho, Cor, Modelo
  - SKU da variação
  - Estoque disponível
  - Preço da variação
  - Indicador "Sem Estoque" quando aplicável
- **Controle de Quantidade**: Botões +/- e campo numérico
- **Resumo**: Mostra seleção e total
- **Botões**: Cancelar / Adicionar ao Carrinho

## 🔧 Implementação Técnica

### **Estados Adicionados**
```typescript
const [variationDialog, setVariationDialog] = useState(false);
const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);
const [selectedVariation, setSelectedVariation] = useState<any | null>(null);
const [variationQuantity, setVariationQuantity] = useState(1);
```

### **Funções Principais**

#### `addToCart(product)`
```typescript
// Verifica se produto tem variações
if (product.variations && product.variations.length > 0) {
  // Abre modal de seleção
  setSelectedProduct(product);
  setVariationDialog(true);
} else {
  // Adiciona diretamente
  addProductToCart(product);
}
```

#### `addProductToCart(product, variation?, quantity)`
```typescript
// Cria nome da variação
const itemName = variation 
  ? `${product.name} - ${variation.size} ${variation.color} ${variation.model}`.trim()
  : product.name;

// Adiciona ao carrinho com variationId
return [...prevCart, {
  id: `${product.id}-${variation?.id || 'base'}-${Date.now()}`,
  productId: product.id,
  variationId: variation?.id || null,
  name: itemName,
  price: variation?.salePrice || product.salePrice,
  quantity: quantity,
  sku: variation?.sku || product.sku
}];
```

### **Interface CartItem Atualizada**
```typescript
interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
  sku?: string;
  productId: string;
  variationId?: string; // ✅ Novo campo
}
```

## 📱 Experiência do Usuário

### **1. Produtos Sem Variações**
- Comportamento normal
- Adiciona diretamente ao carrinho
- Nome: "Nome do Produto"

### **2. Produtos Com Variações**
- Modal de seleção abre automaticamente
- Usuário vê todas as variações disponíveis
- Pode selecionar quantidade
- Nome no carrinho: "Nome do Produto - Tamanho Cor Modelo"

### **3. Controle de Estoque**
- Mostra estoque disponível por variação
- Impede adicionar mais que o estoque
- Indica "Sem Estoque" quando necessário

### **4. Carrinho Inteligente**
- Itens com variações são separados
- Mesma variação aumenta quantidade
- Diferentes variações = itens separados

## 🎯 Benefícios

### **Para o Vendedor**
- **Precisão**: Vende a variação correta
- **Controle**: Acompanha estoque por variação
- **Clareza**: Nome claro no carrinho e nota fiscal

### **Para o Cliente**
- **Escolha**: Seleciona exatamente o que quer
- **Informação**: Vê preço e estoque da variação
- **Confiança**: Sabe que receberá a variação correta

### **Para o Sistema**
- **Rastreabilidade**: Registra qual variação foi vendida
- **Estoque**: Atualiza estoque da variação específica
- **Relatórios**: Dados precisos por variação

## 🔄 Integração com Vendas

### **Criação da Venda**
```typescript
const saleData: CreateSaleData = {
  items: cart.map(item => ({
    productId: item.productId,
    variationId: item.variationId, // ✅ Incluído
    quantity: item.quantity,
    unitPrice: item.price,
    discount: 0
  }))
};
```

### **Backend**
- Recebe `variationId` nos itens
- Atualiza estoque da variação específica
- Registra movimento de estoque por variação

## 🧪 Cenários de Teste

### **Cenário 1: Produto Simples**
1. Clica em produto sem variações
2. Produto adicionado diretamente ao carrinho
3. Nome: "Camisa Básica"

### **Cenário 2: Produto com Variações**
1. Clica em produto com variações
2. Modal abre mostrando todas as variações
3. Seleciona "P Azul"
4. Define quantidade: 2
5. Adiciona ao carrinho
6. Nome: "Blusa de Frio - P Azul Básica"

### **Cenário 3: Múltiplas Variações**
1. Adiciona "P Azul" (quantidade: 1)
2. Adiciona "M Vermelho" (quantidade: 1)
3. Carrinho mostra 2 itens separados
4. Cada um com nome e preço específicos

### **Cenário 4: Estoque Insuficiente**
1. Seleciona variação com estoque: 3
2. Tenta adicionar quantidade: 5
3. Sistema impede e mostra limite
4. Máximo permitido: 3

## 🚀 Próximas Melhorias

1. **Busca por Variação**: Filtrar produtos por tamanho/cor
2. **Favoritos**: Variações mais vendidas em destaque
3. **Atalhos**: Teclas de atalho para variações comuns
4. **Imagens**: Mostrar imagem da variação selecionada
5. **Sugestões**: Sugerir variações baseado no histórico

---

**PDV com variações implementado com sucesso!** 🎉

