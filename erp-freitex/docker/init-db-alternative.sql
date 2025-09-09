-- Script alternativo de inicialização do banco de dados ERP Freitex
-- Este script é executado se o init-db.sql principal falhar

-- Verificar se o banco já foi inicializado
DO $$
BEGIN
    -- Verificar se a extensão uuid-ossp já existe
    IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'uuid-ossp') THEN
        CREATE EXTENSION "uuid-ossp";
        RAISE NOTICE 'Extensão uuid-ossp instalada';
    ELSE
        RAISE NOTICE 'Extensão uuid-ossp já existe';
    END IF;
    
    -- Verificar se a função update_updated_at_column já existe
    IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'update_updated_at_column') THEN
        CREATE OR REPLACE FUNCTION update_updated_at_column()
        RETURNS TRIGGER AS $$
        BEGIN
            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $$ language 'plpgsql';
        RAISE NOTICE 'Função update_updated_at_column criada';
    ELSE
        RAISE NOTICE 'Função update_updated_at_column já existe';
    END IF;
    
    RAISE NOTICE 'Script alternativo de inicialização executado com sucesso!';
END $$;
