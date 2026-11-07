# GA4 Analytics Project: Workflow Technical Reference

## Scope and snapshot boundary

This reference describes the four credential-free JSON files under `workflows/exports/`, by exact exported workflow and node names. The export filenames and workflow names differ slightly. These snapshots are not treated as equivalent to later captured or published workflow revisions described in local notes. The exports omit credential bindings and contain placeholders for instance-specific workflow, cloud-project, and template references. No credentials or live identifiers are reproduced here.

The exported JSON establishes configured node types, parameters, and connections. It does not establish that a workflow ran successfully, that a connected account has access, that PostgreSQL permissions are read-only, or that the exported revision is the currently deployed revision.

## 1. `GA4 - AI Analytics Assistant`

**Export:** `workflows/exports/ga4-ai-analytics-assistant.json` · 8 nodes · marked active in JSON.

**Flow:** chat trigger → AI Agent. The OpenRouter model, Simple Memory, three PostgreSQL tools, and presentation workflow tool connect to the agent on their respective AI ports. The assistant workflow does not call Weekly AI Insights in this export.

| Node | Type | Role and important data flow |
|---|---|---|
| `When chat message received` | `@n8n/n8n-nodes-langchain.chatTrigger` | Public chat trigger with n8n user authentication; response mode is last node. Welcome text states the sample-data period and unavailable dimensions. |
| `OpenRouter Chat Model` | `@n8n/n8n-nodes-langchain.lmChatOpenRouter` | Supplies `google/gemini-3.1-flash-lite` to the agent; configured temperature 0.1 and 1,024 max tokens. This is configuration evidence only; provider behavior is not verified here. |
| `AI Agent` | `@n8n/n8n-nodes-langchain.agent` | Uses the embedded system message for tool choice, metric definitions, historical-data caveats, and response rules. Numerical answers are expected to use tool results. |
| `Get Latest Week KPIs` | `n8n-nodes-base.postgresTool` | No-argument `SELECT` from `public.weekly_kpis`; selects the newest six-day date span and returns dates, user count, purchase-event count, purchasing users, USD revenue, and conversion percent. |
| `Get Weekly Trends` | `n8n-nodes-base.postgresTool` | No-argument query over complete seven-day rows. Computes conversion rate and prior-week revenue with `LAG`, then revenue WoW percent; ascending chronological order, maximum 20 rows. The export does not constrain a requested period. |
| `Simple Memory` | `@n8n/n8n-nodes-langchain.memoryBufferWindow` | Adds conversational context to the agent. It is not a metric source. The export shows no explicit window parameters. |
| `Get Saved Weekly Insights` | `n8n-nodes-base.postgresTool` | No-argument `SELECT` from `public.weekly_insights`, ordered by `week_start DESC`, limit 1. Returns report Markdown, period, model, and generation timestamp. It cannot select a requested historical week in this export. |
| `Generate Weekly Presentation` | `@n8n/n8n-nodes-langchain.toolWorkflow` | Exposes a tool for explicit presentation requests. Target workflow binding is a select-after-import placeholder; it must be configured in the instance before invocation. |

**Limits:** no dimension-level SQL, no cross-week distinct-user query, no live GA4 source, and no historical date input to these tools. Prompt instructions are not a database security boundary; actual role permissions are not visible in the export.

## 2. `GA4 - Weekly AI Insights`

**Export:** `workflows/exports/ga4-weekly-ai-insights.json` · 7 nodes · marked inactive in JSON.

**Flow:** manual or called-workflow trigger → `Get Weekly Comparison` → `Check Report Needs Generation` → LLM chain → upsert. The SQL check returns a row only when there is no saved row with the same `week_start` and full `metrics_snapshot`; there is no separate IF node in this export. The workflow selects the newest consecutive complete-week pair; it is not a general historical-period generator.

