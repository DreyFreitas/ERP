-- Corrigir o tipo da coluna paymentStatus
-- 1. Remover o default
ALTER TABLE sales ALTER COLUMN "paymentStatus" DROP DEFAULT;

-- 2. Alterar o tipo
ALTER TABLE sales ALTER COLUMN "paymentStatus" TYPE "PaymentStatus" USING "paymentStatus"::"PaymentStatus";

-- 3. Adicionar o default novamente
ALTER TABLE sales ALTER COLUMN "paymentStatus" SET DEFAULT 'PENDING'::"PaymentStatus";
