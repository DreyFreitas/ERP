-- Inicialização do banco de dados ERP Freitex

-- Habilitar extensão UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar tabelas do sistema (schema public)
CREATE TABLE IF NOT EXISTS companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    logo_url VARCHAR(500),
    plan_type VARCHAR(50) DEFAULT 'basic',
    plan_status VARCHAR(20) DEFAULT 'active',
    trial_ends_at TIMESTAMP,
    subscription_ends_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID REFERENCES companies(id),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    permissions JSONB,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Inserir empresa padrão
INSERT INTO companies (id, name, email, plan_type) 
VALUES (
    '550e8400-e29b-41d4-a716-446655440000',
    'ERP Freitex Demo',
    'admin@erpfreitex.com',
    'enterprise'
) ON CONFLICT (email) DO NOTHING;

-- Inserir usuário master padrão (senha: admin123)
INSERT INTO users (id, company_id, name, email, password_hash, role) 
VALUES (
    '550e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440000',
    'Administrador',
    'admin@erpfreitex.com',
    '$2b$10$rQZ8K9mN2pL3vX7yJ1hG4tR5uI6oP9qA2sB3cD4eF5gH6iJ7kL8mN9oP0qR',
    'master'
) ON CONFLICT (email) DO NOTHING;
