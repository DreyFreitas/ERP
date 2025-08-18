-- Script para adicionar transações financeiras de exemplo
-- Executar dentro do container PostgreSQL

-- Obter IDs das contas
DO $$
DECLARE
    cash_account_id TEXT;
    bank_account_id TEXT;
    receivable_account_id TEXT;
    payable_account_id TEXT;
    company_id TEXT;
    user_id TEXT;
BEGIN
    -- Obter ID da empresa
    SELECT id INTO company_id FROM companies LIMIT 1;
    
    -- Obter ID do usuário
    SELECT id INTO user_id FROM users WHERE companyId = company_id LIMIT 1;
    
    -- Obter IDs das contas
    SELECT id INTO cash_account_id FROM financial_accounts WHERE name = 'Caixa Principal' AND companyId = company_id;
    SELECT id INTO bank_account_id FROM financial_accounts WHERE name = 'Banco Principal' AND companyId = company_id;
    SELECT id INTO receivable_account_id FROM financial_accounts WHERE name = 'Contas a Receber' AND companyId = company_id;
    SELECT id INTO payable_account_id FROM financial_accounts WHERE name = 'Contas a Pagar' AND companyId = company_id;

    -- Inserir transações de exemplo
    INSERT INTO financial_transactions (id, companyId, accountId, transactionType, description, amount, dueDate, status, category, referenceDocument, notes, userId, createdAt, updatedAt)
    VALUES 
        -- Receitas (INCOME)
        (gen_random_uuid()::text, company_id, cash_account_id, 'INCOME', 'Venda de Produtos - Loja', 2500.00, NULL, 'PAID', 'Vendas', 'VENDA-001', 'Venda realizada na loja física', user_id, NOW(), NOW()),
        (gen_random_uuid()::text, company_id, bank_account_id, 'INCOME', 'Pagamento de Cliente', 1800.00, NULL, 'PAID', 'Vendas', 'PAG-002', 'Pagamento via PIX', user_id, NOW(), NOW()),
        (gen_random_uuid()::text, company_id, receivable_account_id, 'INCOME', 'Venda a Prazo - Cliente João', 1200.00, (NOW() + INTERVAL '30 days'), 'PENDING', 'Vendas', 'VENDA-003', 'Venda com prazo de 30 dias', user_id, NOW(), NOW()),
        
        -- Despesas (EXPENSE)
        (gen_random_uuid()::text, company_id, cash_account_id, 'EXPENSE', 'Compra de Mercadorias', 1500.00, NULL, 'PAID', 'Fornecedores', 'COMP-001', 'Compra de produtos para estoque', user_id, NOW(), NOW()),
        (gen_random_uuid()::text, company_id, bank_account_id, 'EXPENSE', 'Aluguel da Loja', 800.00, (NOW() + INTERVAL '5 days'), 'PENDING', 'Aluguel', 'ALUG-001', 'Aluguel mensal da loja', user_id, NOW(), NOW()),
        (gen_random_uuid()::text, company_id, payable_account_id, 'EXPENSE', 'Conta de Luz', 350.00, (NOW() + INTERVAL '15 days'), 'PENDING', 'Serviços Públicos', 'LUZ-001', 'Conta de energia elétrica', user_id, NOW(), NOW()),
        (gen_random_uuid()::text, company_id, cash_account_id, 'EXPENSE', 'Material de Escritório', 120.00, NULL, 'PAID', 'Despesas Administrativas', 'MAT-001', 'Compra de papel e canetas', user_id, NOW(), NOW()),
        
        -- Transferências (TRANSFER)
        (gen_random_uuid()::text, company_id, bank_account_id, 'TRANSFER', 'Transferência para Caixa', 500.00, NULL, 'PAID', 'Transferência', 'TRANS-001', 'Transferência para manter caixa', user_id, NOW(), NOW());

    -- Atualizar saldos das contas
    -- Caixa Principal: +2500 (venda) -1500 (compra) -120 (material) +500 (transferência) = 1380
    UPDATE financial_accounts SET currentBalance = 1380.00 WHERE id = cash_account_id;
    
    -- Banco Principal: +1800 (pagamento) -500 (transferência) = 6300
    UPDATE financial_accounts SET currentBalance = 6300.00 WHERE id = bank_account_id;
    
    -- Contas a Receber: +1200 (venda a prazo) = 1200
    UPDATE financial_accounts SET currentBalance = 1200.00 WHERE id = receivable_account_id;
    
    -- Contas a Pagar: +800 (aluguel) +350 (luz) = 1150
    UPDATE financial_accounts SET currentBalance = 1150.00 WHERE id = payable_account_id;

    RAISE NOTICE 'Transações de exemplo inseridas com sucesso!';
END $$;

