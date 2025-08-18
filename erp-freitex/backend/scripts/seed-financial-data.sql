-- Inserir empresa de exemplo
INSERT INTO companies (id, name, cnpj, email, phone, address, city, state, "zipCode", "planType", "planStatus", "isActive", "createdAt", "updatedAt") 
VALUES ('company-1', 'Empresa Teste', '12345678901234', 'teste@empresa.com', '(11) 99999-9999', 'Rua Teste, 123', 'São Paulo', 'SP', '01234-567', 'basic', 'active', true, NOW(), NOW());

-- Inserir usuário de exemplo
INSERT INTO users (id, "companyId", name, email, "passwordHash", role, "isActive", "createdAt", "updatedAt") 
VALUES ('user-1', 'company-1', 'Administrador', 'admin@empresa.com', '$2b$10$example.hash', 'admin', true, NOW(), NOW());

-- Inserir contas financeiras de exemplo
INSERT INTO financial_accounts (id, "companyId", name, "accountType", "initialBalance", "currentBalance", "isActive", "createdAt", "updatedAt") 
VALUES 
('account-1', 'company-1', 'Caixa', 'CASH', 1000.00, 1000.00, true, NOW(), NOW()),
('account-2', 'company-1', 'Banco Principal', 'BANK', 5000.00, 5000.00, true, NOW(), NOW()),
('account-3', 'company-1', 'Cartão de Crédito', 'CREDIT_CARD', 0.00, 0.00, true, NOW(), NOW()),
('account-4', 'company-1', 'Contas a Receber', 'RECEIVABLE', 0.00, 0.00, true, NOW(), NOW()),
('account-5', 'company-1', 'Contas a Pagar', 'PAYABLE', 0.00, 0.00, true, NOW(), NOW());

-- Inserir transações financeiras de exemplo
INSERT INTO financial_transactions (id, "companyId", "accountId", "transactionType", description, amount, "dueDate", status, category, "referenceDocument", notes, "userId", "createdAt", "updatedAt") 
VALUES 
('trans-1', 'company-1', 'account-1', 'INCOME', 'Venda de Produtos', 1500.00, NOW(), 'PAID', 'Vendas', 'NF-001', 'Venda de produtos diversos', 'user-1', NOW(), NOW()),
('trans-2', 'company-1', 'account-2', 'EXPENSE', 'Aluguel', 800.00, NOW(), 'PAID', 'Despesas Operacionais', 'REC-001', 'Aluguel do mês', 'user-1', NOW(), NOW()),
('trans-3', 'company-1', 'account-1', 'INCOME', 'Serviços Prestados', 2000.00, NOW(), 'PENDING', 'Serviços', 'NF-002', 'Prestação de serviços', 'user-1', NOW(), NOW()),
('trans-4', 'company-1', 'account-3', 'EXPENSE', 'Compra de Materiais', 300.00, NOW(), 'PENDING', 'Compras', 'COMP-001', 'Compra de materiais de escritório', 'user-1', NOW(), NOW()),
('trans-5', 'company-1', 'account-2', 'TRANSFER', 'Transferência para Caixa', 500.00, NOW(), 'PAID', 'Transferências', 'TRANS-001', 'Transferência entre contas', 'user-1', NOW(), NOW());

-- Atualizar saldos das contas baseado nas transações
UPDATE financial_accounts SET "currentBalance" = 2200.00 WHERE id = 'account-1';
UPDATE financial_accounts SET "currentBalance" = 4700.00 WHERE id = 'account-2';
UPDATE financial_accounts SET "currentBalance" = -300.00 WHERE id = 'account-3';
UPDATE financial_accounts SET "currentBalance" = 2000.00 WHERE id = 'account-4';
UPDATE financial_accounts SET "currentBalance" = -300.00 WHERE id = 'account-5';
