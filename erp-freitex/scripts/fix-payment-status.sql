-- Verificar a estrutura atual da tabela sales
SELECT column_name, data_type, udt_name 
FROM information_schema.columns 
WHERE table_name = 'sales' AND column_name = 'paymentStatus';

-- Verificar se a coluna paymentStatus está usando o tipo correto
SELECT 
    column_name,
    data_type,
    udt_name,
    CASE 
        WHEN udt_name = 'paymentstatus' THEN 'CORRETO'
        ELSE 'INCORRETO - Precisa ser alterado'
    END as status
FROM information_schema.columns 
WHERE table_name = 'sales' AND column_name = 'paymentStatus';

-- Corrigir o tipo da coluna paymentStatus
ALTER TABLE sales ALTER COLUMN "paymentStatus" TYPE "PaymentStatus" USING "paymentStatus"::"PaymentStatus";

-- Verificar se foi corrigido
SELECT 
    column_name,
    data_type,
    udt_name,
    CASE 
        WHEN udt_name = 'paymentstatus' THEN 'CORRETO'
        ELSE 'INCORRETO - Precisa ser alterado'
    END as status
FROM information_schema.columns 
WHERE table_name = 'sales' AND column_name = 'paymentStatus';
