-- Latest full reporting week
SELECT week_start, week_end, total_users, purchases, purchase_users,
       revenue_usd,
       ROUND(100.0 * purchase_users / NULLIF(total_users, 0), 2) AS conversion_rate_pct
FROM public.weekly_kpis
WHERE week_end - week_start = 6
ORDER BY week_start DESC
LIMIT 1;

-- Complete-week trend and revenue WoW comparison
WITH weekly AS (
  SELECT week_start, week_end, total_users, purchases, purchase_users, revenue_usd,
         ROUND(100.0 * purchase_users / NULLIF(total_users, 0), 2) AS conversion_rate_pct,
         LAG(revenue_usd) OVER (ORDER BY week_start) AS previous_revenue_usd
  FROM public.weekly_kpis
  WHERE week_end - week_start = 6
)
SELECT *, ROUND(100.0 * (revenue_usd - previous_revenue_usd)
        / NULLIF(previous_revenue_usd, 0), 2) AS revenue_wow_pct
FROM weekly ORDER BY week_start LIMIT 20;

-- Find next historical seven-day block (final block can be a partial day)
WITH latest_week AS (
  SELECT COALESCE(MAX(week_end), DATE '2020-10-31') AS last_date
  FROM public.weekly_kpis
)
SELECT TO_CHAR(last_date + 1, 'YYYY-MM-DD') AS week_start,
       TO_CHAR(LEAST(last_date + 7, DATE '2021-01-31'), 'YYYY-MM-DD') AS week_end
FROM latest_week WHERE last_date < DATE '2021-01-31';
