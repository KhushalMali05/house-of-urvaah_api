-- Migration Script: Adapt Database Schema for House of Urvaah (Female Apparel)
-- Created: 2026-04-01

-- 1. Add Female Clothing fields to products table
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS sizes TEXT[] DEFAULT '{"S","M","L","XL"}',
ADD COLUMN IF NOT EXISTS colors TEXT[] DEFAULT '{"Default"}',
ADD COLUMN IF NOT EXISTS fabric VARCHAR(255),
ADD COLUMN IF NOT EXISTS fit_type VARCHAR(100),
ADD COLUMN IF NOT EXISTS care_instructions TEXT,
ADD COLUMN IF NOT EXISTS size_chart_url TEXT,
ADD COLUMN IF NOT EXISTS style_code VARCHAR(100);

-- 2. Insert Default Female Clothing Categories if not exist
INSERT INTO public.categories (name, description, is_active)
SELECT 'Ethnic Wear', 'Sarees, Lehengas, Salwar Suits, Anarkalis & Kurtis', true
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Ethnic Wear');

INSERT INTO public.categories (name, description, is_active)
SELECT 'Western Wear', 'Dresses, Tops, Skirts, Co-ord Sets & Trousers', true
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Western Wear');

INSERT INTO public.categories (name, description, is_active)
SELECT 'Loungewear & Nightwear', 'Pyjamas, Robes & Comfortable Night Suits', true
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Loungewear & Nightwear');

INSERT INTO public.categories (name, description, is_active)
SELECT 'Dupattas & Scarves', 'Designer Dupattas, Stoles & Scarves', true
WHERE NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Dupattas & Scarves');
