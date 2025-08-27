# 🔄 Sistema de Despesas Recorrentes

## 🎯 Funcionalidade Implementada

O sistema agora suporta despesas recorrentes, permitindo configurar despesas que se repetem automaticamente em intervalos definidos (diário, semanal, mensal, trimestral, semestral, anual).

## 🔧 Como Funciona

### **1. Criação de Despesa Recorrente**
- Ao criar uma transação do tipo "Despesa", aparece checkbox "Esta despesa é recorrente?"
- Se marcado, campos adicionais aparecem para configurar a recorrência
- Sistema gera automaticamente novas transações baseado na configuração

### **2. Tipos de Recorrência Suportados**
- **Diária**: Repete todos os dias
- **Semanal**: Repete a cada semana
- **Mensal**: Repete a cada mês (padrão)
- **Trimestral**: Repete a cada 3 meses
- **Semestral**: Repete a cada 6 meses
- **Anual**: Repete a cada ano

### **3. Configurações Disponíveis**
- **Intervalo**: Quantidade de períodos entre cada repetição
- **Data Final**: Data limite para parar a recorrência (opcional)
- **Recorrência Indefinida**: Se não definir data final

## 🎨 Interface do Usuário

### **Modal de Nova Transação**
- **Checkbox "Esta despesa é recorrente?"**: Aparece apenas para despesas
- **Tipo de Recorrência**: Dropdown com todas as opções
- **Intervalo**: Campo numérico para definir frequência
- **Data Final**: Campo de data opcional

### **Tab "Despesas Recorrentes"**
- **Lista de despesas recorrentes**: Todas as despesas configuradas
- **Botão "Gerar Transações Recorrentes"**: Executa geração manual
- **Informações detalhadas**: Tipo, intervalo, próxima data, status

## 🔄 Fluxo de Funcionamento

### **1. Criação da Despesa Recorrente**
```
Usuário cria despesa → Marca como recorrente → Configura tipo e intervalo → Salva
```

### **2. Geração Automática**
```
Sistema verifica despesas recorrentes → Calcula próxima data → Cria nova transação → Atualiza saldo
```

### **3. Controle de Recorrência**
```
Se há data final → Para na data limite
Se não há data final → Continua indefinidamente
```

## 📊 Tipos de Recorrência Detalhados

### **Diária**
- **Uso**: Despesas que se repetem todos os dias
- **Exemplo**: Alimentação diária, transporte
- **Intervalo**: 1 = todos os dias, 2 = a cada 2 dias

### **Semanal**
- **Uso**: Despesas semanais
- **Exemplo**: Limpeza, manutenção
- **Intervalo**: 1 = toda semana, 2 = a cada 2 semanas

### **Mensal**
- **Uso**: Despesas mensais (mais comum)
- **Exemplo**: Aluguel, internet, telefone, salários
- **Intervalo**: 1 = todo mês, 2 = a cada 2 meses

### **Trimestral**
- **Uso**: Despesas trimestrais
- **Exemplo**: Impostos, seguros
- **Intervalo**: 1 = todo trimestre, 2 = a cada 2 trimestres

### **Semestral**
- **Uso**: Despesas semestrais
- **Exemplo**: Renovação de contratos
- **Intervalo**: 1 = todo semestre, 2 = a cada 2 semestres

### **Anual**
- **Uso**: Despesas anuais
- **Exemplo**: Licenças, assinaturas anuais
- **Intervalo**: 1 = todo ano, 2 = a cada 2 anos

## 🎯 Exemplos Práticos

### **Exemplo 1: Aluguel Mensal**
- **Descrição**: Aluguel da loja
- **Valor**: R$ 2.000,00
- **Tipo**: Mensal
- **Intervalo**: 1
- **Data Final**: 31/12/2025
- **Resultado**: Nova transação criada todo dia 5 de cada mês

### **Exemplo 2: Internet Semanal**
- **Descrição**: Limpeza da loja
- **Valor**: R$ 150,00
- **Tipo**: Semanal
- **Intervalo**: 1
- **Data Final**: (em branco)
- **Resultado**: Nova transação criada toda segunda-feira

### **Exemplo 3: Seguro Trimestral**
- **Descrição**: Seguro da empresa
- **Valor**: R$ 500,00
- **Tipo**: Trimestral
- **Intervalo**: 1
- **Data Final**: 31/12/2026
- **Resultado**: Nova transação criada a cada 3 meses

## 🔧 Implementação Técnica

### **Banco de Dados**
```sql
-- Campos adicionados ao modelo FinancialTransaction
isRecurring       Boolean           @default(false)
recurrenceType    RecurrenceType?
recurrenceInterval Int?
recurrenceEndDate DateTime?
parentTransactionId String?
parentTransaction FinancialTransaction? @relation("RecurringTransactions", fields: [parentTransactionId], references: [id])
recurringTransactions FinancialTransaction[] @relation("RecurringTransactions")

-- Enum para tipos de recorrência
enum RecurrenceType {
  DAILY
  WEEKLY
  MONTHLY
  QUARTERLY
  SEMIANNUAL
  ANNUAL
}
```

