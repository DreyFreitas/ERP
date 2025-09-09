-- Script para garantir que a tabela backups existe

-- Verificar se a tabela existe
DO $$
BEGIN
    -- Verificar se a tabela backups existe
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'backups') THEN
        -- Criar a tabela backups
        CREATE TABLE "public"."backups" (
            "id" TEXT NOT NULL,
            "filename" TEXT NOT NULL,
            "filePath" TEXT NOT NULL,
            "size" TEXT NOT NULL,
            "status" TEXT NOT NULL DEFAULT 'completed',
            "type" TEXT NOT NULL DEFAULT 'full',
            "description" TEXT,
            "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
            "updatedAt" TIMESTAMP(3) NOT NULL,
            CONSTRAINT "backups_pkey" PRIMARY KEY ("id")
        );
        
        RAISE NOTICE 'Tabela "backups" criada com sucesso!';
    ELSE
        RAISE NOTICE 'Tabela "backups" já existe.';
    END IF;
END
$$;

-- Verificar estrutura da tabela
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'backups'
ORDER BY ordinal_position;

-- Contar registros
SELECT COUNT(*) as total_backups FROM "public"."backups";
