-- Step 32 v6 draft for GA4 - Weekly AI Insights.
-- Status: unpublished on 2026-11-05; not included in the published workflow export.
-- Read-only comparison query over aggregated weekly KPIs.
-- Adds current and prior purchase-user counts. 8/8 no-write output hard gates passed;
-- this evaluation does not activate or runtime-certify the workflow.

WITH weekly AS (
    SELECT week_start, week_end, total_users, purchases, purchase_users, revenue_usd,
           100.0 * purchase_users / NULLIF(total_users, 0) AS conversion_rate_pct,
           revenue_usd / NULLIF(purchases, 0) AS revenue_per_purchase_usd
    FROM public.weekly_kpis
    WHERE week_end = week_start + 6
),
comparison AS (
    SELECT *,
           LAG(week_start) OVER w AS prev_week_start,
           LAG(week_end) OVER w AS prev_week_end,
           LAG(total_users) OVER w AS prev_users,
           LAG(purchase_users) OVER w AS prev_purchase_users,
           LAG(purchases) OVER w AS prev_purchases,
           LAG(revenue_usd) OVER w AS prev_revenue,
           LAG(conversion_rate_pct) OVER w AS prev_conversion_rate,
           LAG(revenue_per_purchase_usd) OVER w AS prev_revenue_per_purchase
    FROM weekly WINDOW w AS (ORDER BY week_start)
),
selected AS (
    SELECT week_start::text AS week_start,
           week_end::text AS week_end,
           week_start::text AS current_week_start,
           week_end::text AS current_week_end,
           total_users, purchase_users, purchases, revenue_usd,
           ROUND(conversion_rate_pct, 2) AS conversion_rate_pct,
           ROUND(revenue_per_purchase_usd, 2) AS revenue_per_purchase_usd,
           prev_week_start::text AS prev_week_start,
           prev_week_end::text AS prev_week_end,
           prev_week_start::text AS comparison_week_start,
           prev_week_end::text AS comparison_week_end,
           prev_users, prev_purchase_users, prev_purchases, prev_revenue,
           ROUND(prev_conversion_rate, 2) AS prev_conversion_rate,
           ROUND(prev_revenue_per_purchase, 2) AS prev_revenue_per_purchase_usd,
           ROUND(100.0 * (total_users - prev_users) / NULLIF(prev_users, 0), 2) AS users_wow_pct,
           ROUND(100.0 * (purchases - prev_purchases) / NULLIF(prev_purchases, 0), 2) AS purchases_wow_pct,
           ROUND(100.0 * (revenue_usd - prev_revenue) / NULLIF(prev_revenue, 0), 2) AS revenue_wow_pct,
           ROUND(conversion_rate_pct - prev_conversion_rate, 2) AS conversion_change_pp,
           ROUND(100.0 * (revenue_per_purchase_usd - prev_revenue_per_purchase)
                / NULLIF(prev_revenue_per_purchase, 0), 2) AS revenue_per_purchase_wow_pct
    FROM comparison
    WHERE prev_week_start = week_start - 7
      AND prev_week_end = week_end - 7
      AND ($1::date IS NULL OR week_start = $1::date)
    ORDER BY week_start DESC LIMIT 1
)
SELECT selected.*, $1::date::text AS requested_week,
       -- Increment this version whenever the Generate Weekly Insights prompt changes.
       'weekly-insights-v6'::text AS prompt_version
FROM (SELECT 1) AS input
LEFT JOIN selected ON true;
