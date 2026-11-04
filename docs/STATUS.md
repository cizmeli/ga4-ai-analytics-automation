# Project status

Snapshot: 2026-11-04 (Europe/Berlin). This status reflects the open n8n instance and its existing execution history; it is not a production audit. No new workflow runs were launched for this documentation update.

## Verified from the open n8n instance

- `GA4 Weekly ETL` exists and has five nodes: Supabase next-week query → schedule trigger → BigQuery weekly aggregation → Supabase upsert → trigger Weekly AI Insights.
- The ETL workflow is inactive, and its schedule trigger visibly reads **Deactivated**.
- `GA4 - AI Analytics Assistant` is published/active and contains an authenticated chat trigger, OpenRouter Chat Model (`google/gemini-3.1-flash-lite`), AI Agent, Simple Memory, three PostgreSQL read tools, an on-demand insights tool, and a presentation workflow tool. Insights-only requests do not call the presentation tool; slides are called only for explicit requests.
- The assistant's latest-week and trend queries use `weekly_kpis`; saved insights reads `weekly_insights`.
- `GA4 - Presentation Generator` is published/active, with manual and called-workflow triggers, PostgreSQL data/cache steps, Google Drive template copy, placeholder preparation, Slides HTTP update, optional PowerPoint download node (deactivated), and returned link.
- Browser tabs show the local Metabase dashboard and the assistant chat endpoint.
- Credential-free exports exist for ETL, AI Assistant, Presentation Generator, and Weekly AI Insights.
- `GA4 - Weekly AI Insights` is published/active with manual and called-workflow triggers. It supports a selected complete week, requires the consecutive prior week, and skips the insights LLM and save node when the selected `week_start` and JSONB `metrics_snapshot` match. The comparison output carries `prompt_version=weekly-insights-v1`; `requested_week` is excluded from snapshot equality.

## Known but not verified in this pass

- The project plan says BigQuery weekly aggregation returned one row, Supabase table and Postgres connection were created, and initial weekly metrics were checked. These statements are carried forward from user-confirmed project notes, not newly re-run.
- Dashboard data accuracy, SQL question definitions, refresh behavior, and visual QA have not been audited.
- The Weekly AI Insights export was structurally parsed locally but has not been re-imported into a separate n8n instance. Its referenced Postgres and OpenRouter credentials are intentionally omitted.
- Metabase is planned on port 3001, but Docker lifecycle and datasource permissions were not inspected.
- Supabase table definitions for `weekly_insights` and `weekly_presentations` must be confirmed against the actual database before applying the example schema.

## Not implemented or not established

- On-demand insight requests can target a complete week when an eligible consecutive comparison exists. Requests without an eligible comparison return `not_found`; this is bounded by the available historical dataset.
- Device breakdown is not in the current assistant tool set.
- ETL schedule is not running.
- No real API keys, database passwords, OAuth tokens, presentation IDs, or workflow credential IDs are committed here.

## Existing execution evidence reviewed on 2026-11-04

These IDs are existing executions reviewed for Step 26, not new runs from this documentation update.

| Execution(s) | Verified result |
|---|---|
| `1103`, `1104` | Week `2020-10-25` returned `not_found` for a KPI comparison and a saved insight; no LLM, Slides, Drive, or save node ran. |
| `1105` → `1106` | An insights-only assistant request called Weekly Insights, whose child returned `status=cached` for `2020-11-29`. No insights-generation LLM/save node or presentation subexecution ran; the assistant's own model/routing still ran. |
| `1108`, `1111` | `1108` created/saved a deck; `1111` reused it without template copy, placeholder fill, or presentation-record save. |
| `1112` | `requested_week=not-a-date` failed at Get Weekly Comparison: `invalid input syntax for type date: "not-a-date"`; no downstream nodes ran. |
| `1113`, `1114` | Missing copied presentation ID failed before Slides/Save with `Copied presentation ID is missing`; a fake ID returned provider 404 `The resource you are requesting could not be found` before Save. These were pinned fault-injection runs; no Drive copy occurred. |
| `1115` → `1116` | `1115` generated/saved the `2020-11-22` insight. `1116` returned it as cached with `prompt_version=weekly-insights-v1` and `generated_at=2026-11-04T20:44:33.798Z`. |

Read-only execution inspection commands (these do not trigger workflows):

```sh
/opt/homebrew/bin/n8n-cli workflow list --name=GA4 --format=table --limit=10
/opt/homebrew/bin/n8n-cli execution list --workflow=<workflow-id> --limit=10 --format=table
/opt/homebrew/bin/n8n-cli execution get <execution-id> --format=table
```
