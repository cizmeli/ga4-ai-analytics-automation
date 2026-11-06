# GA4 AI Analytics Automation

A portfolio project that turns public GA4 sample ecommerce events into weekly PostgreSQL metrics, a Metabase dashboard, grounded AI analysis, saved weekly insights, and on-demand Google Slides presentations.

> Data note: this project uses anonymized historical sample data from 2020-11-01 through 2021-01-31. It is not live GA4 traffic.

## Current implementation

The n8n instance contains four main GA4 workflows and one shared logging helper. Active workflows are represented by their published versions. All included portable workflow exports have active=false. The ETL export is the current inactive configuration because it has no published active version.

| Workflow | Observed state | Purpose |
|---|---|---|
| [GA4 Weekly ETL](workflows/docs/ga4-weekly-etl.md) | Inactive; current 10-node configuration; schedule trigger deactivated | Loads the bounded historical sample period. All available historical data is loaded, so no schedule is needed. The current configuration was not runtime-tested for this sync. |
| [GA4 - Weekly AI Insights](workflows/docs/ga4-weekly-ai-insights.md) | Published and active; 24 nodes | Generates or reuses an insight for an eligible complete week by comparing it with the immediately preceding complete week. |
| [GA4 - AI Analytics Assistant](workflows/docs/ga4-ai-analytics-assistant.md) | Published and active; 12 nodes | Authenticated chat with read-only KPI tools, on-demand insights, and a presentation tool. Slides run only for explicit requests. |
| [GA4 - Presentation Generator](workflows/docs/ga4-presentation-generator.md) | Published and active; 32 nodes; PowerPoint export deactivated | Loads the requested week's insight, requests it from Weekly Insights when missing, then reuses or creates a deck. Returns not_found when no eligible insight can be produced. |
| [GA4 Project Log Writer](workflows/docs/ga4-project-log-writer.md) | Active shared helper; 7 nodes | Sanitizes and upserts run, stage, and aggregate KPI summaries to a configured Google Sheets log. Its portable export is intentionally not included in this public repository. |

The local Metabase dashboard is available at http://localhost:3001. Its questions, SQL, filters, and datasource permissions have not been independently audited.

## Architecture

~~~mermaid
flowchart LR
  BQ[BigQuery public GA4 sample] --> ETL[n8n Weekly ETL]
  ETL -->|UPSERT| PG[(Supabase PostgreSQL)]
  ETL -. inactive invocation .-> INS[n8n Weekly AI Insights]
  CHAT[n8n AI Assistant] -->|eligible-week insight request| INS
  INS -->|save new report| PG
  PG --> MB[Metabase dashboard]
  CHAT -->|read-only tools| PG
  CHAT --> OR[OpenRouter · Gemini 3.1 Flash Lite]
  CHAT -->|explicit slide request| PRES[n8n Presentation Generator]
  PRES -. missing insight: request same week .-> INS
  PRES --> SL[Google Slides template and presentation]
  PRES -->|cache metadata| PG
  ETL -. Step 30 stage logs .-> LOG[GA4 Project Log Writer]
  INS -. Step 30 stage logs .-> LOG
  CHAT -. Step 30 stage logs .-> LOG
  PRES -. Step 30 stage logs .-> LOG
  LOG --> SHEETS[(Configured Google Sheets log)]
~~~

## Repository map

- workflows/exports/: Sanitized portable workflow JSON exports.
- workflows/docs/: Node purpose, behavior, logging, and Mermaid diagrams.
- sql/: Database schema, reusable analytics SQL, and a separate unpublished Step 32 Weekly Insights query draft.
- prompts/: Published assistant system prompt and manual assistant checks.
- docker/: Local Metabase Compose example.
- docs/: Setup, security, verified status, costs, and project handoff.
- .env.example: Variable names and safe placeholders only.

## Quick start

1. Review the [setup guide](docs/SETUP.md), [database schema](sql/schema.sql), and [security notes](docs/SECURITY.md).
2. Create the required Supabase tables and configure n8n credentials locally.
3. Import sanitized exports from workflows/exports/ one at a time. Rebind credentials and external asset references.
4. Use the inactive ETL only in a disposable copy if you need to verify or extend the historical load. Keep its schedule disabled.
5. Start Metabase with the example Compose file and connect a dedicated read-only PostgreSQL role.

These exports are portable starting points, not turnkey credentials. This repository contains no live credentials or execution payloads.

## KPI contract

- total_events: event row count.
- total_users: distinct user_pseudo_id in that reporting week.
- purchases: purchase event count.
- purchase_users: distinct users with a purchase event.
- revenue_usd: purchase event revenue in USD, summed from the sample export.
- conversion_rate_pct: 100 * purchase_users / NULLIF(total_users, 0).

Weekly distinct users must not be summed across weeks to represent period-unique users. Reporting weeks are Sunday–Saturday blocks starting November 1, 2020; the final interval is a single day (2021-01-31) and is excluded from full-week comparisons.

## Status and known gaps

See [project status](docs/STATUS.md) for the 2026-11-06 verification snapshot. On-demand insights can target a complete week represented in the data when its consecutive prior week exists; unsupported weeks return not_found. The Weekly ETL remains inactive, and all available historical data is already loaded.

The Step 32 Weekly Insights v6 query is an unpublished draft. It adds current and prior purchase-user counts, passed 8/8 no-write output hard gates on 2026-11-05, and is kept outside the published workflow export. See [draft SQL](sql/ga4-weekly-insights-v6-draft.sql).

## License

This repository has no license. Do not assume the project or its assets are licensed for reuse.