### **Backend**
```typescript
// Função para calcular próxima data
private calculateNextDueDate(currentDate: Date, recurrenceType: string, interval: number): Date {
  const date = new Date(currentDate);
  
  switch (recurrenceType) {
    case 'DAILY':
      date.setDate(date.getDate() + interval);
      break;
    case 'WEEKLY':
      date.setDate(date.getDate() + (interval * 7));
      break;
    case 'MONTHLY':
      date.setMonth(date.getMonth() + interval);
      break;
    // ... outros casos
  }
  
  return date;
}
```

### **Frontend**
```typescript
// Campos condicionais no modal
{transactionForm.transactionType === 'EXPENSE' && (
  <>
    <FormControlLabel
      control={
        <Checkbox
          checked={transactionForm.isRecurring}
          onChange={(e) => setTransactionForm({ ...transactionForm, isRecurring: e.target.checked })}
        />
      }
      label="Esta despesa é recorrente?"
    />
    
    {transactionForm.isRecurring && (
      // Campos de configuração da recorrência
    )}
  </>
)}
```

## 🚀 Benefícios

### **Para o Financeiro**
- **Automação**: Não precisa criar despesas manualmente
- **Previsibilidade**: Sabe exatamente quando as despesas vencem
- **Controle**: Pode definir data final para recorrências
- **Organização**: Despesas recorrentes separadas das normais

### **Para o Negócio**
- **Eficiência**: Reduz trabalho manual
- **Precisão**: Evita esquecimento de despesas importantes
- **Planejamento**: Melhor controle do fluxo de caixa
- **Relatórios**: Dados mais precisos e organizados

### **Para o Sistema**
- **Flexibilidade**: Suporte a múltiplos tipos de recorrência
- **Escalabilidade**: Funciona para qualquer empresa
- **Confiabilidade**: Geração automática e confiável
- **Rastreabilidade**: Histórico completo das transações

## 📋 Como Usar

### **1. Criar Despesa Recorrente**
1. Acesse "Financeiro" → "Transações"
2. Clique em "Nova Transação"
3. Selecione tipo "Despesa"
4. Marque checkbox "Esta despesa é recorrente?"
5. Configure tipo de recorrência e intervalo
6. Defina data final (opcional)
7. Salve a transação

### **2. Gerar Transações Recorrentes**
1. Acesse "Financeiro" → "Despesas Recorrentes"
2. Clique em "Gerar Transações Recorrentes"
3. Sistema cria automaticamente novas transações
4. Verifique na aba "Transações"

### **3. Gerenciar Despesas Recorrentes**
1. Visualize todas as despesas recorrentes na aba específica
2. Edite configurações clicando no ícone de edição
3. Monitore próximos vencimentos
4. Controle status das transações

## 🎯 Cenários de Uso

### **Cenário 1: Loja de Roupas**
- **Aluguel**: R$ 3.000/mês (recorrência mensal)
- **Internet**: R$ 150/mês (recorrência mensal)
- **Limpeza**: R$ 200/semana (recorrência semanal)
- **Seguro**: R$ 800/trimestre (recorrência trimestral)

### **Cenário 2: Escritório**
- **Aluguel**: R$ 5.000/mês (recorrência mensal)
- **Salários**: R$ 15.000/mês (recorrência mensal)
- **Manutenção**: R$ 300/semana (recorrência semanal)
- **Licenças**: R$ 2.000/ano (recorrência anual)

### **Cenário 3: Restaurante**
- **Aluguel**: R$ 4.000/mês (recorrência mensal)
- **Fornecedores**: R$ 8.000/semana (recorrência semanal)
- **Funcionários**: R$ 12.000/mês (recorrência mensal)
- **Impostos**: R$ 3.000/trimestre (recorrência trimestral)

## 🚀 Próximas Melhorias

1. **Geração Automática**: Cron job para gerar transações automaticamente
2. **Notificações**: Alertas de vencimento de despesas recorrentes
3. **Relatórios**: Análise de despesas recorrentes por período
4. **Importação**: Importar despesas recorrentes de planilhas
5. **Templates**: Modelos pré-configurados de despesas comuns
6. **Ajustes**: Possibilidade de ajustar valores futuros
7. **Pausa**: Pausar recorrência temporariamente
8. **Histórico**: Log de todas as transações geradas

---

**Sistema de despesas recorrentes implementado com sucesso!** 🎉

Agora você pode configurar despesas que se repetem automaticamente, economizando tempo e garantindo que nenhuma despesa importante seja esquecida.
