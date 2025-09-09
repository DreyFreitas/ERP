--
-- PostgreSQL database dump
--

\restrict Kgax4HaAzyp2x3XXSHnGGZh5hri1LUanzrYfy49BhF9RhpdPOcWVR85rHDuex2d

-- Dumped from database version 15.14
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-04 17:14:13 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.users DROP CONSTRAINT "users_companyId_fkey";
ALTER TABLE ONLY public.stock_movements DROP CONSTRAINT "stock_movements_variationId_fkey";
ALTER TABLE ONLY public.stock_movements DROP CONSTRAINT "stock_movements_productId_fkey";
ALTER TABLE ONLY public.sales DROP CONSTRAINT "sales_paymentTermId_fkey";
ALTER TABLE ONLY public.sales DROP CONSTRAINT "sales_paymentMethodId_fkey";
ALTER TABLE ONLY public.sales DROP CONSTRAINT "sales_customerId_fkey";
ALTER TABLE ONLY public.sales DROP CONSTRAINT "sales_companyId_fkey";
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT "sale_items_variationId_fkey";
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT "sale_items_saleId_fkey";
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT "sale_items_productId_fkey";
ALTER TABLE ONLY public.sale_installments DROP CONSTRAINT "sale_installments_saleId_fkey";
ALTER TABLE ONLY public.products DROP CONSTRAINT "products_supplierId_fkey";
ALTER TABLE ONLY public.products DROP CONSTRAINT "products_companyId_fkey";
ALTER TABLE ONLY public.products DROP CONSTRAINT "products_categoryId_fkey";
ALTER TABLE ONLY public.product_variations DROP CONSTRAINT "product_variations_productId_fkey";
ALTER TABLE ONLY public.printers DROP CONSTRAINT "printers_companyId_fkey";
ALTER TABLE ONLY public.payment_terms DROP CONSTRAINT "payment_terms_companyId_fkey";
ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT "payment_methods_companyId_fkey";
ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT "payment_methods_accountId_fkey";
ALTER TABLE ONLY public.financial_transactions DROP CONSTRAINT "financial_transactions_parentTransactionId_fkey";
ALTER TABLE ONLY public.financial_transactions DROP CONSTRAINT "financial_transactions_companyId_fkey";
ALTER TABLE ONLY public.financial_transactions DROP CONSTRAINT "financial_transactions_accountId_fkey";
ALTER TABLE ONLY public.financial_accounts DROP CONSTRAINT "financial_accounts_companyId_fkey";
ALTER TABLE ONLY public.customers DROP CONSTRAINT "customers_companyId_fkey";
ALTER TABLE ONLY public.company_settings DROP CONSTRAINT "company_settings_companyId_fkey";
ALTER TABLE ONLY public.categories DROP CONSTRAINT "categories_parentId_fkey";
ALTER TABLE ONLY public.categories DROP CONSTRAINT "categories_companyId_fkey";
DROP INDEX public.users_email_key;
DROP INDEX public."sales_saleNumber_key";
DROP INDEX public."products_companyId_sku_key";
DROP INDEX public."products_companyId_barcode_key";
DROP INDEX public."product_variations_productId_sku_key";
DROP INDEX public."product_variations_productId_barcode_key";
DROP INDEX public."printers_companyId_name_key";
DROP INDEX public."customers_companyId_email_key";
DROP INDEX public."customers_companyId_cpfCnpj_key";
DROP INDEX public."company_settings_companyId_settingKey_key";
DROP INDEX public.companies_email_key;
DROP INDEX public.companies_cnpj_key;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pkey;
ALTER TABLE ONLY public.stock_movements DROP CONSTRAINT stock_movements_pkey;
ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pkey;
ALTER TABLE ONLY public.sale_items DROP CONSTRAINT sale_items_pkey;
ALTER TABLE ONLY public.sale_installments DROP CONSTRAINT sale_installments_pkey;
ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
ALTER TABLE ONLY public.product_variations DROP CONSTRAINT product_variations_pkey;
ALTER TABLE ONLY public.printers DROP CONSTRAINT printers_pkey;
ALTER TABLE ONLY public.payment_terms DROP CONSTRAINT payment_terms_pkey;
ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT payment_methods_pkey;
ALTER TABLE ONLY public.financial_transactions DROP CONSTRAINT financial_transactions_pkey;
ALTER TABLE ONLY public.financial_accounts DROP CONSTRAINT financial_accounts_pkey;
ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
ALTER TABLE ONLY public.company_settings DROP CONSTRAINT company_settings_pkey;
ALTER TABLE ONLY public.companies DROP CONSTRAINT companies_pkey;
ALTER TABLE ONLY public.categories DROP CONSTRAINT categories_pkey;
ALTER TABLE ONLY public.backups DROP CONSTRAINT backups_pkey;
ALTER TABLE ONLY public._prisma_migrations DROP CONSTRAINT _prisma_migrations_pkey;
DROP TABLE public.users;
DROP TABLE public.suppliers;
DROP TABLE public.stock_movements;
DROP TABLE public.sales;
DROP TABLE public.sale_items;
DROP TABLE public.sale_installments;
DROP TABLE public.products;
DROP TABLE public.product_variations;
DROP TABLE public.printers;
DROP TABLE public.payment_terms;
DROP TABLE public.payment_methods;
DROP TABLE public.financial_transactions;
DROP TABLE public.financial_accounts;
DROP TABLE public.customers;
DROP TABLE public.company_settings;
DROP TABLE public.companies;
DROP TABLE public.categories;
DROP TABLE public.backups;
DROP TABLE public._prisma_migrations;
DROP TYPE public."UserRole";
DROP TYPE public."TransactionType";
DROP TYPE public."TransactionStatus";
DROP TYPE public."SaleStatus";
DROP TYPE public."RecurrenceType";
DROP TYPE public."PlanType";
DROP TYPE public."PlanStatus";
DROP TYPE public."PaymentStatus";
DROP TYPE public."MovementType";
DROP TYPE public."InstallmentStatus";
DROP TYPE public."AccountType";
-- *not* dropping schema, since initdb creates it
--
-- TOC entry 5 (class 2615 OID 29010)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 882 (class 1247 OID 29092)
-- Name: AccountType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AccountType" AS ENUM (
    'CASH',
    'BANK',
    'CREDIT_CARD',
    'RECEIVABLE',
    'PAYABLE'
);


--
-- TOC entry 936 (class 1247 OID 31873)
-- Name: InstallmentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."InstallmentStatus" AS ENUM (
    'PENDING',
    'PAID',
    'OVERDUE',
    'CANCELLED'
);


