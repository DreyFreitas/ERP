-- Script simples para inserir produtos básicos
-- Primeiro, vamos verificar a estrutura da tabela products
\d products;

-- Inserir categorias
INSERT INTO categories (id, "companyId", name, description, "isActive", "createdAt", "updatedAt")
VALUES 
  ('cat-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Roupas', 'Categoria de roupas', true, NOW(), NOW()),
  ('cat-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Calçados', 'Categoria de calçados', true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Inserir produtos (incluindo salePrice obrigatório)
INSERT INTO products (id, "companyId", "categoryId", name, sku, description, "salePrice", "isActive", "createdAt", "updatedAt")
VALUES 
  ('prod-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-001', 'Camiseta Básica', 'CAM001', 'Camiseta básica de algodão', 29.90, true, NOW(), NOW()),
  ('prod-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-001', 'Calça Jeans', 'CAL002', 'Calça jeans clássica', 89.90, true, NOW(), NOW()),
  ('prod-003', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-002', 'Tênis Esportivo', 'TEN003', 'Tênis esportivo confortável', 129.90, true, NOW(), NOW()),
  ('prod-004', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-001', 'Blusa de Frio', 'BLU004', 'Blusa de frio quentinha', 79.90, true, NOW(), NOW()),
  ('prod-005', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-002', 'Sapato Social', 'SAP005', 'Sapato social elegante', 159.90, true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Inserir clientes básicos
INSERT INTO customers (id, "companyId", name, email, phone, "isActive", "createdAt", "updatedAt")
VALUES 
  ('cust-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'João Silva', 'joao@email.com', '(11) 99999-1111', true, NOW(), NOW()),
  ('cust-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Maria Santos', 'maria@email.com', '(11) 99999-2222', true, NOW(), NOW())
ON CONFLICT DO NOTHING;

SELECT 'Dados básicos inseridos!' as resultado;
