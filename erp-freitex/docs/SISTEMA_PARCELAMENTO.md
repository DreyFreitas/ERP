# 💳 Sistema de Parcelamento - ERP Freitex

## 🎯 Visão Geral

O sistema de parcelamento do ERP Freitex permite criar vendas a prazo com parcelamento automático, onde cada parcela é gerenciada individualmente com datas de vencimento específicas.

## 🔧 Como Funciona

### **1. Configuração de Prazos de Pagamento**
- **Prazos Parcelados**: Configurados com número de parcelas e intervalo
- **Exemplo**: 4x 30/60/90/120 (4 parcelas com 30 dias de intervalo)
- **Campo `isInstallment`**: Define se o prazo permite parcelamento

### **2. Configuração de Métodos de Pagamento**
- **Métodos a Prazo**: Marcados com `isInstallmentMethod: true`
- **Vinculação**: Métodos a prazo são vinculados a prazos de pagamento

### **3. Processo de Venda Parcelada**
1. Cliente seleciona método "A Prazo"
2. Sistema mostra prazos disponíveis
3. Venda é criada com parcelas individuais
4. Cada parcela tem data de vencimento específica

## 🗄️ Estrutura do Banco de Dados

### **Tabela `sale_installments`**
```sql
CREATE TABLE sale_installments (
  id TEXT PRIMARY KEY,
  saleId TEXT NOT NULL,
  installmentNumber INTEGER NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  dueDate TIMESTAMP NOT NULL,
  paymentDate TIMESTAMP,
  status TEXT NOT NULL DEFAULT 'PENDING',
  notes TEXT,
  createdAt TIMESTAMP DEFAULT NOW(),
  updatedAt TIMESTAMP DEFAULT NOW()
);
```

### **Status das Parcelas**
- **PENDING**: Parcela pendente de pagamento
- **PAID**: Parcela paga
- **OVERDUE**: Parcela vencida
- **CANCELLED**: Parcela cancelada

## 🎨 Interface do Usuário

### **PDV - Seleção de Prazo**
- **Método "A Prazo"**: Mostra dropdown de prazos disponíveis
- **Preview de Parcelas**: Exibe parcelas antes de finalizar
- **Validação**: Cliente obrigatório para vendas a prazo

### **Página de Vendas**
- **Botão "Ver Parcelas"**: Ícone de cartão de crédito laranja
- **Modal de Parcelas**: Lista todas as parcelas da venda
- **Resumo**: Total, pago e pendente

### **Modal de Parcelas**
- **Tabela Completa**: Número, valor, vencimento, pagamento, status
- **Chips Coloridos**: Status visual das parcelas
- **Resumo Financeiro**: Total, pago e pendente

## 🔄 Fluxo de Funcionamento

### **1. Configuração Inicial**
```
Configurações → Prazos de Pagamento → Criar prazo parcelado
Configurações → Formas de Pagamento → Criar método "A Prazo"
```

### **2. Venda no PDV**
```
Selecionar cliente → Método "A Prazo" → Escolher prazo → Preview parcelas → Finalizar
```

### **3. Criação Automática**
```
Sistema cria venda → Cria parcelas individuais → Cria transações financeiras
```

### **4. Acompanhamento**
```
Vendas → Botão "Ver Parcelas" → Modal com todas as parcelas
```

## 📊 Exemplos de Configuração

### **Exemplo 1: 4x 30/60/90/120**
- **Nome**: "4x 30/60/90/120"
- **Dias**: 30 (primeira parcela)
- **Parcelas**: 4
- **Intervalo**: 30 dias
- **Resultado**: 
  - 1ª parcela: 30 dias
  - 2ª parcela: 60 dias
  - 3ª parcela: 90 dias
  - 4ª parcela: 120 dias

### **Exemplo 2: 2x 30/60**
- **Nome**: "2x 30/60"
- **Dias**: 30 (primeira parcela)
- **Parcelas**: 2
- **Intervalo**: 30 dias
- **Resultado**:
  - 1ª parcela: 30 dias
  - 2ª parcela: 60 dias

### **Exemplo 3: 30 dias direto**
- **Nome**: "30 dias"
- **Dias**: 30
- **Parcelas**: 1 (não parcelado)
- **Resultado**: Uma parcela única em 30 dias

## 🚀 Benefícios

### **Para o Vendedor**
- **Controle Automático**: Parcelas criadas automaticamente
- **Rastreabilidade**: Cada parcela gerenciada individualmente
- **Flexibilidade**: Múltiplos prazos configuráveis
- **Visualização**: Preview antes de finalizar

