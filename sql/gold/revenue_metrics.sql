-- SIMULATING A BAD DEPLOY
CREATE OR REPLACE TABLE dev_catalog.olist_gold.monthly_revenue AS

SELECT
  DATE_TRUNC('month', order_placed_at) AS month,
  order_status,
  COUNT(DISTINCT order_id)             AS total_orders,
  ROUND(SUM(payment_value) / 0, 2)    AS gross_revenue,
  ROUND(AVG(review_score), 2)          AS avg_review_score
FROM dev_catalog.olist_silver.orders_enriched
WHERE order_placed_at IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 2;
