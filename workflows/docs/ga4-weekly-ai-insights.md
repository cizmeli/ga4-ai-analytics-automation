# GA4 Weekly AI Insights

## Purpose and current state

This workflow compares the latest complete Sunday-to-Saturday week in `public.weekly_kpis` with its immediately preceding complete week, asks an OpenRouter model for a concise, evidence-bounded executive analysis, and upserts the result into `public.weekly_insights`. The workflow was observed as **inactive** in n8n on 2026-10-25. The Weekly ETL contains a node that invokes it, but that ETL is also inactive.

The credential-free export is [`../exports/ga4-weekly-ai-insights.json`](../exports/ga4-weekly-ai-insights.json). It removes instance-specific workflow/node IDs and credential bindings. Reconnect credentials after import. Its JSON structure was parsed locally; it has not been imported into a separate n8n instance.

## Trigger and node order

There are two entry points, both connected to the same query path:

1. **When clicking ‘Execute workflow’** — manual test/execute trigger.
2. **When Executed by Another Workflow** — called-workflow trigger; the ETL is configured to invoke this workflow after its weekly KPI write.
3. **Get Weekly Comparison** — selects complete seven-day rows (`week_end - week_start = 6`), calculates conversion rate and revenue per purchase, uses `LAG` for the prior record, requires the prior week to end the day before the current week starts, and returns the latest valid pair. It computes WoW percentage changes for users, purchases, revenue, and revenue per purchase, plus conversion-rate change in percentage points. If no consecutive pair exists, no report can be generated.
4. **Check Report Needs Generation** — checks whether `weekly_insights` already contains this `week_start` with an identical JSONB `metrics_snapshot`. It returns a row only if the snapshot is new or absent. The subsequent LLM node therefore receives no input for an unchanged snapshot. This is snapshot-based deduplication, not arbitrary historical report generation.
5. **Generate Weekly Insights** — LLM chain asks for an English report under 300 words with Executive Summary, KPI Performance, Key Findings, and Recommended Investigations. It is constrained to the SQL result, historical/anonymized-data context, and no unsupported causal claims.
6. **OpenRouter Chat Model** — attached to the LLM chain; observed model `google/gemini-3.1-flash-lite`, temperature `0.2`, max output `1000` tokens. Pricing and provider behavior can change; see [costs and roadmap](../../docs/COSTS_AND_ROADMAP.md).
7. **Save Weekly Insights** — parameterized Postgres upsert keyed by `week_start`; stores report markdown, the complete metrics snapshot, model name, and current generation timestamp. Existing row for the week is updated if the snapshot has changed.

## Query and persistence details

The exact SQL and parameter expressions are preserved in the export. The comparison query uses only `weekly_kpis`; it does not query raw GA4 events or establish business causality. `revenue_per_purchase_usd` is descriptive and is not asserted to be a validated average order value.

The cache check is equivalent to:

```sql
SELECT TRUE AS should_generate
WHERE NOT EXISTS (
    SELECT 1
    FROM public.weekly_insights
    WHERE week_start = $1::date
      AND metrics_snapshot = $2::jsonb
);
```

`should_generate` is not explicitly branched on; zero returned rows stop downstream execution. Save uses `INSERT ... ON CONFLICT (week_start) DO UPDATE` with parameter replacements. Confirm the actual table constraints and permissions before applying any schema example.

## Limitations and safe operation

- The comparison is always the latest consecutive complete-week pair. The called-workflow input is passed through to the shared query path, but the SQL itself selects the latest pair rather than an input-selected historical week.
- This does not implement user-requested arbitrary historical-week generation.
- The workflow's inactive state means no automatic insight generation currently occurs through this workflow.
- The sanitized export has no credentials. Select the appropriate least-privilege PostgreSQL credential and OpenRouter credential after import; never commit credential exports or tokens.
- Validate SQL, schema, connection permissions, and model output in a disposable environment before activation.
