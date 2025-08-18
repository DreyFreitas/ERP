-- Criar tabelas de formas de pagamento e prazos
-- Script simples e direto

-- Tabela de formas de pagamento
CREATE TABLE IF NOT EXISTS payment_methods (
    id TEXT PRIMARY KEY,
    companyId TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    isActive BOOLEAN DEFAULT true,
    fee DECIMAL(5,2),
    color TEXT,
    sortOrder INTEGER DEFAULT 0,
    createdAt TIMESTAMP DEFAULT NOW(),
    updatedAt TIMESTAMP DEFAULT NOW()
);

-- Tabela de prazos de pagamento
CREATE TABLE IF NOT EXISTS payment_terms (
    id TEXT PRIMARY KEY,
    companyId TEXT NOT NULL,
    name TEXT NOT NULL,
    days INTEGER DEFAULT 0,
    description TEXT,
    isActive BOOLEAN DEFAULT true,
    interest DECIMAL(5,2),
    sortOrder INTEGER DEFAULT 0,
    createdAt TIMESTAMP DEFAULT NOW(),
    updatedAt TIMESTAMP DEFAULT NOW()
);

-- Verificar se foram criadas
SELECT 'Tabelas criadas com sucesso!' as status;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name IN ('payment_methods', 'payment_terms');
