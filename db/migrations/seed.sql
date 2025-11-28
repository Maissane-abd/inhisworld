-- ==============================
-- SEED DATA – LUXURY_INSIGHTS
-- ==============================

-- ===== USERS =====
INSERT INTO users (email, password_hash, first_name, last_name, role)
VALUES
    ('admin@luxury.com', 'admin_hashed_password', 'Super', 'Admin', 'admin'),
    ('john.doe@example.com', 'hash1', 'John', 'Doe', 'user'),
    ('sarah.miles@example.com', 'hash2', 'Sarah', 'Miles', 'user'),
    ('kevin.ross@example.com', 'hash3', 'Kevin', 'Ross', 'user'),
    ('emma.white@example.com', 'hash4', 'Emma', 'White', 'user'),
    ('lucas.king@example.com', 'hash5', 'Lucas', 'King', 'user');


-- ===== CATEGORIES =====
INSERT INTO categories (name, slug) VALUES
    ('Sneakers', 'sneakers'),
    ('Streetwear', 'streetwear'),
    ('Haute Couture', 'haute-couture'),
    ('Montres', 'montres'),
    ('Accessoires', 'accessoires'),
    ('Parfums', 'parfums');


-- Save category IDs for product mappings
WITH cat AS (
    SELECT name, id FROM categories
)
SELECT * FROM cat;

-- ===== PRODUCTS =====

INSERT INTO products (category_id, name, slug, description, price, images)
VALUES
    ((SELECT id FROM categories WHERE slug='sneakers'),
        'Nike Air Jordan 1 Retro High', 'nike-air-jordan-1',
        'Modèle iconique de Nike, très recherché.',
        249.99,
        ARRAY['https://example.com/jordan1.jpg']),

    ((SELECT id FROM categories WHERE slug='sneakers'),
        'Yeezy Boost 350 V2', 'yeezy-boost-350',
        'Sneakers Adidas x Kanye West.',
        319.99,
        ARRAY['https://example.com/yeezy350.jpg']),

    ((SELECT id FROM categories WHERE slug='streetwear'),
        'Hoodie Essentials Fear of God', 'essentials-hoodie',
        'Hoodie oversize très populaire.',
        129.99,
        ARRAY['https://example.com/essentials-hoodie.jpg']),

    ((SELECT id FROM categories WHERE slug='streetwear'),
        'T-shirt Supreme Box Logo', 'supreme-box-logo',
        'Pièce rare de Supreme.',
        249.99,
        ARRAY['https://example.com/supreme-box-logo.jpg']),

    ((SELECT id FROM categories WHERE slug='haute-couture'),
        'Sac Dior Saddle', 'dior-saddle',
        'Sac emblématique Dior.',
        2100.00,
        ARRAY['https://example.com/dior-saddle.jpg']),

    ((SELECT id FROM categories WHERE slug='haute-couture'),
        'Louis Vuitton Neverfull MM', 'lv-neverfull-mm',
        'Sac de luxe Louis Vuitton.',
        1750.00,
        ARRAY['https://example.com/lv-neverfull.jpg']),

    ((SELECT id FROM categories WHERE slug='montres'),
        'Rolex Submariner', 'rolex-submariner',
        'Montre Rolex automatique haut de gamme.',
        9800.00,
        ARRAY['https://example.com/rolex-sub.jpg']),

    ((SELECT id FROM categories WHERE slug='montres'),
        'Audemars Piguet Royal Oak', 'ap-royal-oak',
        'Montre de luxe AP, icône horlogère.',
        22500.00,
        ARRAY['https://example.com/ap-royal-oak.jpg']),

    ((SELECT id FROM categories WHERE slug='accessoires'),
        'Ceinture Gucci GG', 'gucci-gg-belt',
        'Accessoire de mode Gucci.',
        450.00,
        ARRAY['https://example.com/gucci-belt.jpg']),

    ((SELECT id FROM categories WHERE slug='parfums'),
        'Dior Sauvage Eau de Parfum', 'dior-sauvage',
        'Parfum masculin iconique.',
        110.00,
        ARRAY['https://example.com/sauvage.jpg']);


-- ===== ORDERS (5 commandes pour tests) =====
INSERT INTO orders (user_id, status, total)
VALUES
    ((SELECT id FROM users WHERE email='john.doe@example.com'), 'paid', 379.98),
    ((SELECT id FROM users WHERE email='sarah.miles@example.com'), 'pending', 129.99),
    ((SELECT id FROM users WHERE email='kevin.ross@example.com'), 'shipped', 9800.00),
    ((SELECT id FROM users WHERE email='emma.white@example.com'), 'paid', 2100.00),
    ((SELECT id FROM users WHERE email='lucas.king@example.com'), 'cancelled', 249.99);


-- ===== ORDER ITEMS =====
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    ((SELECT id FROM orders LIMIT 1),
        (SELECT id FROM products WHERE slug='essentials-hoodie'), 1, 129.99),

    ((SELECT id FROM orders LIMIT 1),
        (SELECT id FROM products WHERE slug='nike-air-jordan-1'), 1, 249.99),

    ((SELECT id FROM orders WHERE total=129.99),
        (SELECT id FROM products WHERE slug='essentials-hoodie'), 1, 129.99),

    ((SELECT id FROM orders WHERE total=9800.00),
        (SELECT id FROM products WHERE slug='rolex-submariner'), 1, 9800.00),

    ((SELECT id FROM orders WHERE total=2100.00),
        (SELECT id FROM products WHERE slug='dior-saddle'), 1, 2100.00);


-- ===== STOCK HISTORY (exemple réaliste) =====
INSERT INTO stock_history (product_id, quantity_change, reason)
VALUES
    ((SELECT id FROM products WHERE slug='nike-air-jordan-1'), -1, 'Order'),
    ((SELECT id FROM products WHERE slug='essentials-hoodie'), -2, 'Orders'),
    ((SELECT id FROM products WHERE slug='rolex-submariner'), -1, 'Order'),
    ((SELECT id FROM products WHERE slug='dior-saddle'), -1, 'Order'),
    ((SELECT id FROM products WHERE slug='yeezy-boost-350'), +5, 'Restock');


-- ===== ANALYTICS EVENTS =====
INSERT INTO analytics_events (user_id, event_type, page, device, referrer, duration_ms, metadata)
VALUES
    ((SELECT id FROM users WHERE email='john.doe@example.com'),
        'view', '/products/nike-air-jordan-1', 'mobile', 'google', 3200, '{"scroll":80}'::jsonb),

    ((SELECT id FROM users WHERE email='sarah.miles@example.com'),
        'add_to_cart', '/products/essentials-hoodie', 'desktop', 'instagram', 5400, '{"color":"black"}'::jsonb),

    ((SELECT id FROM users WHERE email='kevin.ross@example.com'),
        'purchase', '/checkout', 'desktop', 'direct', 11000, '{"items":1}'::jsonb);
