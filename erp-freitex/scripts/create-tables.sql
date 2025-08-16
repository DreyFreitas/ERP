-- Criar tabela customers
CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    "cpfCnpj" VARCHAR(20),
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(50),
    "zipCode" VARCHAR(10),
    "birthDate" TIMESTAMP,
    gender VARCHAR(10),
    notes TEXT,
    "isActive" BOOLEAN DEFAULT true,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Criar tabela sales
CREATE TABLE IF NOT EXISTS sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "companyId" UUID NOT NULL,
    "customerId" UUID,
    "saleNumber" VARCHAR(50) UNIQUE NOT NULL,
    "totalAmount" DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2),
    "paymentMethod" VARCHAR(20) NOT NULL,
    "paymentStatus" VARCHAR(20) DEFAULT 'PENDING',
    "saleStatus" VARCHAR(20) DEFAULT 'COMPLETED',
    "dueDate" TIMESTAMP,
    notes TEXT,
    "isActive" BOOLEAN DEFAULT true,
    "createdAt" TIMESTAMP DEFAULT NOW(),
    "updatedAt" TIMESTAMP DEFAULT NOW()
);

-- Criar tabela sale_items
CREATE TABLE IF NOT EXISTS sale_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "saleId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "variationId" UUID,
    quantity INTEGER NOT NULL,
    "unitPrice" DECIMAL(10,2) NOT NULL,
    "totalPrice" DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2),
    "createdAt" TIMESTAMP DEFAULT NOW()
);
