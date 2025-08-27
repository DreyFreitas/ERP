-- Script para inserir produtos de exemplo para testar o PDV
-- Execute este script no banco de dados para ter produtos para testar

-- Inserir categorias primeiro
INSERT INTO categories (id, "companyId", name, description, "isActive", "createdAt", "updatedAt")
VALUES 
  ('cat-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Roupas', 'Categoria de roupas', true, NOW(), NOW()),
  ('cat-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Calçados', 'Categoria de calçados', true, NOW(), NOW()),
  ('cat-003', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Acessórios', 'Categoria de acessórios', true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Inserir produtos
INSERT INTO products (id, "companyId", "categoryId", name, sku, description, "salePrice", "costPrice", "isActive", "createdAt", "updatedAt")
VALUES 
  ('prod-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-001', 'Camiseta Básica', 'CAM001', 'Camiseta básica de algodão', 29.90, 15.00, true, NOW(), NOW()),
  ('prod-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-001', 'Calça Jeans', 'CAL002', 'Calça jeans clássica', 89.90, 45.00, true, NOW(), NOW()),
  ('prod-003', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-002', 'Tênis Esportivo', 'TEN003', 'Tênis esportivo confortável', 129.90, 65.00, true, NOW(), NOW()),
  ('prod-004', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-003', 'Boné', 'BON004', 'Boné de baseball', 19.90, 8.00, true, NOW(), NOW()),
  ('prod-005', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-003', 'Meia', 'MEI005', 'Par de meias', 9.90, 3.00, true, NOW(), NOW()),
  ('prod-006', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-001', 'Blusa de Frio', 'BLU006', 'Blusa de frio quentinha', 79.90, 35.00, true, NOW(), NOW()),
  ('prod-007', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-002', 'Sapato Social', 'SAP007', 'Sapato social elegante', 159.90, 80.00, true, NOW(), NOW()),
  ('prod-008', '591c05e2-97f2-4697-ad38-7f7475a57255', 'cat-003', 'Cinto de Couro', 'CIN008', 'Cinto de couro legítimo', 49.90, 20.00, true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Inserir movimentos de estoque para os produtos
INSERT INTO stock_movements (id, "productId", "movementType", quantity, "referenceDocument", notes, "userId", "createdAt")
VALUES 
  ('stock-001', 'prod-001', 'ENTRY', 150, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-002', 'prod-002', 'ENTRY', 75, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-003', 'prod-003', 'ENTRY', 25, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-004', 'prod-004', 'ENTRY', 50, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-005', 'prod-005', 'ENTRY', 200, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-006', 'prod-006', 'ENTRY', 60, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-007', 'prod-007', 'ENTRY', 30, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW()),
  ('stock-008', 'prod-008', 'ENTRY', 40, 'Estoque inicial', 'Estoque inicial do produto', '9bca5c0c-7603-41b8-b09c-bd7e48ac440b', NOW())
ON CONFLICT DO NOTHING;

-- Inserir clientes de exemplo
INSERT INTO customers (id, "companyId", name, email, phone, "isActive", "createdAt", "updatedAt")
VALUES 
  ('cust-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'João Silva', 'joao@email.com', '(11) 99999-1111', true, NOW(), NOW()),
  ('cust-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Maria Santos', 'maria@email.com', '(11) 99999-2222', true, NOW(), NOW()),
  ('cust-003', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Pedro Costa', 'pedro@email.com', '(11) 99999-3333', true, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Verificar se os métodos de pagamento existem, se não, criar alguns
INSERT INTO payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt")
VALUES 
  ('pay-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Dinheiro', 'Pagamento em dinheiro', true, 0, '#4CAF50', 1, NOW(), NOW()),
  ('pay-002', '591c05e2-97f2-4697-ad38-7f7475a57255', 'PIX', 'Pagamento via PIX', true, 0, '#2196F3', 2, NOW(), NOW()),
  ('pay-003', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Cartão de Débito', 'Cartão de débito', true, 0, '#FF9800', 3, NOW(), NOW()),
  ('pay-004', '591c05e2-97f2-4697-ad38-7f7475a57255', 'Cartão de Crédito', 'Cartão de crédito', true, 2.99, '#E91E63', 4, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Verificar se os prazos de pagamento existem, se não, criar alguns
INSERT INTO payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "isInstallment", "installmentsCount", "installmentInterval", "createdAt", "updatedAt")
VALUES 
  ('term-001', '591c05e2-97f2-4697-ad38-7f7475a57255', 'À Vista', 0, 'Pagamento à vista', true, 0, 1, false, null, null, NOW(), NOW()),
  ('term-002', '591c05e2-97f2-4697-ad38-7f7475a57255', '30 Dias', 30, 'Pagamento em 30 dias', true, 0, 2, false, null, null, NOW(), NOW()),
  ('term-003', '591c05e2-97f2-4697-ad38-7f7475a57255', '3x sem Juros', 0, 'Pagamento em 3x sem juros', true, 0, 3, true, 3, 30, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Mensagem de confirmação
SELECT 'Produtos, clientes e métodos de pagamento inseridos com sucesso!' as resultado;
