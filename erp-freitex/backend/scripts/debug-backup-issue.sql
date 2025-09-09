-- Script para debugar problemas com backup

-- 1. Verificar se a tabela backups existe
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'backups'
) as table_exists;

-- 2. Se existir, mostrar estrutura da tabela
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'backups'
ORDER BY ordinal_position;

-- 3. Contar registros na tabela
SELECT COUNT(*) as backup_count FROM "public"."backups";

-- 4. Listar todos os backups (se existirem)
SELECT id, filename, "filePath", size, status, type, description, "createdAt"
FROM "public"."backups"
ORDER BY "createdAt" DESC
LIMIT 10;

-- 5. Verificar todas as tabelas do sistema
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
