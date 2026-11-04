# GA4 AI Analytics Automation

A portfolio and learning project that turns the public Google Analytics 4 (GA4) sample ecommerce events into weekly PostgreSQL metrics, a Metabase dashboard, grounded AI analysis, saved weekly insights, and on-demand Google Slides presentations.

> **Data note:** This project uses anonymized historical sample data from 2020-11-01 through 2021-01-31. Weekly loading simulates refreshes; it is not live GA4 traffic.

## Current implementation

The n8n instance currently contains four GA4 workflows. The workflow exports in this repository are credential-free and have instance-specific Google Drive and subworkflow references replaced with placeholders.

| Workflow | Observed state | Purpose |
|---|---|---|
| [`GA4 Weekly ETL`](workflows/docs/ga4-weekly-etl.md) | Inactive; schedule trigger is deactivated | Reads the next historical week from Supabase, aggregates BigQuery KPIs, upserts the week, then invokes Weekly AI Insights. |
| [`GA4 - Weekly AI Insights`](workflows/docs/ga4-weekly-ai-insights.md) | Published and active | Generates or reuses an insight for a selected complete week, compares it with the prior consecutive complete week, and upserts new reports to `weekly_insights`. |
| [`GA4 - AI Analytics Assistant`](workflows/docs/ga4-ai-analytics-assistant.md) | Published and active | Authenticated chat with read-only KPI tools, on-demand insights, and a presentation tool. Slides run only for explicit presentation requests. |
| [`GA4 - Presentation Generator`](workflows/docs/ga4-presentation-generator.md) | Published and active; PowerPoint export node deactivated | Reuses a cached deck for the same insight version or copies a Slides template, fills placeholders, stores the presentation reference, and returns its link. |

A Metabase dashboard named **GA4 E-commerce Analytics** is open in the local browser at `http://localhost:3001`. The dashboard has not been independently audited for every chart/query in this documentation pass.

## Architecture

```mermaid
flowchart LR
  BQ[BigQuery public GA4 sample] --> ETL[n8n Weekly ETL]
  ETL -->|UPSERT| PG[(Supabase PostgreSQL)]
  ETL -. inactive invocation .-> INS[n8n Weekly AI Insights]
  CHAT[n8n AI Assistant] -->|on-demand insight request| INS
  INS -->|save new report| PG
  PG --> MB[Metabase dashboard]
  CHAT -->|read-only tools| PG
  CHAT --> OR[OpenRouter · Gemini 3.1 Flash Lite]
  CHAT -->|explicit slide request| PRES[n8n Presentation Generator]
  PRES --> SL[Google Slides template and presentation]
  PRES -->|cache metadata| PG
```

## Repository map

- `workflows/exports/`: Sanitized, structurally valid n8n workflow JSON exports.
- `workflows/docs/`: Per-workflow node order, purpose, configuration notes, and GitHub-rendered Mermaid diagrams.
- `sql/`: PostgreSQL schema and reusable SQL.
- `prompts/`: AI system prompt and manual test prompts.
- `docker/`: Local Metabase Compose example.
- `docs/`: Setup, security, QA checklist, costs, roadmap, and architecture details.
- `.env.example`: Names only; never put real secrets in this repository.

## Quick start

1. Review [setup guide](docs/SETUP.md), [database schema](sql/schema.sql), and [security notes](docs/SECURITY.md).
2. Create the required tables in Supabase and configure n8n credentials locally.
3. Import workflow exports from `workflows/exports/` using **n8n → Workflows → Import from File**.
4. Rebind credentials and replace placeholder IDs for Google Drive, Slides, and called workflows.
5. Run the workflows manually against a disposable/test period and inspect their execution results before enabling any schedule.
6. Start Metabase with the example Compose file and connect it using a dedicated read-only PostgreSQL role.

Detailed steps and environment values are in the linked guides. This repository does not contain credentials or live data.

## KPI contract

- `total_events`: event row count.
- `total_users`: distinct `user_pseudo_id` in that reporting week.
- `purchases`: purchase event count.
- `purchase_users`: distinct users with a purchase event.
- `revenue_usd`: purchase event revenue in USD, summed from the sample export.
- `conversion_rate_pct`: `100 * purchase_users / NULLIF(total_users, 0)`.

Users are distinct within each week and must not be summed across weeks to represent period-unique users. Weekly intervals are consecutive Sunday–Saturday blocks starting November 1, 2020; the final interval is a single day (2021-01-31) and is excluded from full-week comparisons.

## Status and known gaps

See [project status](docs/STATUS.md) for the Step 22–25 verification snapshot and execution evidence. On-demand insights can target a complete week represented in the data when a consecutive prior week exists; unsupported weeks return `not_found`. The Weekly ETL remains inactive, so scheduled ingestion and automatic weekly insight generation are not running. Insights-only assistant requests do not create presentations; slides run only when explicitly requested.

## License

No license is included yet. Choose one before making this repository public.
