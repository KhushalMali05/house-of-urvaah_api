-- Base Schema Initialization Script for HOMVED

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE IF NOT EXISTS public.users (
    username VARCHAR(255) PRIMARY KEY,
    emailid VARCHAR(255),
    password TEXT,
    contactno VARCHAR(50),
    fullname VARCHAR(255),
    avatar_url TEXT,
    role VARCHAR(50) DEFAULT 'user',
    active BOOLEAN DEFAULT true,
    google_id VARCHAR(255),
    facebook_id VARCHAR(255),
    member_since TIMESTAMP DEFAULT NOW(),
    createdate TIMESTAMP DEFAULT NOW()
);

-- Admins Table
CREATE TABLE IF NOT EXISTS public.admins (
    adminid SERIAL PRIMARY KEY,
    userid VARCHAR(255) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    active BOOLEAN DEFAULT true,
    accesstopage TEXT[],
    createdate TIMESTAMP DEFAULT NOW()
);

-- Audit Logs Table
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id SERIAL PRIMARY KEY,
    admin_id INT,
    username VARCHAR(255),
    action VARCHAR(255),
    details TEXT,
    ip_address VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Categories Table
CREATE TABLE IF NOT EXISTS public.categories (
    id SERIAL PRIMARY KEY,
    category_id SERIAL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Subcategories Table
CREATE TABLE IF NOT EXISTS public.subcategories (
    id SERIAL PRIMARY KEY,
    srno SERIAL,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Brands Table
CREATE TABLE IF NOT EXISTS public.brands (
    id SERIAL PRIMARY KEY,
    brand_id SERIAL,
    name VARCHAR(255) NOT NULL,
    logo TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Products Table
CREATE TABLE IF NOT EXISTS public.products (
    product_id SERIAL PRIMARY KEY,
    id INT,
    productname VARCHAR(255),
    title VARCHAR(255),
    brand VARCHAR(255),
    brand_id INT,
    category_id INT,
    subcategory_id INT,
    shortdescription TEXT,
    description TEXT,
    price NUMERIC(10,2) DEFAULT 0,
    originalprice NUMERIC(10,2) DEFAULT 0,
    sale_price NUMERIC(10,2),
    discount NUMERIC(10,2) DEFAULT 0,
    rating NUMERIC(3,2) DEFAULT 0,
    reviews INT DEFAULT 0,
    reviews_count INT DEFAULT 0,
    image TEXT,
    image_url TEXT,
    product_images TEXT[],
    images TEXT[],
    instock BOOLEAN DEFAULT true,
    stock INT DEFAULT 0,
    stock_quantity INT DEFAULT 0,
    quantity INT DEFAULT 0,
    benefits TEXT,
    ingredients TEXT,
    usage TEXT,
    directions TEXT,
    supports TEXT[],
    expiryinfo TEXT,
    specifications JSONB,
    promoted BOOLEAN DEFAULT false,
    active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Ensure products table has brand column for legacy JOIN compatibility
ALTER TABLE public.products ADD COLUMN IF NOT EXISTS brand VARCHAR(255);

-- Views for singular table names (compatibility)
CREATE OR REPLACE VIEW public.category AS 
SELECT id AS category_id, id, name, description, image_url, is_active, created_at FROM public.categories;

CREATE OR REPLACE VIEW public.brand AS 
SELECT id AS brand_id, id, name, logo, description, created_at FROM public.brands;

CREATE OR REPLACE VIEW public.subcategory AS 
SELECT id AS srno, id, category_id, name, description, image_url, is_active, created_at FROM public.subcategories;

-- User Addresses Table
CREATE TABLE IF NOT EXISTS public.user_addresses (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(username) ON DELETE CASCADE,
    full_address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(50),
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Orders Table
CREATE TABLE IF NOT EXISTS public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(100),
    user_id VARCHAR(255),
    address_id INT,
    total NUMERIC(10,2) DEFAULT 0,
    subtotal NUMERIC(10,2) DEFAULT 0,
    tax NUMERIC(10,2) DEFAULT 0,
    shipping_cost NUMERIC(10,2) DEFAULT 0,
    discount NUMERIC(10,2) DEFAULT 0,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'Pending',
    payment_type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Pending',
    razorpay_order_id VARCHAR(255),
    razorpay_payment_id VARCHAR(255),
    refund_status VARCHAR(50),
    refund_id VARCHAR(255),
    refund_txn_id VARCHAR(255),
    refund_receipt_url TEXT,
    refund_processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS public.order_items (
    id SERIAL PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1,
    price NUMERIC(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Cart Table
CREATE TABLE IF NOT EXISTS public.cart (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(username) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Wishlists Table
CREATE TABLE IF NOT EXISTS public.wishlists (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(username) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Reviews Table
CREATE TABLE IF NOT EXISTS public.reviews (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
    user_id VARCHAR(255) REFERENCES users(username) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Health Tips Table
CREATE TABLE IF NOT EXISTS public.health_tips (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    category VARCHAR(100),
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Coupons Table
CREATE TABLE IF NOT EXISTS public.coupons (
    id SERIAL PRIMARY KEY,
    code VARCHAR(100) UNIQUE NOT NULL,
    discount_type VARCHAR(50),
    discount_value NUMERIC(10,2) DEFAULT 0,
    min_order_amount NUMERIC(10,2) DEFAULT 0,
    expiry_date TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS public.transactions (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255),
    order_id UUID,
    transaction_id VARCHAR(255) UNIQUE,
    amount NUMERIC(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);
