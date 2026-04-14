# Sales Intelligence Dashboard
### Production-grade analytics built on Databricks AI/BI + Delta Lake

---

## What this project demonstrates

This is not a typical portfolio project that just shows a chart.
It demonstrates **how professional data teams ship analytics safely at scale** —
with version control, automated deployment, environment management, and rollback.

Every dashboard change in this project is:
- **Reviewable** — via GitHub Pull Requests with screenshots
- **Testable** — auto-deployed to dev workspace before going to production
- **Reversible** — any bad deploy rolled back in under 5 minutes

---

## Dataset

**Olist Brazilian E-Commerce** (Kaggle)
- 100,000 real orders from 2016–2018
- 9 relational tables: orders, customers, sellers, products,
  payments, reviews, geolocation
- Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## Architecture
**Medallion Architecture (Delta Lake):**
- `dev_catalog.olist_bronze` — raw tables as uploaded
- `dev_catalog.olist_silver` — cleaned, joined master table (~112k rows)
- `dev_catalog.olist_gold` — 3 aggregated tables powering the dashboard

---

## Tools Used

| Tool | Purpose |
|---|---|
| Databricks AI/BI | Dashboard authoring and serving |
| Delta Lake | Bronze / Silver / Gold storage layers |
| Databricks SQL | Data modeling and transformation |
| Databricks Asset Bundles | Packaging dashboard for deployment |
| Unity Catalog | Data governance |
| GitHub | Version control for all SQL and dashboard definitions |
| GitHub Actions | CI/CD — auto-deploy on PR merge |

---

## Dashboard Sections

1. **KPI Tiles** — Total Orders, Gross Revenue, Avg Delivery Days, Avg Review Score
2. **Revenue Trend** — Monthly gross revenue line chart (2016–2018)
3. **Customer Segments** — RFM: Champions, Loyal, New, At Risk, Lost
4. **Seller Leaderboard** — Top 20 sellers by revenue with tier
5. **Category Breakdown** — Top 15 product categories by revenue

---

## Deployment History

| Phase | Change | Type |
|---|---|---|
| 4 | Initial dashboard baseline | Feature |
| 5 | Split revenue by order status (Finance request) | Feature |
| 7 | Simulated bad deploy + rollback | Hotfix |
| 7 | Proper fix redeployed | Fix |

---

## Interview Answer

> "I built a production-grade analytics dashboard on Databricks using the
> Medallion Architecture with Delta Lake. The project uses Databricks Asset
> Bundles and GitHub Actions for CI/CD — every dashboard change goes through
> a Pull Request, gets deployed to a test environment automatically, and can
> be rolled