### **Para o Cliente**
- **Transparência**: Vê todas as parcelas antes de comprar
- **Flexibilidade**: Escolhe o prazo que preferir
- **Controle**: Sabe exatamente quando cada parcela vence

### **Para o Sistema**
- **Automação**: Processo totalmente automático
- **Integridade**: Validações robustas
- **Escalabilidade**: Suporte a qualquer número de parcelas
- **Relatórios**: Dados precisos por parcela

## 🔧 Como Configurar

### **1. Criar Prazo de Pagamento**
1. Acesse "Configurações" → "Prazos de Pagamento"
2. Clique em "Novo Prazo"
3. Preencha:
   - **Nome**: "4x 30/60/90/120"
   - **Dias**: 30
   - **Descrição**: "Pagamento em 4 parcelas"
   - **Marcar**: "É parcelado"
   - **Número de Parcelas**: 4
   - **Intervalo**: 30
4. Clique em "Criar Prazo"

### **2. Criar Método de Pagamento**
1. Acesse "Configurações" → "Formas de Pagamento"
2. Clique em "Nova Forma"
3. Preencha:
   - **Nome**: "A Prazo"
   - **Descrição**: "Pagamento parcelado"
   - **Marcar**: "É método parcelado"
   - **Cor**: Laranja (#f59e0b)
4. Clique em "Criar Forma"

### **3. Testar no PDV**
1. Acesse o PDV
2. Adicione produtos ao carrinho
3. Selecione um cliente
4. Escolha método "A Prazo"
5. Selecione o prazo configurado
6. Verifique o preview das parcelas
7. Finalize a venda

## 📋 Validações Implementadas

### **Validações de Cliente**
- **Cliente Obrigatório**: Vendas a prazo precisam de cliente
- **Crédito Ativo**: Cliente deve ter crédito ativo
- **Limite Disponível**: Verifica limite de crédito
- **Autorização**: Cliente deve permitir compras a prazo

### **Validações de Prazo**
- **Prazo Válido**: Deve existir e estar ativo
- **Configuração Correta**: Deve ter parcelas configuradas
- **Valores**: Deve ter número de parcelas e intervalo

### **Validações de Sistema**
- **Estoque**: Verifica disponibilidade
- **Valores**: Calcula corretamente valores das parcelas
- **Datas**: Calcula corretamente datas de vencimento

## 🧪 Teste do Sistema

### **Script de Teste**
Execute o arquivo `test-parcelamento.js` para testar automaticamente:

```bash
node test-parcelamento.js
```

### **Teste Manual**
1. **Configurar**: Criar prazo e método conforme documentação
2. **Vender**: Fazer venda a prazo no PDV
3. **Verificar**: Acessar vendas e clicar em "Ver Parcelas"
4. **Validar**: Confirmar que parcelas foram criadas corretamente

## 📊 Relatórios Disponíveis

### **Relatório de Parcelas**
- **Parcelas Pendentes**: Todas as parcelas não pagas
- **Parcelas Vencidas**: Parcelas com data de vencimento passada
- **Parcelas Pagas**: Parcelas já quitadas
- **Resumo por Cliente**: Parcelas agrupadas por cliente

### **Relatório Financeiro**
- **Contas a Receber**: Todas as parcelas pendentes
- **Fluxo de Caixa**: Projeção de recebimentos
- **Inadimplência**: Parcelas vencidas e não pagas

## 🚀 Próximas Melhorias

1. **Pagamento de Parcelas**: Interface para registrar pagamentos
2. **Notificações**: Alertas de vencimento de parcelas
3. **Relatórios Avançados**: Análise de inadimplência
4. **Integração**: Com sistemas de cobrança
5. **Automação**: Lembretes automáticos de vencimento
6. **Histórico**: Log de pagamentos de parcelas
7. **Desconto**: Desconto por pagamento antecipado
8. **Juros**: Cálculo de juros por atraso

## 📝 Notas Importantes

- **Cliente Obrigatório**: Vendas a prazo sempre precisam de cliente
- **Limite de Crédito**: Sistema verifica limite antes de permitir venda
- **Parcelas Individuais**: Cada parcela é gerenciada separadamente
- **Transações Financeiras**: Cada parcela gera transação financeira
- **Rastreabilidade**: Todas as parcelas são rastreáveis
- **Flexibilidade**: Sistema suporta qualquer configuração de parcelas

---

**Sistema de parcelamento implementado com sucesso!** 🎉

Agora você pode criar vendas parceladas com controle total sobre cada parcela, oferecendo flexibilidade para seus clientes e controle financeiro para sua empresa.
