# Setup guide

## Prerequisites

- Docker Desktop, n8n, and a Google Cloud project where BigQuery access is enabled.
- Access to the public `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` dataset.
- A Supabase PostgreSQL project and a Google Drive / Slides template you control.
- Metabase OSS if you want the local dashboard.

## Configure n8n

1. Create a PostgreSQL credential for Supabase using the Session Pooler host/user shown in the Supabase Connect panel, port 5432, database `postgres`, and SSL enabled. Do not put the password in this repo.
2. Add Google BigQuery and Google Drive credentials using n8n's credential store.
3. Import one sanitized JSON from `workflows/exports/` at a time. Assign credentials to matching nodes.
4. Replace the presentation-template identifier and called-workflow reference. Connect the invoked Weekly AI Insights workflow by selecting the imported workflow in the tool node.
5. Confirm node parameter fields and expressions against your n8n version. The exports are portable starting points, not turnkey credentials.
6. Keep the Schedule Trigger disabled until a manual run is validated. The observed source ETL is currently inactive and its schedule trigger is deactivated.

## Database

`sql/schema.sql` is an example of the three tables used by the checked assistant and presentation workflow. The original notes explicitly verify only `weekly_kpis`; inspect existing tables before running DDL to avoid conflicts. Apply `sql/weekly_analytics.sql` only after confirming schema and grants.

## BigQuery period query

The ETL export contains the actual query. It uses the `week_start` / `week_end` values returned by `Supabase-Get Next Week` and constrains `_TABLE_SUFFIX` to the requested date interval. Confirm expressions, UTC/date semantics, and one-row output in your own instance before running a large backfill.

## Metabase

Use the sample in `docker/compose.yaml` for a local demo only. Connect a dedicated PostgreSQL role with SELECT access. Dashboard's observed local URL is `http://localhost:3001`; keep authentication enabled.

## After import

- Test the assistant with non-sensitive sample questions.
- Check idempotency by re-running only against the intended demo period.
- Confirm the assistant excludes partial periods in full-week comparisons.
- Manually request slide generation once and inspect the copied file and cached URL.
- Do not activate scheduled ETL until all downstream behavior is understood.
