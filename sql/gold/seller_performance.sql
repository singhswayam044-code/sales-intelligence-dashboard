-- ============================================
-- GOLD LAYER: Seller Performance
-- Powers seller leaderboard and state map
-- ============================================

CREATE OR REPLACE TABLE dev_catalog.olist_gold.seller_performance AS

SELECT
  oe.seller_id,
  oe.seller_city,
  oe.seller_state,

  COUNT(DISTINCT oe.order_id)            AS total_orders,
  COUNT(DISTINCT oe.product_id)          AS unique_products,
  COUNT(DISTINCT oe.customer_id)         AS unique_customers,

  ROUND(SUM(oe.payment_value), 2)        AS total_revenue,
  ROUND(AVG(oe.item_price), 2)           AS avg_item_price,
  ROUND(AVG(oe.review_score), 2)         AS avg_rating,
  ROUND(AVG(oe.actual_delivery_days), 1) AS avg_delivery_days,

  COUNT(CASE WHEN oe.review_score >= 4 THEN 1 END) AS positive_reviews,
  COUNT(CASE WHEN oe.review_score <= 2 THEN 1 END) AS negative_reviews,

  CASE
    WHEN SUM(oe.payment_value) >= 50000 AND AVG(oe.review_score) >= 4 THEN 'Elite'
    WHEN SUM(oe.payment_value) >= 20000                               THEN 'High Volume'
    WHEN AVG(oe.review_score) >= 4.5                                  THEN 'Top Rated'
    ELSE                                                                   'Standard'
  END AS seller_tier

FROM dev_catalog.olist_silver.orders_enriched oe
WHERE oe.order_status = 'delivered'
  AND oe.seller_id IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY total_revenue DESC;