--
-- TOC entry 873 (class 1247 OID 29066)
-- Name: MovementType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MovementType" AS ENUM (
    'ENTRY',
    'EXIT',
    'ADJUSTMENT',
    'TRANSFER'
);


--
-- TOC entry 867 (class 1247 OID 29050)
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'PENDING',
    'PAID',
    'CANCELLED'
);


--
-- TOC entry 864 (class 1247 OID 29042)
-- Name: PlanStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PlanStatus" AS ENUM (
    'ACTIVE',
    'SUSPENDED',
    'CANCELLED'
);


--
-- TOC entry 861 (class 1247 OID 29034)
-- Name: PlanType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PlanType" AS ENUM (
    'BASIC',
    'PROFESSIONAL',
    'ENTERPRISE'
);


--
-- TOC entry 933 (class 1247 OID 30183)
-- Name: RecurrenceType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."RecurrenceType" AS ENUM (
    'DAILY',
    'WEEKLY',
    'MONTHLY',
    'QUARTERLY',
    'SEMIANNUAL',
    'ANNUAL'
);


--
-- TOC entry 870 (class 1247 OID 29058)
-- Name: SaleStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."SaleStatus" AS ENUM (
    'COMPLETED',
    'CANCELLED',
    'RETURNED'
);


--
-- TOC entry 879 (class 1247 OID 29084)
-- Name: TransactionStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TransactionStatus" AS ENUM (
    'PENDING',
    'PAID',
    'CANCELLED'
);


--
-- TOC entry 876 (class 1247 OID 29076)
-- Name: TransactionType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."TransactionType" AS ENUM (
    'INCOME',
    'EXPENSE',
    'TRANSFER'
);


--
-- TOC entry 858 (class 1247 OID 29021)
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'MASTER',
    'ADMIN',
    'MANAGER',
    'SELLER',
    'STOCK',
    'FINANCIAL'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 29011)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 32775)
-- Name: backups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.backups (
    id text NOT NULL,
    filename text NOT NULL,
    "filePath" text NOT NULL,
    size text NOT NULL,
    status text DEFAULT 'completed'::text NOT NULL,
    type text DEFAULT 'full'::text NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 29131)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id text NOT NULL,
    "companyId" text NOT NULL,
    name text NOT NULL,
    description text,
    "parentId" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 29103)
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id text NOT NULL,
    name text NOT NULL,
    cnpj text,
    email text NOT NULL,
    phone text,
    address text,
    city text,
    state text,
    "zipCode" text,
    "logoUrl" text,
    "planType" text DEFAULT 'basic'::text NOT NULL,
    "planStatus" text DEFAULT 'active'::text NOT NULL,
    "trialEndsAt" timestamp(3) without time zone,
    "subscriptionEndsAt" timestamp(3) without time zone,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 29123)
-- Name: company_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_settings (
    id text NOT NULL,
    "companyId" text NOT NULL,
    "settingKey" text NOT NULL,
    "settingValue" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 29177)
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id text NOT NULL,
    "companyId" text NOT NULL,
    name text NOT NULL,
    "cpfCnpj" text,
    email text,
    phone text,
    address text,
    city text,
    state text,
    "zipCode" text,
    "birthDate" timestamp(3) without time zone,
    gender text,
    notes text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "allowCreditPurchases" boolean DEFAULT true NOT NULL,
    "companyName" text,
    "creditAvailable" numeric(10,2),
    "creditLimit" numeric(10,2),
    "creditStatus" text DEFAULT 'ACTIVE'::text,
    "creditUsed" numeric(10,2),
    "customerSegment" text DEFAULT 'C'::text,
    "customerType" text DEFAULT 'REGULAR'::text,
    "discountPercentage" numeric(5,2),
    "loyaltyPoints" integer DEFAULT 0,
    "maxInstallments" integer DEFAULT 12,
    "maxPurchaseAmount" numeric(10,2),
    "minPurchaseAmount" numeric(10,2),
    occupation text,
    "paymentTerms" text,
    "preferredPaymentMethod" text,
    "referenceName" text,
    "referencePhone" text,
    "referenceRelationship" text
);


--
-- TOC entry 226 (class 1259 OID 29205)
-- Name: financial_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.financial_accounts (
    id text NOT NULL,
    "companyId" text NOT NULL,
    name text NOT NULL,
    "accountType" public."AccountType" NOT NULL,
    "initialBalance" numeric(10,2) DEFAULT 0 NOT NULL,
    "currentBalance" numeric(10,2) DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 29216)
-- Name: financial_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.financial_transactions (
    id text NOT NULL,
    "companyId" text NOT NULL,
    "accountId" text NOT NULL,
    "transactionType" public."TransactionType" NOT NULL,
    description text NOT NULL,
    amount numeric(10,2) NOT NULL,
    "dueDate" timestamp(3) without time zone,
    "paymentDate" timestamp(3) without time zone,
    status public."TransactionStatus" DEFAULT 'PENDING'::public."TransactionStatus" NOT NULL,
    category text,
    "referenceDocument" text,
    notes text,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "isRecurring" boolean DEFAULT false NOT NULL,
    "parentTransactionId" text,
    "recurrenceEndDate" timestamp(3) without time zone,
    "recurrenceInterval" integer,
    "recurrenceType" public."RecurrenceType"
);


--
-- TOC entry 228 (class 1259 OID 29225)
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods (
    id text NOT NULL,
    "companyId" text NOT NULL,
    name text NOT NULL,
    description text,
    "isActive" boolean DEFAULT true NOT NULL,
    fee numeric(5,2),
    color text,
    "sortOrder" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "isInstallmentMethod" boolean DEFAULT false NOT NULL,
    "accountId" text
);


--
-- TOC entry 229 (class 1259 OID 29235)
-- Name: payment_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_terms (
    id text NOT NULL,
    "companyId" text NOT NULL,
    name text NOT NULL,
    days integer DEFAULT 0 NOT NULL,
    description text,
    "isActive" boolean DEFAULT true NOT NULL,
    interest numeric(5,2),
    "sortOrder" integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "installmentInterval" integer,
    "installmentsCount" integer,
    "isInstallment" boolean DEFAULT false NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 29390)
-- Name: printers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.printers (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    "isDefault" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "companyId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 29159)
-- Name: product_variations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variations (
    id text NOT NULL,
    "productId" text NOT NULL,
    size text,
    color text,
    model text,
    sku text,
    barcode text,
    "costPrice" numeric(10,2),
    "salePrice" numeric(10,2) NOT NULL,
    "stockQuantity" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 29149)
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id text NOT NULL,
    "companyId" text NOT NULL,
    sku text,
    name text NOT NULL,
    description text,
    "categoryId" text,
    "supplierId" text,
    barcode text,
    "costPrice" numeric(10,2),
    "salePrice" numeric(10,2) NOT NULL,
    "promotionalPrice" numeric(10,2),
    "minStock" integer DEFAULT 0 NOT NULL,
    "maxStock" integer,
    weight numeric(8,3),
    dimensions jsonb,
    images jsonb,
    specifications jsonb,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 31881)
