# GA4 AI Analytics Automation

A portfolio project that turns anonymized historical GA4 sample ecommerce data into weekly analytics, dashboard views, AI-assisted analysis, and on-demand presentation drafts.

> The sample data covers 2020-11-01 through 2021-01-31. It is historical demonstration data, not live business traffic.

## Overview

The project demonstrates a small analytics workflow: aggregate weekly metrics, review them in a dashboard, and use AI-assisted summaries and presentations to explore the results. Connections and credentials must be configured by each user.

The public repository contains sanitized, inactive workflow exports. Treat them as starting points, review them before import, and configure any required placeholders locally.

## Workflow guides

| Workflow | Purpose |
|---|---|
| [GA4 Weekly ETL](workflows/docs/ga4-weekly-etl.md) | Loads the historical sample data for analysis. |
| [GA4 Weekly AI Insights](workflows/docs/ga4-weekly-ai-insights.md) | Summarizes an eligible reporting week against the preceding complete week. |
| [GA4 AI Analytics Assistant](workflows/docs/ga4-ai-analytics-assistant.md) | Provides a conversational way to explore metrics and request analysis or a presentation. |
| [GA4 Presentation Generator](workflows/docs/ga4-presentation-generator.md) | Reuses or prepares a presentation for an eligible reporting week. Its sanitized export contains 33 nodes. |
| [GA4 Project Log Writer](workflows/docs/ga4-project-log-writer.md) | Documents an optional run-summary helper used by the project workflows. |

## Quick start

1. Read the [setup guide](docs/SETUP.md) and [security notes](docs/SECURITY.md).
2. Prepare your own local services, credentials, and any required external assets.
3. Review and import the sanitized workflow exports individually in a non-production environment.
4. Configure the exported placeholders for your environment before running a workflow.

The exports are not turnkey, and this repository does not include live credentials.

## KPI definitions

- **total_events:** event row count.
- **total_users:** distinct users in a reporting week.
- **purchases:** purchase event count.
- **purchase_users:** distinct users with a purchase event.
- **revenue_usd:** purchase event revenue in USD from the sample export.
- **conversion_rate_pct:** 100 × purchase users ÷ total users, when total users is nonzero.

Weekly distinct-user counts should not be summed to estimate unique users across a longer period. Reporting weeks are Sunday–Saturday blocks beginning November 1, 2020. The final sample interval is a single day and is excluded from complete-week comparisons.

## Validation notes

The presentation export contains 33 nodes. The existing runtime cache-hit path was verified; the generated-presentation path has not been rerun on the current workflow version. A clean n8n import has not been validated, so the exports should be reviewed and configured before use.

See [project status](docs/STATUS.md) for the latest project notes.

## Repository map

- `workflows/exports/`: sanitized portable workflow JSON.
- `workflows/docs/`: workflow guides.
- `sql/`: schema example and analytics queries.
- `prompts/`: assistant prompt and manual checks.
- `docker/`: local dashboard example.
- `docs/`: setup, security, status, and project notes.
- `.env.example`: variable names with safe placeholders only.

## License

This repository has no license. Do not assume the project or its assets are licensed for reuse.
