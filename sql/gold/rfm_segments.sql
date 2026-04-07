CREATE OR REPLACE TABLE dev_catalog.olist_gold.customer_rfm AS

WITH rfm_base AS (
  SELECT
    customer_id,

    DATEDIFF(
      DATE('2018-12-31'),
      MAX(DATE(order_placed_at))
    ) AS recency_days,

    COUNT(DISTINCT order_id)     AS frequency,
    ROUND(SUM(payment_value), 2) AS monetary_value

  FROM dev_catalog.olist_silver.orders_enriched
  WHERE order_status = 'delivered'
  GROUP BY customer_id
),

rfm_scored AS (
  SELECT *,
    NTILE(5) OVER (ORDER BY recency_days DESC)   AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC)       AS f_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC)  AS m_score
  FROM rfm_base
)

SELECT
  customer_id,
  recency_days,
  frequency,
  monetary_value,
  r_score,
  f_score,
  m_score,
  ROUND((r_score + f_score + m_score) / 3.0, 1) AS rfm_avg,

  CASE
    WHEN r_score >= 4 AND f_score >= 4  THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 3  THEN 'Loyal Customers'
    WHEN r_score >= 4 AND f_score <= 2  THEN 'New Customers'
    WHEN r_score <= 2 AND f_score >= 3  THEN 'At Risk'
    WHEN r_score <= 2 AND f_score <= 2  THEN 'Lost'
    ELSE                                     'Potential Loyalists'
  END AS segment

FROM rfm_scored;