-- Name: sale_installments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sale_installments (
    id text NOT NULL,
    "saleId" text NOT NULL,
    "installmentNumber" integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    "dueDate" timestamp(3) without time zone NOT NULL,
    "paymentDate" timestamp(3) without time zone,
    status public."InstallmentStatus" DEFAULT 'PENDING'::public."InstallmentStatus" NOT NULL,
    notes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 29197)
-- Name: sale_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sale_items (
    id text NOT NULL,
    "saleId" text NOT NULL,
    "productId" text NOT NULL,
    "variationId" text,
    quantity integer NOT NULL,
    "unitPrice" numeric(10,2) NOT NULL,
    "totalPrice" numeric(10,2) NOT NULL,
    discount numeric(10,2),
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 29186)
-- Name: sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales (
    id text NOT NULL,
    "companyId" text NOT NULL,
    "customerId" text,
    "saleNumber" text NOT NULL,
    "totalAmount" numeric(10,2) NOT NULL,
    discount numeric(10,2),
    "paymentMethodId" text NOT NULL,
    "paymentStatus" public."PaymentStatus" DEFAULT 'PENDING'::public."PaymentStatus" NOT NULL,
    "saleStatus" public."SaleStatus" DEFAULT 'COMPLETED'::public."SaleStatus" NOT NULL,
    "dueDate" timestamp(3) without time zone,
    notes text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "paymentTermId" text,
    "discountType" text,
    "finalAmount" numeric(10,2) NOT NULL,
    "totalFees" numeric(10,2)
);


--
-- TOC entry 222 (class 1259 OID 29169)
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stock_movements (
    id text NOT NULL,
    "productId" text NOT NULL,
    "variationId" text,
    "movementType" public."MovementType" NOT NULL,
    quantity integer NOT NULL,
    "previousQuantity" integer,
    "newQuantity" integer,
    "unitCost" numeric(10,2),
    "totalCost" numeric(10,2),
    "referenceDocument" text,
    notes text,
    "userId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 29140)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suppliers (
    id text NOT NULL,
    name text NOT NULL,
    cnpj text,
    email text,
    phone text,
    address text,
    "contactPerson" text,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 29114)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    "companyId" text,
    name text NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL,
    role text NOT NULL,
    permissions jsonb,
    "isActive" boolean DEFAULT true NOT NULL,
    "lastLogin" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- TOC entry 3640 (class 0 OID 29011)
-- Dependencies: 214
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
92b62d54-908d-4add-9dd6-b565b0ea8c98	1c004706b7be0b0d3ab4f841abc4eeaa56d90f0afe101ea2f864b5a9262748ec	2025-08-27 19:45:58.501851+00	20250818185006_init	\N	\N	2025-08-27 19:45:58.248301+00	1
a2425f6c-3668-470b-affe-c0a19a2ef049	14b6b9dfd97e8042f5019234ce40c3e2666c76b3be19cc802e6b1ba0ecd9d530	2025-08-27 19:45:58.510592+00	20250819171943_add_installment_fields_to_payment_terms	\N	\N	2025-08-27 19:45:58.503174+00	1
9d3dfd1c-9023-4765-b3cd-ff08753eb0cf	232c84be5baec5df652780203f2424ab151b3411455b1548cf0c262136c62b5d	2025-08-27 19:45:58.519441+00	20250819221425_add_installment_method_to_payment_methods	\N	\N	2025-08-27 19:45:58.512578+00	1
f984f444-b98e-447e-8b04-c6094cf8368c	7afb97b54640814a707bf51460fc9ae30dd6bb0efa11aa64a7dcf7037ba38868	2025-08-27 19:45:58.529497+00	20250819222451_add_installment_method_to_payment_methods	\N	\N	2025-08-27 19:45:58.520821+00	1
29df3014-c520-44f3-b78f-954a0fd63a2f	1ba3cdd46d421926a4b3aca506bcd40df8e60e49533f1c06d1982d928c9d2630	2025-08-27 19:45:58.556453+00	20250820200015_add_printers	\N	\N	2025-08-27 19:45:58.530744+00	1
05d7aa46-ca95-4991-950e-d9963afc45d0	7d0df8a2adfdc147850dfac862da5da794519c7c5835f7e76c412eae6427d454	2025-08-27 19:45:58.587626+00	20250820204712_fix_printers_table_name	\N	\N	2025-08-27 19:45:58.558649+00	1
e0a43e75-4b6e-4712-9225-820dc881d0ed	691adbfe5b9ba4b74a6d8b9dcd1249eeb54bb5813d9c840fc37208ab1d7a4078	2025-08-27 19:46:17.045263+00	20250827194616_add_payment_fees_to_sales	\N	\N	2025-08-27 19:46:17.029596+00	1
c0bcb7a9-9e90-4a36-80d6-3b84ed91dc12	a0fdaf76e032a1eee476f7b6e17f0fe290ab8635c011bf9b5c589f8125b9af95	2025-08-28 12:16:36.83406+00	20250828121636_add_customer_credit_fields	\N	\N	2025-08-28 12:16:36.812306+00	1
080f111e-53dd-403c-b9e5-cdabadf658ee	499f83a148c2afb9edf0b242ad52f25506fa4d6f5340aa5fd8bae6a1a2d60fea	2025-08-28 18:30:44.953803+00	20250828183044_add_sale_installments	\N	\N	2025-08-28 18:30:44.908127+00	1
faaf2e88-14a2-4357-8ee1-17f212077d33	3162ec529a08128510be9c30b93b3f195d149302f188cf9123b67e3ee0fd8fd1	2025-09-04 14:20:47.324775+00	20250904142047_add_backups_table	\N	\N	2025-09-04 14:20:47.297238+00	1
\.


--
-- TOC entry 3658 (class 0 OID 32775)
-- Dependencies: 232
-- Data for Name: backups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.backups (id, filename, "filePath", size, status, type, description, "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 3644 (class 0 OID 29131)
-- Dependencies: 218
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, "companyId", name, description, "parentId", "isActive", "createdAt", "updatedAt") FROM stdin;
7d72d557-04dd-4a74-a82f-6aed11e252c9	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Vestidos Femininos	\N	\N	t	2025-08-27 20:07:35.005	2025-08-27 20:07:35.005
\.


