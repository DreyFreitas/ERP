-- Script de inicialização do banco de dados ERP Freitex
-- Este script é executado automaticamente quando o container PostgreSQL é criado

-- Criar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Criar banco de dados se não existir
-- (O PostgreSQL já cria o banco através das variáveis de ambiente)

-- Conectar ao banco erp_freitex
\c erp_freitex;

-- Criar schema público se não existir
CREATE SCHEMA IF NOT EXISTS public;

-- Definir schema padrão
SET search_path TO public;

-- Criar função para atualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Log de inicialização
DO $$
BEGIN
    RAISE NOTICE 'Banco de dados ERP Freitex inicializado com sucesso!';
END $$;