| Node | Type | Role and important data flow |
|---|---|---|
| `When clicking ‘Execute workflow’` | `n8n-nodes-base.manualTrigger` | Manual entry point. |
| `When Executed by Another Workflow` | `n8n-nodes-base.executeWorkflowTrigger` | Called-workflow entry, configured with pass-through input. |
| `Get Weekly Comparison` | `n8n-nodes-base.postgres` | Reads complete seven-day rows from `public.weekly_kpis`; computes conversion rate and revenue per purchase, uses `LAG` for prior values and WoW changes, requires adjacent weeks (`prev_week_end = week_start - 1`), selects newest eligible pair. Missing previous values become null through SQL `NULLIF`/`LAG`. |
| `Check Report Needs Generation` | `n8n-nodes-base.postgres` | Compares the incoming `week_start` and serialized complete comparison JSON to `public.weekly_insights.metrics_snapshot`. Returns `should_generate` only when no identical saved snapshot exists. |
| `Generate Weekly Insights` | `@n8n/n8n-nodes-langchain.chainLlm` | Prompts for a concise English report under 300 words with Executive Summary, KPI Performance, Key Findings, and Recommended Investigations. It is instructed to use only SQL output and avoid causal claims. |
| `OpenRouter Chat Model` | `@n8n/n8n-nodes-langchain.lmChatOpenRouter` | Supplies `google/gemini-3.1-flash-lite`; temperature 0.2, max 1,000 tokens. |
| `Save Weekly Insights` | `n8n-nodes-base.postgres` | Parameterized upsert to `public.weekly_insights` keyed on `week_start`; stores dates, Markdown, JSONB metrics snapshot, model name, and `generated_at`. |

**Limits:** the query needs two adjacent complete weeks, so no comparison/report row is produced if that basis is absent. Identical snapshots are skipped; a changed snapshot for the same week overwrites the existing record. Schema constraints and permissions are not included in the export. The “revenue per purchase” calculation is descriptive, not verified AOV.

## 3. `GA4 Weekly ETL`

**Export:** `workflows/exports/ga4-weekly-etl.json` · 5 nodes · marked inactive; `Schedule Trigger` itself is disabled.

**Flow:** scheduled entry (disabled in this JSON) → read next date block from PostgreSQL → query BigQuery public GA4 sample tables → upsert weekly KPI row → invoke Weekly AI Insights and wait for completion.

| Node | Type | Role and important data flow |
|---|---|---|
| `Schedule Trigger` | `n8n-nodes-base.scheduleTrigger` | Configured for Mondays at 09:00, but `disabled: true`; no schedule execution follows from this export. Instance timezone is not specified by this node. |
| `Supabase-Get Next Week` | `n8n-nodes-base.postgres` | Finds `MAX(week_end)` in `public.weekly_kpis`; uses 2020-10-31 when empty. Returns the next date interval through at most 2021-01-31; returns no row when the endpoint is exhausted. |
| `BigQuery-Weekly KPIs` | `n8n-nodes-base.googleBigQuery` | Queries `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` for the returned date suffix range. Aggregates events, distinct users, purchase events, distinct purchasing users, and purchase revenue in USD. Project binding is a reconnect placeholder. |
| `Supabase-Upsert KPIs` | `n8n-nodes-base.postgres` | Auto-maps BigQuery output to `public.weekly_kpis`, matching on `week_start`. Depends on corresponding table columns and uniqueness constraints in the connected database. |
| `Trigger Weekly AI Insights` | `n8n-nodes-base.executeWorkflow` | Calls the selected insights workflow and waits for it. Workflow ID is a select-after-import placeholder. |

**Limits:** the query reads a public historical sample range, not a live GA4 property. Distinct users are within each date block. The final interval may be a one-day partial period. Empty-input downstream behavior depends on n8n runtime semantics and was not verified in this documentation pass.

## 4. `GA4 - Presentation Generator`

**Export:** `workflows/exports/ga4-presentation-generator.json` · 12 nodes · marked active; `Export PowerPoint` is disabled.

**Flow:** manual or called-workflow trigger → fetch latest complete-week saved insight → check for a deck linked to that report version → either return the existing URL or copy the template, replace placeholders, save the presentation record, and return a URL. The disabled PowerPoint node is not connected into the active generation path.

