-- Script de inicialização do banco de dados ERP Freitex
-- Executado automaticamente na primeira inicialização do PostgreSQL

-- Configurar encoding e locale
SET client_encoding = 'UTF8';
SET default_text_search_config = 'english';

-- Extensão para UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Configurar search_path
SET search_path TO public;

-- Função para atualizar updated_at automaticamente
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
    RAISE NOTICE 'Extensões instaladas: uuid-ossp';
    RAISE NOTICE 'Função update_updated_at_column criada';
END $$;
