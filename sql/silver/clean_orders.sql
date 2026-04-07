

CREATE OR REPLACE TABLE dev_catalog.olist_silver.orders_enriched AS

SELECT
  -- Order identifiers
  o.order_id,
  o.customer_id,
  o.order_status,

  -- Timestamps cast properly
  CAST(o.order_purchase_timestamp AS TIMESTAMP)        AS order_placed_at,
  CAST(o.order_approved_at AS TIMESTAMP)               AS order_approved_at,
  CAST(o.order_delivered_carrier_date AS TIMESTAMP)    AS shipped_at,
  CAST(o.order_delivered_customer_date AS TIMESTAMP)   AS delivered_at,
  CAST(o.order_estimated_delivery_date AS TIMESTAMP)   AS estimated_delivery_at,

  -- Delivery performance
  DATEDIFF(
    CAST(o.order_delivered_customer_date AS TIMESTAMP),
    CAST(o.order_purchase_timestamp AS TIMESTAMP)
  ) AS actual_delivery_days,

  DATEDIFF(
    CAST(o.order_estimated_delivery_date AS TIMESTAMP),
    CAST(o.order_delivered_customer_date AS TIMESTAMP)
  ) AS days_early_or_late,  -- positive = early, negative = late

  -- Customer location
  c.customer_city,
  c.customer_state,
  c.customer_zip_code_prefix,

  -- Item details
  i.order_item_id,
  i.product_id,
  i.seller_id,
  CAST(i.price AS DOUBLE)          AS item_price,
  CAST(i.freight_value AS DOUBLE)  AS freight_value,
  (CAST(i.price AS DOUBLE) + CAST(i.freight_value AS DOUBLE)) AS total_item_value,

  -- Seller location
  s.seller_city,
  s.seller_state,

  -- Payment details
  p.payment_type,
  p.payment_installments,
  CAST(p.payment_value AS DOUBLE) AS payment_value,

  -- Review details
  r.review_score,
  r.review_comment_title,
  r.review_comment_message,

  -- Product category (translated to English)
  COALESCE(cat.product_category_name_english, 'uncategorized') AS category_name,
  prod.product_weight_g,
  prod.product_length_cm,
  prod.product_height_cm,
  prod.product_width_cm

FROM dev_catalog.olist_bronze.olist_orders_dataset o

LEFT JOIN dev_catalog.olist_bronze.olist_customers_dataset c
  ON o.customer_id = c.customer_id

LEFT JOIN dev_catalog.olist_bronze.olist_order_items_dataset i
  ON o.order_id = i.order_id

LEFT JOIN dev_catalog.olist_bronze.olist_sellers_dataset s
  ON i.seller_id = s.seller_id

LEFT JOIN dev_catalog.olist_bronze.olist_order_payments_dataset p
  ON o.order_id = p.order_id
  AND p.payment_sequential = 1  -- take only first payment row per order

LEFT JOIN dev_catalog.olist_bronze.olist_order_reviews_dataset r
  ON o.order_id = r.order_id

LEFT JOIN dev_catalog.olist_bronze.olist_products_dataset prod
  ON i.product_id = prod.product_id

LEFT JOIN dev_catalog.olist_bronze.product_category_name_translation cat
  ON prod.product_category_name = cat.product_category_name;
