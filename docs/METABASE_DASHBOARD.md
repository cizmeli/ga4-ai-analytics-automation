# Metabase Dashboard Evidence

## Dashboard identity

- Name: **GA4 E-commerce Analytics**
- Local address in project notes: `http://localhost:3001`
- Intended data source: Supabase PostgreSQL, `public.weekly_kpis`
- Data description: anonymized historical GA4 ecommerce sample, 2020-11-01 to 2021-01-31; weekly loads simulate refreshes.

## Captured dashboard details

A local note captured the banner **“Historical GA4 Sample · Simulated Weekly Refresh”** and a latest-loaded-week label of **Jan 17–23, 2021**. It also recorded the `weekly_kpis` native SQL query and a Metabase date-range filter. A later assistant test independently reported the latest complete week as Jan 24–30, 2021. These differing periods indicate that the saved dashboard note may be stale; inspect the live dashboard before presenting it as current.

The recorded query calculates `conversion_rate_pct` as `100 * purchase_users / total_users`. Its alias `average_order_value_usd` is `revenue_usd / purchases`; this should be described as **revenue per purchase** unless separately validated as an order-value definition.

## Dashboard requirements and limits

- Label the source as historical sample data and identify the simulated refresh behavior.
- Exclude the one-day 2021-01-31 block from complete-week comparisons.
- Do not sum weekly distinct users and label the result cross-period unique users.
- Keep conversion rate, users, purchases, and revenue on appropriate scales and units.
- The dashboard chart inventory, filter behavior, data-source permissions, and responsive layout have not been audited in this documentation update.

There is no exported Metabase dashboard JSON, screenshot, or offline interactive dashboard in this repository. The locally hosted dashboard remains the source for visual review. Existing offline project artifacts are the GA4 Slides template versions in `output/` and the assistant test evidence in [`output/ga4-assistant-chat-test-evidence-2026-11-07.md`](../output/ga4-assistant-chat-test-evidence-2026-11-07.md).
