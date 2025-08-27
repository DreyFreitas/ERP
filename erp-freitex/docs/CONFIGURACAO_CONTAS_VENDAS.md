# 💰 Configuração de Contas por Método de Pagamento

## 🎯 Funcionalidade Implementada

O sistema agora permite configurar qual conta financeira cada método de pagamento deve usar, criando uma integração completa entre vendas e finanças.

## 🔧 Como Funciona

### **1. Configuração de Métodos de Pagamento**
- Cada método de pagamento pode ter uma conta financeira vinculada
- Configuração opcional - se não configurado, usa conta de caixa padrão
- Interface intuitiva na página de Configurações

### **2. Integração Automática**
- Vendas criam automaticamente transações financeiras
- Transações vão para a conta configurada no método de pagamento
- Saldo da conta é atualizado automaticamente

### **3. Contas a Receber**
- Métodos de pagamento a prazo criam transações pendentes
- Contas a receber são gerenciadas automaticamente
- Sistema de cobrança integrado

## 🎨 Interface de Configuração

### **Página de Configurações**
- **Seção "Formas de Pagamento"**: Lista todos os métodos
- **Campo "Conta Financeira"**: Dropdown para selecionar conta
- **Chip Informativo**: Mostra conta vinculada no card

### **Modal de Criação/Edição**
- **Campo Obrigatório**: Nome do método
- **Campo Opcional**: Conta Financeira
- **Validação**: Permite salvar sem conta (usa padrão)

## 🔄 Fluxo de Funcionamento

### **1. Configuração Inicial**
```
Usuário acessa Configurações → Formas de Pagamento → Edita método → Seleciona conta → Salva
```

### **2. Venda no PDV**
```
Usuário finaliza venda → Sistema verifica método de pagamento → Busca conta configurada → Cria transação
```

### **3. Transação Financeira**
```
Se há conta configurada → Usa conta específica
Se não há conta configurada → Usa conta de caixa padrão
```

## 📊 Tipos de Conta Suportados

### **Contas de Receita**
- **Caixa**: Para pagamentos à vista
- **Banco**: Para transferências/depósitos
- **Cartão de Crédito**: Para vendas com cartão
- **PIX**: Para pagamentos instantâneos

### **Contas a Receber**
- **Contas a Receber**: Para vendas a prazo
- **Cheques**: Para pagamentos com cheque
- **Boleto**: Para pagamentos bancários

## 🎯 Exemplos de Configuração

### **Exemplo 1: Dinheiro**
- **Método**: Dinheiro
- **Conta**: Caixa Principal
- **Resultado**: Vendas em dinheiro vão direto para caixa

### **Exemplo 2: Cartão de Crédito**
- **Método**: Cartão de Crédito
- **Conta**: Banco Principal
- **Resultado**: Vendas com cartão vão para conta bancária

### **Exemplo 3: Venda a Prazo**
- **Método**: Venda a Prazo (30 dias)
- **Conta**: Contas a Receber
- **Resultado**: Cria transação pendente para cobrança

### **Exemplo 4: PIX**
- **Método**: PIX
- **Conta**: Conta PIX
- **Resultado**: Vendas PIX vão para conta específica

## 🔧 Implementação Técnica

### **Banco de Dados**
```sql
-- Campo adicionado ao modelo PaymentMethod
accountId String? // Conta financeira vinculada

-- Relacionamento com FinancialAccount
account FinancialAccount? @relation(fields: [accountId], references: [id])
```

### **Backend**
```typescript
// Verificação de conta configurada
if (paymentMethod.accountId) {
  // Usar conta específica
  targetAccount = await prisma.financialAccount.findFirst({
    where: { id: paymentMethod.accountId }
  });
} else {
  // Usar conta de caixa padrão
  targetAccount = await prisma.financialAccount.findFirst({
    where: { accountType: 'CASH' }
  });
}
```

### **Frontend**
```typescript
// Campo no formulário
<FormControl fullWidth>
  <InputLabel>Conta Financeira</InputLabel>
  <Select value={accountId} onChange={handleAccountChange}>
    {accounts.map(account => (
      <MenuItem value={account.id}>
        {account.name} ({account.accountType})
      </MenuItem>
    ))}
  </Select>
</FormControl>
```

## 🚀 Benefícios

### **Para o Vendedor**
- **Controle Automático**: Não precisa escolher conta manualmente
- **Organização**: Cada método vai para conta correta
- **Rastreabilidade**: Sabe exatamente onde está o dinheiro

### **Para o Financeiro**
- **Separação Clara**: Dinheiro organizado por origem
- **Relatórios Precisos**: Dados separados por método
- **Controle de Caixa**: Saldo real de cada conta

### **Para o Sistema**
- **Automação**: Processo totalmente automático
- **Flexibilidade**: Configuração por empresa
- **Escalabilidade**: Suporte a múltiplas contas

## 📋 Checklist de Configuração

### **1. Criar Contas Financeiras**
- [ ] Acessar "Financeiro" → "Contas"
- [ ] Criar conta para cada método de pagamento
- [ ] Configurar tipo de conta (CASH, BANK, RECEIVABLE)

### **2. Configurar Métodos de Pagamento**
- [ ] Acessar "Configurações" → "Formas de Pagamento"
- [ ] Editar cada método
- [ ] Selecionar conta correspondente
- [ ] Salvar configuração

### **3. Testar Integração**
- [ ] Fazer venda no PDV
- [ ] Verificar transação na área financeira
- [ ] Confirmar que foi para conta correta

## 🎯 Cenários de Uso

### **Cenário 1: Loja com Múltiplas Contas**
1. **Conta Caixa**: Para dinheiro e PIX
2. **Conta Banco**: Para cartões e transferências
3. **Conta a Receber**: Para vendas a prazo
4. **Resultado**: Dinheiro organizado automaticamente

### **Cenário 2: Loja Simples**
1. **Conta Única**: Caixa Principal
2. **Configuração**: Todos os métodos apontam para mesma conta
3. **Resultado**: Sistema funciona normalmente

### **Cenário 3: Controle de Comissões**
1. **Conta Vendedor A**: Para vendas do vendedor A
2. **Conta Vendedor B**: Para vendas do vendedor B
3. **Resultado**: Controle automático de comissões

## 🚀 Próximas Melhorias

1. **Múltiplas Contas por Método**: Diferentes contas por período
2. **Contas por Vendedor**: Contas específicas por vendedor
3. **Contas por Loja**: Contas específicas por filial
4. **Integração Bancária**: Conexão direta com bancos
5. **Relatórios Avançados**: Análise por método de pagamento
6. **Alertas**: Notificações de saldo baixo
7. **Backup**: Exportação de configurações
8. **Histórico**: Log de mudanças de configuração

---

**Sistema de configuração de contas implementado com sucesso!** 🎉

Agora cada venda vai automaticamente para a conta correta, organizando o financeiro da empresa de forma profissional e automática.
