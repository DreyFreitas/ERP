-- Verificar se a tabela printers existe
SELECT 
    table_name,
    table_schema
FROM information_schema.tables 
WHERE table_name = 'printers' 
    AND table_schema = 'public';

-- Verificar a estrutura da tabela se ela existir
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'printers' 
    AND table_schema = 'public'
ORDER BY ordinal_position;
