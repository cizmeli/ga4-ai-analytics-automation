# GA4 Weekly ETL

**Observed state:** inactive. The current 10-node configuration has no published active version, and the Schedule Trigger is deactivated. All available historical sample data through 2021-01-31 is loaded, so no schedule is needed. The current configuration was not runtime-tested for this documentation sync.

## Main workflow

1. **Schedule Trigger** — intended weekly trigger; deactivated.
2. **Supabase-Get Next Week** — gets the next bounded seven-day period after the latest weekly_kpis.week_end, using 2020-10-31 as the initial boundary and capping at 2021-01-31.
3. **BigQuery-Weekly KPIs** — aggregates events, distinct users, purchase events, purchasing users, and USD revenue from the public GA4 sample table.
4. **Supabase-Upsert KPIs** — upserts by the week's unique key.
5. **Trigger Weekly AI Insights** — invokes the separate insights workflow after KPI persistence.

## Step 30 logging nodes

The current inactive configuration has five logging calls. Each sends an allowlisted stage summary to the shared Project Log Writer:

- **Step 30 Log ETL 01 trigger/start**
- **Step 30 Log ETL 02 weekly window fetch**
- **Step 30 Log ETL 03 aggregate KPI computation**
- **Step 30 Log ETL 04 KPI persistence**
- **Step 30 Log ETL 05 weekly insights handoff**

The shared writer and log destination are described in [GA4 Project Log Writer](ga4-project-log-writer.md).

The export is the current inactive configuration, not a published runtime. It has no credentials and uses placeholders for external IDs. The Schedule Trigger must remain disabled.

## Workflow diagram

~~~mermaid
flowchart LR
  S[Schedule Trigger<br/>deactivated] --> N[Supabase: Get Next Week]
  N --> B[BigQuery: Weekly KPIs]
  B --> U[Supabase: Upsert KPIs]
  U --> I[Trigger Weekly AI Insights]
  S -.-> L1[Step 30 Log ETL 01 trigger/start]
  N -.-> L2[Step 30 Log ETL 02 weekly window fetch]
  B -.-> L3[Step 30 Log ETL 03 aggregate KPI computation]
  U -.-> L4[Step 30 Log ETL 04 KPI persistence]
  I -.-> L5[Step 30 Log ETL 05 weekly insights handoff]
  L1 --> LOG[GA4 Project Log Writer]
  L2 --> LOG
  L3 --> LOG
  L4 --> LOG
  L5 --> LOG
~~~

Export: [ga4-weekly-etl.json](../exports/ga4-weekly-etl.json).