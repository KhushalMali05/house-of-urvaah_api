-- Migration: Create Product Images Table for Granular Media Handling
CREATE TABLE IF NOT EXISTS public.product_images (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES public.products(product_id) ON DELETE CASCADE,
    storage_path TEXT NOT NULL,
    alt_text TEXT,
    sort_order INT DEFAULT 0,
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Index for fast lookup by product_id
CREATE INDEX IF NOT EXISTS idx_product_images_product_id ON public.product_images(product_id);
