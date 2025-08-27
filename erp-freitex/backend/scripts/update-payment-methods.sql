-- Adicionar campo isInstallmentMethod à tabela payment_methods
ALTER TABLE payment_methods ADD COLUMN IF NOT EXISTS "isInstallmentMethod" BOOLEAN DEFAULT false;

-- Atualizar métodos de pagamento existentes que devem ser vinculados a prazo
UPDATE payment_methods 
SET "isInstallmentMethod" = true 
WHERE name ILIKE '%prazo%' OR name ILIKE '%parcela%' OR name ILIKE '%credito%';

-- Verificar os dados atualizados
SELECT id, name, "isInstallmentMethod" FROM payment_methods;
