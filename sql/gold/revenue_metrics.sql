-- ============================================
-- GOLD LAYER: Monthly Revenue KPIs
-- Powers the main KPI tiles on the dashboard
-- ============================================

-- First create gold schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS dev_catalog.olist_gold;

CREATE OR REPLACE TABLE dev_catalog.olist_gold.monthly_revenue AS

SELECT
  DATE_TRUNC('month', order_placed_at)          AS month,
  COUNT(DISTINCT order_id)                       AS total_orders,
  COUNT(DISTINCT customer_id)                    AS unique_customers,
  ROUND(SUM(payment_value), 2)                   AS gross_revenue,
  ROUND(AVG(item_price), 2)                      AS avg_order_value,
  ROUND(AVG(review_score), 2)                    AS avg_review_score,
  ROUND(AVG(actual_delivery_days), 1)            AS avg_delivery_days,
  COUNT(CASE WHEN days_early_or_late < 0 
        THEN 1 END)                              AS late_deliveries,
  COUNT(CASE WHEN review_score >= 4 
        THEN 1 END)                              AS positive_reviews

FROM dev_catalog.olist_silver.orders_enriched

WHERE
  order_placed_at IS NOT NULL
  AND order_status = 'delivered'

GROUP BY 1
ORDER BY 1;
