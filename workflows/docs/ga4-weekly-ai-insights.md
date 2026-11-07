# GA4 Weekly AI Insights

## Purpose and published state

This workflow compares a selected complete Sunday-to-Saturday week in public.weekly_kpis with its immediately preceding complete week, asks an OpenRouter model for a bounded executive analysis, and upserts the report into public.weekly_insights. The published 24-node version is active. The inactive ETL is not its automatic schedule path; the Assistant's on-demand insights tool is the active request path.

The workflow accepts a requested_week; if omitted, it uses the latest eligible complete-week pair. The selected week needs a consecutive complete predecessor. If no valid pair exists, the workflow returns not_found.

The sanitized published export is [ga4-weekly-ai-insights.json](../exports/ga4-weekly-ai-insights.json). It omits credential bindings and live identifiers, and has active=false for safe import.

## Trigger and processing

1. **When clicking ‘Execute workflow’** — controlled manual execution.
2. **When Executed by Another Workflow** — called by the Assistant's on-demand insights tool.
3. **Get Weekly Comparison** — selects the requested complete week or the latest eligible pair. It excludes partial periods, requires the prior week to end the day before the selected week begins, and computes user, purchase, revenue, revenue-per-purchase, and conversion-rate changes.
4. **Weekly KPI Comparison Found?** — routes a missing eligible pair to **Return Missing KPI** with not_found, before cache, LLM, or save.
5. **Check Report Needs Generation** — checks the selected week_start and JSONB metrics_snapshot; requested_week is not part of snapshot equality.
6. **Needs AI Generation?** — sends a matching snapshot to **Return Saved Insights**; a new or changed snapshot continues to generation.
7. **Generate Weekly Insights** — requests an English, evidence-bounded report under 300 words with Executive Summary, KPI Performance, Key Findings, and Recommended Investigations.
8. **OpenRouter Chat Model** — google/gemini-3.1-flash-lite, temperature 0.2, max output 1000 tokens.
9. **Save Weekly Insights** — parameterized Postgres upsert keyed by week_start.
10. **Return Generated Insights** — returns a newly generated and saved report.
11. **Return Saved Insights** — returns a matching saved report with status=cached, without running the insights-generation LLM or save node.
12. **Return Missing KPI** — returns not_found when the selected week has no eligible consecutive comparison.

The published v6 comparison output includes both purchase_users and prev_purchase_users, along with current and comparison week boundaries. The Generate Weekly Insights prompt is also versioned as v6. The sanitized export is the portable representation of this published 24-node workflow.

## Step 30 logging nodes

The published graph has 12 logging calls to the shared Project Log Writer: two trigger/start nodes; comparison fetch; both comparison-availability branches; both report-generation decision branches; model generation; persistence; and three return branches. They log stage summaries and do not replace report persistence.

## 2026-11-05 evaluation and published v6

The no-write evaluation returned 8/8 hard-gate passes on 2026-11-05 using pinned test data; logging returned no_write/test_only and the retest did not persist workflow output. The evaluated query and v6 prompt were subsequently published in the 24-node active workflow. This records evaluation evidence for the logic, not a new execution of the published workflow. The standalone SQL reference at [ga4-weekly-insights-v6-reference.sql](../../sql/ga4-weekly-insights-v6-reference.sql) matches the query embedded in the export after comments and whitespace normalization; the JSON export remains the portable runtime artifact and source of truth. Runtime was not re-tested during this documentation update.

## Limitations and safe operation

- A report requires an eligible complete week and its immediately preceding complete week. A partial or unsupported week returns not_found.
- A malformed requested_week currently fails at the date comparison with a database parsing error; it does not reach the LLM or save node.
- The query uses aggregated weekly KPIs, not raw GA4 events, and does not establish business causality. Revenue per purchase is descriptive and is not asserted to be a validated average order value.
- The sanitized export has no credentials. Rebind least-privilege PostgreSQL and OpenRouter credentials after import.
- Database constraints, permissions, and model output were not revalidated as part of this GitHub sync.

## Workflow diagram

~~~mermaid
flowchart LR
  M[Manual Trigger] --> Q[Get Weekly Comparison]
  C[Assistant Called Workflow] --> Q
  Q -.-> L3[Step 30 Log Insights 03 primary KPI comparison fetch]
  Q --> F{Eligible comparison?}
  F -->|no| MK[Return Missing KPI]
  F -.-> L4[Step 30 Log Insights 04 weekly comparison availability gate]
  F -.-> L5[Step 30 Log Insights 05 weekly comparison availability gate]
  F -->|yes| K[Check Report Needs Generation]
  K -.-> L6[Step 30 Log Insights 06 report freshness/generation gate]
  K --> B{Needs AI Generation?}
  B -->|yes| G[Generate Weekly Insights]
  G -.-> L8[Step 30 Log Insights 08 AI model generation]
  G --> S[Save Weekly Insights]
  S -.-> L9[Step 30 Log Insights 09 insights persistence]
  S --> R1[Return Generated Insights]
  B -->|no| R2[Return Saved Insights]
  R1 -.-> L10[Step 30 Log Insights 10 final return]
  R2 -.-> L11[Step 30 Log Insights 11 final return]
  MK -.-> L12[Step 30 Log Insights 12 final return]
  M -.-> L1[Step 30 Log Insights 01 trigger/start]
  C -.-> L2[Step 30 Log Insights 02 trigger/start]
  L1 --> LOG[GA4 Project Log Writer]
  L2 --> LOG
  L3 --> LOG
  L4 --> LOG
  L5 --> LOG
  L6 --> LOG
  L8 --> LOG
  L9 --> LOG
  L10 --> LOG
  L11 --> LOG
  L12 --> LOG
  O[OpenRouter Chat Model] -.-> G
~~~

Current published workflow export: [ga4-weekly-ai-insights.json](../exports/ga4-weekly-ai-insights.json).