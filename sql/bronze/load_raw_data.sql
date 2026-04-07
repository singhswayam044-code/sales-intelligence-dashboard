-- ============================================
-- BRONZE LAYER
-- Tables already created via Databricks UI upload
-- This file documents and verifies all 9 tables
-- ============================================

-- Verify all tables exist by selecting 1 row from each

SELECT 'orders' AS table_name, COUNT(*) AS row_count 
FROM dev_catalog.olist_bronze.olist_orders_dataset

UNION ALL

SELECT 'order_items', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_order_items_dataset

UNION ALL

SELECT 'customers', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_customers_dataset

UNION ALL

SELECT 'sellers', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_sellers_dataset

UNION ALL

SELECT 'products', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_products_dataset

UNION ALL

SELECT 'payments', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_order_payments_dataset

UNION ALL

SELECT 'reviews', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_order_reviews_dataset

UNION ALL

SELECT 'geolocation', COUNT(*) 
FROM dev_catalog.olist_bronze.olist_geolocation_dataset

UNION ALL

SELECT 'category_translation', COUNT(*) 
FROM dev_catalog.olist_bronze.product_category_name_translation

ORDER BY table_name;
