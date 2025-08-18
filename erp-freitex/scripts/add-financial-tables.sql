-- Script para adicionar tabelas financeiras
-- Executar dentro do container PostgreSQL

-- Criar enum AccountType se não existir
DO $$ BEGIN
    CREATE TYPE "AccountType" AS ENUM ('CASH', 'BANK', 'CREDIT_CARD', 'RECEIVABLE', 'PAYABLE');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Criar tabela financial_accounts
CREATE TABLE IF NOT EXISTS "financial_accounts" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "accountType" "AccountType" NOT NULL,
    "initialBalance" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "currentBalance" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "financial_accounts_pkey" PRIMARY KEY ("id")
);

-- Criar tabela financial_transactions
CREATE TABLE IF NOT EXISTS "financial_transactions" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "transactionType" "TransactionType" NOT NULL,
    "description" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "dueDate" TIMESTAMP(3),
    "paymentDate" TIMESTAMP(3),
    "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
    "category" TEXT,
    "referenceDocument" TEXT,
    "notes" TEXT,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "financial_transactions_pkey" PRIMARY KEY ("id")
);

-- Adicionar foreign keys
ALTER TABLE "financial_accounts" ADD CONSTRAINT "financial_accounts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "financial_transactions" ADD CONSTRAINT "financial_transactions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "financial_transactions" ADD CONSTRAINT "financial_transactions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "financial_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- Criar índices
CREATE INDEX "financial_accounts_companyId_idx" ON "financial_accounts"("companyId");
CREATE INDEX "financial_transactions_companyId_idx" ON "financial_transactions"("companyId");
CREATE INDEX "financial_transactions_accountId_idx" ON "financial_transactions"("accountId");
CREATE INDEX "financial_transactions_dueDate_idx" ON "financial_transactions"("dueDate");
CREATE INDEX "financial_transactions_status_idx" ON "financial_transactions"("status");

-- Inserir dados de exemplo
INSERT INTO "financial_accounts" ("id", "companyId", "name", "accountType", "initialBalance", "currentBalance", "isActive", "createdAt", "updatedAt")
VALUES 
    (gen_random_uuid()::text, '34f6cf4f-8399-41d9-b2b8-cd6b22e9d213', 'Caixa Principal', 'CASH', 1000.00, 1000.00, true, NOW(), NOW()),
    (gen_random_uuid()::text, '34f6cf4f-8399-41d9-b2b8-cd6b22e9d213', 'Banco Principal', 'BANK', 5000.00, 5000.00, true, NOW(), NOW()),
    (gen_random_uuid()::text, '34f6cf4f-8399-41d9-b2b8-cd6b22e9d213', 'Contas a Receber', 'RECEIVABLE', 0.00, 0.00, true, NOW(), NOW()),
    (gen_random_uuid()::text, '34f6cf4f-8399-41d9-b2b8-cd6b22e9d213', 'Contas a Pagar', 'PAYABLE', 0.00, 0.00, true, NOW(), NOW())
ON CONFLICT DO NOTHING;

