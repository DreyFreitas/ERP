# 🗄️ Estrutura do Banco de Dados - ERP Freitex

## Visão Geral
Banco PostgreSQL com suporte a multi-tenancy usando schema isolation.

## Estrutura de Schemas

### Schema: `public` (Sistema)
Tabelas do sistema principal e configurações globais.

### Schema: `tenant_{id}` (Por Empresa)
Cada empresa terá seu próprio schema isolado.

## Tabelas do Sistema (Schema: public)

### 1. companies (Empresas)
```sql
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    logo_url VARCHAR(500),
    plan_type VARCHAR(50) DEFAULT 'basic', -- basic, professional, enterprise
    plan_status VARCHAR(20) DEFAULT 'active', -- active, suspended, cancelled
    trial_ends_at TIMESTAMP,
    subscription_ends_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    is_active BOOLEAN DEFAULT true
);
```

### 2. users (Usuários do Sistema)
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL, -- master, admin, manager, seller, stock, financial
    permissions JSONB,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 3. company_settings (Configurações por Empresa)
```sql
CREATE TABLE company_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_id UUID REFERENCES companies(id),
    setting_key VARCHAR(100) NOT NULL,
    setting_value JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(company_id, setting_key)
);
```

## Tabelas por Empresa (Schema: tenant_{id})

### 1. categories (Categorias)
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES categories(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 2. suppliers (Fornecedores)
```sql
CREATE TABLE suppliers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18),
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    contact_person VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 3. products (Produtos)
```sql
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku VARCHAR(100) UNIQUE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category_id UUID REFERENCES categories(id),
    supplier_id UUID REFERENCES suppliers(id),
    barcode VARCHAR(100),
    cost_price DECIMAL(10,2),
    sale_price DECIMAL(10,2),
    promotional_price DECIMAL(10,2),
    min_stock INTEGER DEFAULT 0,
    max_stock INTEGER,
    weight DECIMAL(8,3),
    dimensions JSONB, -- {length, width, height}
    images JSONB, -- array de URLs
    specifications JSONB, -- especificações customizadas
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 4. product_variations (Variações de Produtos)
```sql
CREATE TABLE product_variations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id),
    size VARCHAR(20),
    color VARCHAR(50),
    model VARCHAR(100),
    sku VARCHAR(100) UNIQUE,
    barcode VARCHAR(100),
    cost_price DECIMAL(10,2),
    sale_price DECIMAL(10,2),
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 5. stock_movements (Movimentações de Estoque)
```sql
CREATE TABLE stock_movements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id),
    variation_id UUID REFERENCES product_variations(id),
    movement_type VARCHAR(50) NOT NULL, -- entrada, saida, ajuste, transferencia
    quantity INTEGER NOT NULL,
    previous_quantity INTEGER,
    new_quantity INTEGER,
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    reference_document VARCHAR(100), -- nota fiscal, ordem de compra, etc
    notes TEXT,
    user_id UUID NOT NULL, -- usuário que fez a movimentação
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 6. customers (Clientes)
```sql
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    cpf_cnpj VARCHAR(18),
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    birth_date DATE,
    gender VARCHAR(10),
    notes TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 7. sales (Vendas)
```sql
CREATE TABLE sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sale_number VARCHAR(50) UNIQUE,
    customer_id UUID REFERENCES customers(id),
    seller_id UUID NOT NULL, -- user_id
    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    final_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50), -- dinheiro, cartao, pix, etc
    payment_status VARCHAR(20) DEFAULT 'pending', -- pending, paid, cancelled
    sale_status VARCHAR(20) DEFAULT 'completed', -- completed, cancelled, returned
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 8. sale_items (Itens da Venda)
```sql
CREATE TABLE sale_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sale_id UUID REFERENCES sales(id),
    product_id UUID REFERENCES products(id),
    variation_id UUID REFERENCES product_variations(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2),
    profit_margin DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);
```

### 9. financial_accounts (Contas Financeiras)
```sql
CREATE TABLE financial_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    account_type VARCHAR(50) NOT NULL, -- receber, pagar, caixa, banco
    initial_balance DECIMAL(10,2) DEFAULT 0,
    current_balance DECIMAL(10,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 10. financial_transactions (Transações Financeiras)
```sql
CREATE TABLE financial_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID REFERENCES financial_accounts(id),
    transaction_type VARCHAR(50) NOT NULL, -- receita, despesa, transferencia
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE,
    payment_date DATE,
    status VARCHAR(20) DEFAULT 'pending', -- pending, paid, cancelled
    category VARCHAR(100),
    reference_document VARCHAR(100),
    notes TEXT,
    user_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 11. stores (Lojas/Filiais)
```sql
CREATE TABLE stores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(2),
    phone VARCHAR(20),
    manager_id UUID, -- user_id
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

## Índices Recomendados

```sql
-- Índices para performance
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_supplier ON products(supplier_id);
CREATE INDEX idx_product_variations_product ON product_variations(product_id);
CREATE INDEX idx_stock_movements_product ON stock_movements(product_id);
CREATE INDEX idx_stock_movements_date ON stock_movements(created_at);
CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_date ON sales(created_at);
CREATE INDEX idx_sale_items_sale ON sale_items(sale_id);
CREATE INDEX idx_financial_transactions_account ON financial_transactions(account_id);
CREATE INDEX idx_financial_transactions_date ON financial_transactions(due_date);
```

## Triggers para Auditoria

```sql
-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger nas tabelas principais
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON sales FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
-- ... aplicar em outras tabelas
```

## Views Úteis

```sql
-- View para estoque atual
CREATE VIEW current_stock AS
SELECT 
    p.id as product_id,
    p.name as product_name,
    p.sku,
    COALESCE(SUM(pv.stock_quantity), 0) as total_stock,
    p.min_stock,
    p.max_stock
FROM products p
LEFT JOIN product_variations pv ON p.id = pv.product_id
WHERE p.is_active = true
GROUP BY p.id, p.name, p.sku, p.min_stock, p.max_stock;

-- View para vendas por período
CREATE VIEW sales_summary AS
SELECT 
    DATE(created_at) as sale_date,
    COUNT(*) as total_sales,
    SUM(final_amount) as total_revenue,
    AVG(final_amount) as avg_sale_value
FROM sales
WHERE sale_status = 'completed'
GROUP BY DATE(created_at);
```

## Backup e Manutenção

```sql
-- Script de backup automático
-- Criar job para backup diário das tabelas por tenant
-- Implementar limpeza de logs antigos
-- Monitorar performance das queries
```

---

**Próximo passo**: Implementar as migrations do Prisma com esta estrutura