| Node | Type | Role and important data flow |
|---|---|---|
| `When clicking ‘Execute workflow’` | `n8n-nodes-base.manualTrigger` | Manual entry point. |
| `When Executed by Another Workflow` | `n8n-nodes-base.executeWorkflowTrigger` | Called-workflow entry, configured with pass-through input. |
| `Get Presentation Data` | `n8n-nodes-base.postgres` | Selects latest complete-week row from `public.weekly_insights`, including report Markdown, JSON metrics snapshot, model, and generation timestamp. |
| `Check Existing Presentation` | `n8n-nodes-base.postgres` | Looks up `public.weekly_presentations` by input `week_start` and matching `source_report_generated_at`; returns whether generation is needed and any existing ID. |
| `Presentation Needs Generation?` | `n8n-nodes-base.if` | Routes true to creation and false to reuse. |
| `Copy Presentation Template` | `n8n-nodes-base.googleDrive` | Copies the configured Slides template and names the copy using the reporting week. Template ID is a placeholder in the sanitized export. |
| `Prepare Presentation Fields` | `n8n-nodes-base.code` | Reads source report and copied presentation ID; validates ID and numeric metric values, parses the metrics snapshot if serialized, extracts report sections 1 and 4, formats KPI values, and creates Slides `replaceAllText` requests. It expects numbered Markdown headings and exactly two recommendation titles. |
| `Fill Presentation Placeholders` | `n8n-nodes-base.httpRequest` | Sends a Slides API `batchUpdate` request with prepared placeholder replacements, using a predefined credential reference omitted from the export. |
| `Save Presentation Record` | `n8n-nodes-base.postgres` | Parameterized upsert to `public.weekly_presentations` on `week_start`; records presentation ID and source report generation timestamp. |
| `Return Presentation Link` | `n8n-nodes-base.set` | Returns a constructed Google Slides edit URL, `status: success`, and a generated-success message. The URL is not proof of public access. |
| `Return Existing Presentation Link` | `n8n-nodes-base.set` | Constructs the edit URL from the matched existing presentation ID and marks the response as reused. |
| `Export PowerPoint` | `n8n-nodes-base.googleDrive` | Download-to-PowerPoint node, disabled in the JSON and not connected to the active path. |

**Limits:** only latest saved complete-week report is selected. The exported generation path requires the template, Drive/Slides access, database tables, and imported credentials. The returned URL inherits Google Drive sharing settings. Empty report/query behavior and template compatibility have not been runtime-verified here.

## Logging and runtime evidence

None of these four checked-in exports contains an explicit Project Log Writer node or Step 30 logging calls. Existing local workflow notes describe later captured variants with logging nodes, but those are different snapshots and their details should not be projected onto these exports. Ordinary database writes are present where listed (`weekly_kpis`, `weekly_insights`, and `weekly_presentations`); they are application data persistence, not evidence of a separate execution log.

The local 2026-11-07 chat evidence documents a 10-case reviewed chat session. It includes a cached historical insight and cached deck response, while the assistant JSON's saved-insight tool is latest-only. Separate import/evidence notes describe structural tests and other revisions; those records do not show these exports being run in this pass. No workflow execution, import, credential check, database inspection, or runtime test was performed for this reference.

## Source files

- [`ga4-ai-analytics-assistant.json`](../workflows/exports/ga4-ai-analytics-assistant.json)
- [`ga4-weekly-ai-insights.json`](../workflows/exports/ga4-weekly-ai-insights.json)
- [`ga4-weekly-etl.json`](../workflows/exports/ga4-weekly-etl.json)
- [`ga4-presentation-generator.json`](../workflows/exports/ga4-presentation-generator.json)
- [`ga4-ai-analytics-assistant.md`](../workflows/docs/ga4-ai-analytics-assistant.md), [`ga4-weekly-ai-insights.md`](../workflows/docs/ga4-weekly-ai-insights.md), [`ga4-weekly-etl.md`](../workflows/docs/ga4-weekly-etl.md), [`ga4-presentation-generator.md`](../workflows/docs/ga4-presentation-generator.md) — local notes that call out snapshot differences.
- [`ga4-assistant-chat-test-evidence-2026-11-07.md`](../output/ga4-assistant-chat-test-evidence-2026-11-07.md) — historical chat test record.