--
-- TOC entry 3641 (class 0 OID 29103)
-- Dependencies: 215
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.companies (id, name, cnpj, email, phone, address, city, state, "zipCode", "logoUrl", "planType", "planStatus", "trialEndsAt", "subscriptionEndsAt", "isActive", "createdAt", "updatedAt") FROM stdin;
49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Vest Freitas	55658130000108	rodrigopeixotodefreitas@gmail.com	19995038534	Rua Capitão Antônio F. Pinheiro, 153	Mococa/SP	São Paulo	13.732-610	\N	enterprise	active	2025-09-26 20:03:59.617	\N	t	2025-08-27 20:03:59.618	2025-08-27 20:03:59.618
\.


--
-- TOC entry 3643 (class 0 OID 29123)
-- Dependencies: 217
-- Data for Name: company_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.company_settings (id, "companyId", "settingKey", "settingValue", "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 3649 (class 0 OID 29177)
-- Dependencies: 223
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customers (id, "companyId", name, "cpfCnpj", email, phone, address, city, state, "zipCode", "birthDate", gender, notes, "isActive", "createdAt", "updatedAt", "allowCreditPurchases", "companyName", "creditAvailable", "creditLimit", "creditStatus", "creditUsed", "customerSegment", "customerType", "discountPercentage", "loyaltyPoints", "maxInstallments", "maxPurchaseAmount", "minPurchaseAmount", occupation, "paymentTerms", "preferredPaymentMethod", "referenceName", "referencePhone", "referenceRelationship") FROM stdin;
2318735b-d3c5-4dd9-a07a-8fe047df1698	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Cliente Teste Parcelamento	\N	cliente@teste.com	(11) 99999-9999	\N	\N	\N	\N	\N	\N	\N	t	2025-08-28 18:50:55.766	2025-08-28 18:50:55.881	t	\N	9000.00	10000.00	ACTIVE	1000.00	C	REGULAR	\N	0	12	\N	\N	\N	\N	\N	\N	\N	\N
fe481745-ff67-4b46-8d99-f560366b3f92	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Andrey Firmino Freitas	47567127890	dreyggs@gmail.com	19994531122	Rua Capitão Antônio F. Pinheiro, 153	Mococa	SP	13732-610	\N	M		t	2025-08-28 12:29:54.691	2025-08-28 19:24:36.838	t	\N	8327.00	10000.00	ACTIVE	1673.00	A	VIP	\N	0	12	\N	\N	Dev					
\.


--
-- TOC entry 3652 (class 0 OID 29205)
-- Dependencies: 226
-- Data for Name: financial_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.financial_accounts (id, "companyId", name, "accountType", "initialBalance", "currentBalance", "isActive", "createdAt", "updatedAt") FROM stdin;
3c68e97f-3f3d-4af8-8f2b-5584c201ad25	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Fluxo de Caixa	CASH	0.00	250.95	t	2025-08-27 20:09:37.821	2025-08-28 14:12:55.411
3069a32a-248f-4b3a-88cf-7d6981126a1b	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Caixa Federal	BANK	0.00	239.00	t	2025-08-27 20:10:13.416	2025-08-28 19:58:32.466
622b9cca-8ef9-465a-9a9e-b7db66c56d60	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Mercado Pago	BANK	0.00	501.90	t	2025-08-27 20:09:51.812	2025-08-29 23:56:56.012
\.


--
-- TOC entry 3653 (class 0 OID 29216)
-- Dependencies: 227
-- Data for Name: financial_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.financial_transactions (id, "companyId", "accountId", "transactionType", description, amount, "dueDate", "paymentDate", status, category, "referenceDocument", notes, "userId", "createdAt", "updatedAt", "isRecurring", "parentTransactionId", "recurrenceEndDate", "recurrenceInterval", "recurrenceType") FROM stdin;
b93ab15c-c048-46b2-908c-47ed046d191c	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3c68e97f-3f3d-4af8-8f2b-5584c201ad25	INCOME	Venda VDA000004 - Com cliente	250.95	\N	2025-08-28 14:12:55.405	PAID	Vendas	VDA000004	Venda realizada via PDV - Método: Cartão de Crédito	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 14:12:55.406	2025-08-28 14:12:55.406	f	\N	\N	\N	\N
57a30600-52d4-4f94-9eee-2a91b6221bd8	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000001 - Parcela 1/4 - Com cliente	59.75	2025-09-27 17:46:46.651	\N	PENDING	Vendas	VDA000001-P1	Parcela 1/4 da venda VDA000001 - Método: Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 17:46:46.695	2025-08-28 17:46:46.695	f	\N	\N	\N	\N
cc5caf98-95a1-46bd-b371-b525d631ed0f	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000001 - Parcela 2/4 - Com cliente	59.75	2025-10-27 17:46:46.651	\N	PENDING	Vendas	VDA000001-P2	Parcela 2/4 da venda VDA000001 - Método: Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 17:46:46.702	2025-08-28 17:46:46.702	f	\N	\N	\N	\N
ad56198f-b6d2-4e1f-849b-5b0acfbeeec0	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000001 - Parcela 3/4 - Com cliente	59.75	2025-11-26 17:46:46.651	\N	PENDING	Vendas	VDA000001-P3	Parcela 3/4 da venda VDA000001 - Método: Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 17:46:46.706	2025-08-28 17:46:46.706	f	\N	\N	\N	\N
ab87c236-f32e-443a-aaf7-c24003100cdc	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000001 - Parcela 4/4 - Com cliente	59.75	2025-12-26 17:46:46.651	\N	PENDING	Vendas	VDA000001-P4	Parcela 4/4 da venda VDA000001 - Método: Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 17:46:46.711	2025-08-28 17:46:46.711	f	\N	\N	\N	\N
8b3bb0b9-01a0-45b6-a4f4-22e0e6b71c2e	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3c68e97f-3f3d-4af8-8f2b-5584c201ad25	INCOME	Venda VDA000001 - Parcela 1/4 - Com cliente	250.00	2025-09-27 18:50:55.859	\N	PENDING	Vendas	VDA000001-P1	Parcela 1/4 da venda VDA000001 - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 18:50:55.908	2025-08-28 18:50:55.908	f	\N	\N	\N	\N
d416987d-1129-45ad-a1ac-8f9a1bf74407	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3c68e97f-3f3d-4af8-8f2b-5584c201ad25	INCOME	Venda VDA000001 - Parcela 2/4 - Com cliente	250.00	2025-10-27 18:50:55.859	\N	PENDING	Vendas	VDA000001-P2	Parcela 2/4 da venda VDA000001 - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 18:50:55.916	2025-08-28 18:50:55.916	f	\N	\N	\N	\N
2e92539a-f87f-4d08-9523-38d35deebb9c	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3c68e97f-3f3d-4af8-8f2b-5584c201ad25	INCOME	Venda VDA000001 - Parcela 3/4 - Com cliente	250.00	2025-11-26 18:50:55.859	\N	PENDING	Vendas	VDA000001-P3	Parcela 3/4 da venda VDA000001 - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 18:50:55.919	2025-08-28 18:50:55.919	f	\N	\N	\N	\N
5db45c02-33fb-4767-b4d1-63c7c5ab5ce1	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3c68e97f-3f3d-4af8-8f2b-5584c201ad25	INCOME	Venda VDA000001 - Parcela 4/4 - Com cliente	250.00	2025-12-26 18:50:55.859	\N	PENDING	Vendas	VDA000001-P4	Parcela 4/4 da venda VDA000001 - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 18:50:55.923	2025-08-28 18:50:55.923	f	\N	\N	\N	\N
52852e9e-2b87-4113-a659-2010798c30ea	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000001 - Parcela 1/2 - Com cliente	597.50	2025-09-27 19:23:20.818	\N	PENDING	Vendas	VDA000001-P1	Parcela 1/2 da venda VDA000001 - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:23:20.877	2025-08-28 19:23:20.877	f	\N	\N	\N	\N
50b8c87a-8f5e-4b64-bfff-f25624ff5794	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000001 - Parcela 2/2 - Com cliente	597.50	2025-10-27 19:23:20.818	\N	PENDING	Vendas	VDA000001-P2	Parcela 2/2 da venda VDA000001 - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:23:20.887	2025-08-28 19:23:20.887	f	\N	\N	\N	\N
f794333d-9db9-4750-a2e4-2199040ebabd	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000002 - Com cliente	239.00	2025-09-27 19:24:36.817	\N	PENDING	Vendas	VDA000002	Venda realizada via PDV - Método: A Prazo	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:24:36.847	2025-08-28 19:24:36.847	f	\N	\N	\N	\N
c9aef362-0e4a-4b35-a068-9ea4ba3d00bd	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Venda VDA000003 - Sem cliente	239.00	\N	2025-08-28 19:58:32.458	PAID	Vendas	VDA000003	Venda realizada via PDV - Método: PIX	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:58:32.459	2025-08-28 19:58:32.459	f	\N	\N	\N	\N
8ef9a1ba-80b0-4dc3-a135-80099ad9d4a0	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Pagamento - VDA000001 - Parcela 1	597.50	2025-08-29 20:23:55.343	\N	PAID	Vendas	VDA000001	Pagamento de Andrey Firmino Freitas	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-29 20:23:55.346	2025-08-29 20:23:55.346	f	\N	\N	\N	\N
8186d6f1-7024-4de9-b4d9-cc3a80d8f8b0	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	622b9cca-8ef9-465a-9a9e-b7db66c56d60	INCOME	Venda VDA000004 - Sem cliente	250.95	\N	2025-08-29 23:53:43.707	PAID	Vendas	VDA000004	Venda realizada via PDV - Método: Cartão de Crédito	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-29 23:53:43.71	2025-08-29 23:53:43.71	f	\N	\N	\N	\N
c5cbf64a-e7e4-48ad-bbc0-fa9990c355fc	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	622b9cca-8ef9-465a-9a9e-b7db66c56d60	INCOME	Venda VDA000005 - Sem cliente	250.95	\N	2025-08-29 23:56:56.007	PAID	Vendas	VDA000005	Venda realizada via PDV - Método: Cartão de Crédito	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-29 23:56:56.008	2025-08-29 23:56:56.008	f	\N	\N	\N	\N
aa9d310d-9830-4f6d-a31d-4facd0fc70e7	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3069a32a-248f-4b3a-88cf-7d6981126a1b	INCOME	Pagamento - VDA000002	239.00	2025-08-29 23:58:47.69	\N	PAID	Vendas	VDA000002	Pagamento de Andrey Firmino Freitas	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-29 23:58:47.691	2025-08-29 23:58:47.691	f	\N	\N	\N	\N
\.


--
-- TOC entry 3654 (class 0 OID 29225)
-- Dependencies: 228
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_methods (id, "companyId", name, description, "isActive", fee, color, "sortOrder", "createdAt", "updatedAt", "isInstallmentMethod", "accountId") FROM stdin;
004ba4a3-6989-4d03-9952-0b71a3998132	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	PIX	Pagamento via PIX	t	\N	#2196F3	0	2025-08-27 20:10:43.48	2025-08-28 16:57:10.826	f	3069a32a-248f-4b3a-88cf-7d6981126a1b
e4f0e27e-ffa2-42f7-94ed-59882afd8b2b	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Cartão de Crédito	Pagamento via cartão de crédito	t	5.00	#20f398	0	2025-08-27 20:11:24.957	2025-08-28 16:57:19.889	f	622b9cca-8ef9-465a-9a9e-b7db66c56d60
d222033d-a719-4e67-ac22-3b6fc2d25d5f	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	A Prazo	Pagamento parcelado	t	\N	#f59e0b	0	2025-08-28 18:50:55.728	2025-08-28 19:22:44.274	t	3069a32a-248f-4b3a-88cf-7d6981126a1b
\.


--
-- TOC entry 3655 (class 0 OID 29235)
-- Dependencies: 229
-- Data for Name: payment_terms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payment_terms (id, "companyId", name, days, description, "isActive", interest, "sortOrder", "createdAt", "updatedAt", "installmentInterval", "installmentsCount", "isInstallment") FROM stdin;
9a26c6b9-26bc-4c28-a65c-e1fb58455e35	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Direto 30	30		t	\N	0	2025-08-27 20:12:10.566	2025-08-28 14:03:57.319	30	3	f
0b7e2291-416c-4c7f-99d5-b4470c26d904	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	2x	30	Pagamento em 30/60	t	\N	1	2025-08-27 20:12:29.491	2025-08-28 14:04:05.654	30	2	t
1393cf5e-79ea-4e8d-bf03-efb1014279e4	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	3x	30	Pagamento em 30/60/90	t	\N	2	2025-08-28 14:03:40.008	2025-08-28 14:04:10.29	30	3	t
ce57c61e-2af2-4508-8f76-a882e9aa1a15	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	4x	30	Pagamento em 30/60/90/120	t	\N	3	2025-08-28 14:04:36.593	2025-08-28 14:04:36.593	30	4	t
0a7bb2ba-9412-4aae-ae9d-b5ed092c8b7a	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	4x 30/60/90/120	30	Pagamento em 4 parcelas: 30, 60, 90 e 120 dias	t	\N	0	2025-08-28 18:50:55.687	2025-08-28 18:50:55.687	30	4	t
\.


--
-- TOC entry 3656 (class 0 OID 29390)
-- Dependencies: 230
-- Data for Name: printers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.printers (id, name, description, "isDefault", "isActive", "companyId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 3647 (class 0 OID 29159)
-- Dependencies: 221
-- Data for Name: product_variations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variations (id, "productId", size, color, model, sku, barcode, "costPrice", "salePrice", "stockQuantity", "isActive", "createdAt", "updatedAt") FROM stdin;
bf9a4688-5bd3-4e30-9016-eb634d18518c	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	P	Vermelho		\N	\N	\N	239.00	36	t	2025-08-27 20:08:25.215	2025-08-28 19:58:32.446
021d29aa-b489-42be-ba43-4598128146ab	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	P	Azul		\N	\N	\N	239.00	17	t	2025-08-27 20:08:25.215	2025-08-29 23:53:43.698
350045a5-b519-4281-8e44-1b6ecea4e2f7	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	M	Preto		\N	\N	\N	239.00	23	t	2025-08-27 20:08:25.215	2025-08-29 23:56:56
\.


--
-- TOC entry 3646 (class 0 OID 29149)
-- Dependencies: 220
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, "companyId", sku, name, description, "categoryId", "supplierId", barcode, "costPrice", "salePrice", "promotionalPrice", "minStock", "maxStock", weight, dimensions, images, specifications, "isActive", "createdAt", "updatedAt") FROM stdin;
5e9682af-86e7-48b2-86d3-5dd28eedf3e7	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	\N	Vestido Farm	\N	7d72d557-04dd-4a74-a82f-6aed11e252c9	\N	7899852700748	150.00	239.00	\N	0	\N	\N	\N	\N	\N	t	2025-08-27 20:08:25.215	2025-08-27 20:08:25.215
61b4b6a9-41ea-4ea8-8916-b51d54e4cd02	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	TEST001	Produto Teste Parcelamento	\N	\N	\N	\N	600.00	1000.00	\N	10	\N	\N	\N	\N	\N	f	2025-08-28 18:50:55.803	2025-08-29 19:45:26.941
\.


--
-- TOC entry 3657 (class 0 OID 31881)
-- Dependencies: 231
-- Data for Name: sale_installments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sale_installments (id, "saleId", "installmentNumber", amount, "dueDate", "paymentDate", status, notes, "createdAt", "updatedAt") FROM stdin;
796334b4-26b6-46eb-812c-b26e225d80b2	1ca979c5-28aa-4512-9e52-a2ef2e5971d9	2	597.50	2025-10-27 19:23:20.818	\N	PENDING	Parcela 2/2 da venda VDA000001	2025-08-28 19:23:20.864	2025-08-28 19:23:20.864
c9d5e7d4-f6e8-4982-82dc-35a415d470c0	1ca979c5-28aa-4512-9e52-a2ef2e5971d9	1	597.50	2025-09-27 19:23:20.818	2025-08-29 20:23:55.266	PAID	Parcela 1/2 da venda VDA000001	2025-08-28 19:23:20.86	2025-08-29 20:23:55.266
\.


--
-- TOC entry 3651 (class 0 OID 29197)
-- Dependencies: 225
-- Data for Name: sale_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sale_items (id, "saleId", "productId", "variationId", quantity, "unitPrice", "totalPrice", discount, "createdAt") FROM stdin;
8860116a-ddac-48c1-93bd-1609a5f77651	1ca979c5-28aa-4512-9e52-a2ef2e5971d9	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	021d29aa-b489-42be-ba43-4598128146ab	5	239.00	1195.00	0.00	2025-08-28 19:23:20.829
2f8a6039-a863-4505-89c4-7fa2dc1a0e50	b5fa2df1-d453-4bec-acc7-7b523efec250	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	350045a5-b519-4281-8e44-1b6ecea4e2f7	1	239.00	239.00	0.00	2025-08-28 19:24:36.824
a4cc3391-e134-4b07-8cbc-7b0e9b4676ed	e1f8b175-df00-4b80-827b-760415ded6e6	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	1	239.00	239.00	0.00	2025-08-28 19:58:32.441
2e30bd62-f3e6-4633-8269-106fe2e9bc52	e9e20f2b-7f27-482b-b479-af1a71f9dd5a	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	021d29aa-b489-42be-ba43-4598128146ab	1	239.00	239.00	0.00	2025-08-29 23:53:43.692
0173703f-b694-4d7e-a27f-922460803ffb	004f2854-5e7e-420b-96f8-b3b4ff29dd27	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	350045a5-b519-4281-8e44-1b6ecea4e2f7	1	239.00	239.00	0.00	2025-08-29 23:56:55.997
\.


--
-- TOC entry 3650 (class 0 OID 29186)
-- Dependencies: 224
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales (id, "companyId", "customerId", "saleNumber", "totalAmount", discount, "paymentMethodId", "paymentStatus", "saleStatus", "dueDate", notes, "isActive", "createdAt", "updatedAt", "paymentTermId", "discountType", "finalAmount", "totalFees") FROM stdin;
1ca979c5-28aa-4512-9e52-a2ef2e5971d9	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	fe481745-ff67-4b46-8d99-f560366b3f92	VDA000001	1195.00	0.00	d222033d-a719-4e67-ac22-3b6fc2d25d5f	PENDING	COMPLETED	2025-09-27 19:23:20.818		t	2025-08-28 19:23:20.819	2025-08-28 19:23:20.819	0b7e2291-416c-4c7f-99d5-b4470c26d904	percentage	1195.00	0.00
e1f8b175-df00-4b80-827b-760415ded6e6	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	\N	VDA000003	239.00	0.00	004ba4a3-6989-4d03-9952-0b71a3998132	PAID	COMPLETED	\N		t	2025-08-28 19:58:32.428	2025-08-28 19:58:32.428	\N	percentage	239.00	0.00
e9e20f2b-7f27-482b-b479-af1a71f9dd5a	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	\N	VDA000004	239.00	0.00	e4f0e27e-ffa2-42f7-94ed-59882afd8b2b	PAID	COMPLETED	\N		t	2025-08-29 23:53:43.686	2025-08-29 23:53:43.686	\N	percentage	250.95	11.95
004f2854-5e7e-420b-96f8-b3b4ff29dd27	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	\N	VDA000005	239.00	0.00	e4f0e27e-ffa2-42f7-94ed-59882afd8b2b	PAID	COMPLETED	\N		t	2025-08-29 23:56:55.993	2025-08-29 23:56:55.993	\N	percentage	250.95	11.95
b5fa2df1-d453-4bec-acc7-7b523efec250	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	fe481745-ff67-4b46-8d99-f560366b3f92	VDA000002	239.00	0.00	d222033d-a719-4e67-ac22-3b6fc2d25d5f	PAID	COMPLETED	2025-09-27 19:24:36.817		t	2025-08-28 19:24:36.818	2025-08-29 23:58:47.629	9a26c6b9-26bc-4c28-a65c-e1fb58455e35	percentage	239.00	0.00
\.


--
-- TOC entry 3648 (class 0 OID 29169)
-- Dependencies: 222
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stock_movements (id, "productId", "variationId", "movementType", quantity, "previousQuantity", "newQuantity", "unitCost", "totalCost", "referenceDocument", notes, "userId", "createdAt") FROM stdin;
bf99fdfe-9853-434b-be5c-ab9a01358911	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	ENTRY	50	\N	\N	0.00	\N			4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-27 20:08:38.548
983e245b-4de0-4eb2-a36f-964426fb37c3	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	021d29aa-b489-42be-ba43-4598128146ab	ENTRY	25	\N	\N	0.00	\N			4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-27 20:08:38.595
c595fcf0-fc19-4b70-b638-57b192083aad	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	350045a5-b519-4281-8e44-1b6ecea4e2f7	ENTRY	25	\N	\N	0.00	\N			4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-27 20:08:38.617
989151c3-99d5-4519-92a1-906b88346405	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000001	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-27 20:13:05.323
2824c1db-aa9c-413f-a5f0-cfe7151abfe2	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000002	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-27 20:22:20.503
3f2194bf-88a1-4d25-8649-3e7952d57ca1	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000003	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 13:32:40.541
f1d8085c-6658-41ca-b523-8460c9f0ff69	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	4	\N	\N	\N	\N	Venda VDA000004	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 13:35:30.496
63942a6c-2c73-4400-ba13-56ed77d95ca4	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000003	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 14:00:08.301
6eec757b-2c97-4387-ba11-dcb8c3645097	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000004	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 14:12:55.397
0946b124-9db2-4e39-92f9-d3b97dcd4195	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000005	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 14:41:59.004
d8f6865e-617a-435a-9706-5851e945771e	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000006	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 14:52:18.871
31e85cdc-7ce7-490a-b7f1-8f452ed178ef	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000007	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 16:42:57.132
86670c40-acb3-4c83-a9cd-87475955a7ed	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	021d29aa-b489-42be-ba43-4598128146ab	EXIT	2	\N	\N	\N	\N	Venda VDA000001	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 17:05:31.687
ef11b4f7-d1ff-4bb9-9e25-3c74c9b9472c	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000001	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 17:46:46.677
62e85cd3-d52a-4411-b8bd-d2f70c3c8116	61b4b6a9-41ea-4ea8-8916-b51d54e4cd02	\N	EXIT	1	\N	\N	\N	\N	Venda VDA000001	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 18:50:55.876
e2f67fa7-5016-46a7-885b-0d75803a61e4	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	021d29aa-b489-42be-ba43-4598128146ab	EXIT	5	\N	\N	\N	\N	Venda VDA000001	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:23:20.838
235dd6c0-b746-41dc-b3ad-fb60f9668db4	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	350045a5-b519-4281-8e44-1b6ecea4e2f7	EXIT	1	\N	\N	\N	\N	Venda VDA000002	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:24:36.833
29e76e8f-05bd-4f9d-bad9-c7254dc322a2	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	bf9a4688-5bd3-4e30-9016-eb634d18518c	EXIT	1	\N	\N	\N	\N	Venda VDA000003	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-28 19:58:32.45
6aa9c70c-7cbb-431d-8e1d-5736f5c074d7	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	021d29aa-b489-42be-ba43-4598128146ab	EXIT	1	\N	\N	\N	\N	Venda VDA000004	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-29 23:53:43.702
289ddc62-36f2-44f8-bdbd-d3df178be3dc	5e9682af-86e7-48b2-86d3-5dd28eedf3e7	350045a5-b519-4281-8e44-1b6ecea4e2f7	EXIT	1	\N	\N	\N	\N	Venda VDA000005	Venda realizada via PDV	4e7ade9c-0af0-447d-aee3-8717457cd634	2025-08-29 23:56:56.003
\.


--
-- TOC entry 3645 (class 0 OID 29140)
-- Dependencies: 219
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.suppliers (id, name, cnpj, email, phone, address, "contactPerson", "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- TOC entry 3642 (class 0 OID 29114)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, "companyId", name, email, "passwordHash", role, permissions, "isActive", "lastLogin", "createdAt", "updatedAt") FROM stdin;
4e7ade9c-0af0-447d-aee3-8717457cd634	49a08b4b-ea6a-4ae6-8e9a-78cfd150bfe6	Rodrigo Freitas	rodrigopeixotodefreitas@gmail.com	$2b$12$AROlEJt.ADMoJNpiG0uazupIjXy4yNKgdaimQXqaAzNIZXGNqhf1C	admin	{}	t	2025-09-04 14:16:43.717	2025-08-27 20:04:11.169	2025-09-04 14:16:43.718
7ab4db1c-8c2e-4e29-8024-0e9e1f2eca11	\N	Andrey Freitas	dreyggs@gmail.com	$2b$10$qD6EFCTCnqq7fPqIfjcQ7Okqx0l0Eur.tLWr0m8Oy7t74.oa3IWwi	master	\N	t	2025-09-04 17:14:13.85	2025-08-27 19:57:23.026	2025-09-04 17:14:13.851
\.


--
-- TOC entry 3422 (class 2606 OID 29019)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3470 (class 2606 OID 32784)
-- Name: backups backups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backups
    ADD CONSTRAINT backups_pkey PRIMARY KEY (id);


--
-- TOC entry 3434 (class 2606 OID 29139)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3426 (class 2606 OID 29113)
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- TOC entry 3432 (class 2606 OID 29130)
-- Name: company_settings company_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_settings
    ADD CONSTRAINT company_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3450 (class 2606 OID 29185)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 3457 (class 2606 OID 29215)
-- Name: financial_accounts financial_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financial_accounts
    ADD CONSTRAINT financial_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 3459 (class 2606 OID 29224)
-- Name: financial_transactions financial_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT financial_transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 3461 (class 2606 OID 29234)
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- TOC entry 3463 (class 2606 OID 29245)
-- Name: payment_terms payment_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_terms
    ADD CONSTRAINT payment_terms_pkey PRIMARY KEY (id);


--
-- TOC entry 3466 (class 2606 OID 29399)
-- Name: printers printers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.printers
    ADD CONSTRAINT printers_pkey PRIMARY KEY (id);


--
-- TOC entry 3442 (class 2606 OID 29168)
-- Name: product_variations product_variations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_pkey PRIMARY KEY (id);


--
-- TOC entry 3440 (class 2606 OID 29158)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3468 (class 2606 OID 31889)
-- Name: sale_installments sale_installments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_installments
    ADD CONSTRAINT sale_installments_pkey PRIMARY KEY (id);


--
-- TOC entry 3455 (class 2606 OID 29204)
-- Name: sale_items sale_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT sale_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3452 (class 2606 OID 29196)
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- TOC entry 3446 (class 2606 OID 29176)
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- TOC entry 3436 (class 2606 OID 29148)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- TOC entry 3429 (class 2606 OID 29122)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3423 (class 1259 OID 29246)
-- Name: companies_cnpj_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX companies_cnpj_key ON public.companies USING btree (cnpj);


--
-- TOC entry 3424 (class 1259 OID 29247)
-- Name: companies_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX companies_email_key ON public.companies USING btree (email);


--
-- TOC entry 3430 (class 1259 OID 29249)
-- Name: company_settings_companyId_settingKey_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "company_settings_companyId_settingKey_key" ON public.company_settings USING btree ("companyId", "settingKey");


--
-- TOC entry 3447 (class 1259 OID 29254)
-- Name: customers_companyId_cpfCnpj_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "customers_companyId_cpfCnpj_key" ON public.customers USING btree ("companyId", "cpfCnpj");


--
-- TOC entry 3448 (class 1259 OID 29255)
-- Name: customers_companyId_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "customers_companyId_email_key" ON public.customers USING btree ("companyId", email);


--
-- TOC entry 3464 (class 1259 OID 29400)
-- Name: printers_companyId_name_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "printers_companyId_name_key" ON public.printers USING btree ("companyId", name);


--
-- TOC entry 3443 (class 1259 OID 29253)
-- Name: product_variations_productId_barcode_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "product_variations_productId_barcode_key" ON public.product_variations USING btree ("productId", barcode);


--
-- TOC entry 3444 (class 1259 OID 29252)
-- Name: product_variations_productId_sku_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "product_variations_productId_sku_key" ON public.product_variations USING btree ("productId", sku);


--
-- TOC entry 3437 (class 1259 OID 29251)
-- Name: products_companyId_barcode_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "products_companyId_barcode_key" ON public.products USING btree ("companyId", barcode);


--
-- TOC entry 3438 (class 1259 OID 29250)
-- Name: products_companyId_sku_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "products_companyId_sku_key" ON public.products USING btree ("companyId", sku);


--
-- TOC entry 3453 (class 1259 OID 29256)
-- Name: sales_saleNumber_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "sales_saleNumber_key" ON public.sales USING btree ("saleNumber");


--
-- TOC entry 3427 (class 1259 OID 29248)
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- TOC entry 3473 (class 2606 OID 29267)
-- Name: categories categories_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "categories_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3474 (class 2606 OID 29272)
-- Name: categories categories_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "categories_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3472 (class 2606 OID 29262)
-- Name: company_settings company_settings_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_settings
    ADD CONSTRAINT "company_settings_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3481 (class 2606 OID 29307)
-- Name: customers customers_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT "customers_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3489 (class 2606 OID 29342)
-- Name: financial_accounts financial_accounts_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financial_accounts
    ADD CONSTRAINT "financial_accounts_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3490 (class 2606 OID 29352)
-- Name: financial_transactions financial_transactions_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT "financial_transactions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public.financial_accounts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3491 (class 2606 OID 29347)
-- Name: financial_transactions financial_transactions_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT "financial_transactions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3492 (class 2606 OID 30196)
-- Name: financial_transactions financial_transactions_parentTransactionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.financial_transactions
    ADD CONSTRAINT "financial_transactions_parentTransactionId_fkey" FOREIGN KEY ("parentTransactionId") REFERENCES public.financial_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3493 (class 2606 OID 30201)
-- Name: payment_methods payment_methods_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT "payment_methods_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public.financial_accounts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3494 (class 2606 OID 29357)
-- Name: payment_methods payment_methods_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT "payment_methods_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3495 (class 2606 OID 29362)
-- Name: payment_terms payment_terms_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_terms
    ADD CONSTRAINT "payment_terms_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3496 (class 2606 OID 29401)
-- Name: printers printers_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.printers
    ADD CONSTRAINT "printers_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3478 (class 2606 OID 29292)
-- Name: product_variations product_variations_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT "product_variations_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3475 (class 2606 OID 29282)
-- Name: products products_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public.categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3476 (class 2606 OID 29277)
-- Name: products products_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3477 (class 2606 OID 29287)
-- Name: products products_supplierId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "products_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES public.suppliers(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3497 (class 2606 OID 31890)
-- Name: sale_installments sale_installments_saleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_installments
    ADD CONSTRAINT "sale_installments_saleId_fkey" FOREIGN KEY ("saleId") REFERENCES public.sales(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3486 (class 2606 OID 29332)
-- Name: sale_items sale_items_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT "sale_items_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3487 (class 2606 OID 29327)
-- Name: sale_items sale_items_saleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT "sale_items_saleId_fkey" FOREIGN KEY ("saleId") REFERENCES public.sales(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3488 (class 2606 OID 29337)
-- Name: sale_items sale_items_variationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_items
    ADD CONSTRAINT "sale_items_variationId_fkey" FOREIGN KEY ("variationId") REFERENCES public.product_variations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3482 (class 2606 OID 29312)
-- Name: sales sales_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT "sales_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3483 (class 2606 OID 29317)
-- Name: sales sales_customerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT "sales_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES public.customers(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3484 (class 2606 OID 29322)
-- Name: sales sales_paymentMethodId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT "sales_paymentMethodId_fkey" FOREIGN KEY ("paymentMethodId") REFERENCES public.payment_methods(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3485 (class 2606 OID 29369)
-- Name: sales sales_paymentTermId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT "sales_paymentTermId_fkey" FOREIGN KEY ("paymentTermId") REFERENCES public.payment_terms(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3479 (class 2606 OID 29297)
-- Name: stock_movements stock_movements_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT "stock_movements_productId_fkey" FOREIGN KEY ("productId") REFERENCES public.products(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3480 (class 2606 OID 29302)
-- Name: stock_movements stock_movements_variationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT "stock_movements_variationId_fkey" FOREIGN KEY ("variationId") REFERENCES public.product_variations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3471 (class 2606 OID 29257)
-- Name: users users_companyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "users_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2025-09-04 17:14:14 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict Kgax4HaAzyp2x3XXSHnGGZh5hri1LUanzrYfy49BhF9RhpdPOcWVR85rHDuex2d

