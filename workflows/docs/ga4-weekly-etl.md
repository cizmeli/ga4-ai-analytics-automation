# GA4 Weekly ETL

**Observed state:** workflow inactive; Schedule Trigger node deactivated. No automatic schedule should be assumed.

## Node order and purpose

1. **Schedule Trigger** — intended weekly trigger (plan says Monday 09:00 Europe/Berlin); deactivated in the observed workflow.
2. **Supabase-Get Next Week** — query the latest `weekly_kpis.week_end`, use 2020-10-31 as the initial boundary, and return the next 7-day period capped at 2021-01-31. If the dataset is exhausted, return no rows.
3. **BigQuery-Weekly KPIs** — query the public GA4 sample table with `_TABLE_SUFFIX` bounded by the returned dates; aggregate event rows, distinct users, purchase events, purchasing users, and USD purchase revenue.
4. **Supabase-Upsert KPIs** — upsert by the week's unique key so repeating a period does not create duplicate rows.
5. **Trigger Weekly AI Insights** — invoke the separate insights workflow after KPI storage.

The source export is [ga4-weekly-etl.json](../exports/ga4-weekly-etl.json). It omits credential bindings. The exact Schedule Trigger interval and timezone need inspection before activation.
