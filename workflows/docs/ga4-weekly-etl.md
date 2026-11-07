# GA4 Weekly ETL

**Observed state:** inactive. The current 10-node configuration has no published active version, and the Schedule Trigger is deactivated. All available historical sample data through 2021-01-31 is loaded, so no schedule is needed. The export is the verified captured graph with portable references and `active=false`; it was not runtime-tested in this documentation sync.

## Main workflow

1. **Schedule Trigger** — intended weekly trigger; deactivated.
2. **Supabase-Get Next Week** — gets the next bounded seven-day period after the latest `weekly_kpis.week_end`, using 2020-10-31 as the initial boundary and capping at 2021-01-31.
3. **BigQuery-Weekly KPIs** — aggregates events, distinct users, purchase events, purchasing users, and USD revenue from the public GA4 sample table.
4. **Supabase-Upsert KPIs** — upserts by the week's unique key.
5. **Trigger Weekly AI Insights** — invokes the separate insights workflow after KPI persistence.

## Project Log Writer calls

The inactive 10-node graph has five logging calls to the shared Project Log Writer:

- `Log ETL — Workflow run started`
- `Log ETL — Next weekly window loaded`
- `Log ETL — Weekly KPIs aggregated`
- `Log ETL — Weekly KPIs saved`
- `Log ETL — Insights workflow handoff completed`

They send allowlisted stage summaries and do not replace KPI persistence.

## Workflow diagram

~~~mermaid
flowchart LR
  S[Schedule Trigger<br/>deactivated] --> N[Supabase-Get Next Week]
  N --> B[BigQuery-Weekly KPIs]
  B --> U[Supabase-Upsert KPIs]
  U --> I[Trigger Weekly AI Insights]
  S -.-> L1[Log ETL — Workflow run started]
  N -.-> L2[Log ETL — Next weekly window loaded]
  B -.-> L3[Log ETL — Weekly KPIs aggregated]
  U -.-> L4[Log ETL — Weekly KPIs saved]
  I -.-> L5[Log ETL — Insights workflow handoff completed]
  L1 --> LOG[GA4 Project Log Writer]
  L2 --> LOG
  L3 --> LOG
  L4 --> LOG
  L5 --> LOG
~~~

The export has no credentials and uses placeholders for external workflow and project references. Keep the Schedule Trigger disabled.

Export: [ga4-weekly-etl.json](../exports/ga4-weekly-etl.json).
