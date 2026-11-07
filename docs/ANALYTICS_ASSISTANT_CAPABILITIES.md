# GA4 Analytics Assistant: Capabilities and Limits

## What it is

The GA4 Analytics Assistant is an n8n chat workflow that answers questions from weekly aggregates in PostgreSQL, retrieves a saved weekly insight report, and can return or request a Google Slides presentation. The configured data is an anonymized historical GA4 e-commerce sample covering November 2020 through January 2021; it is not live traffic or current business performance. Reporting weeks are Sunday through Saturday, and the January 31, 2021 record is partial.

The credential-free 12-node export, `GA4 - AI Analytics Assistant`, connects an authenticated chat trigger, an AI Agent, a Gemini model through OpenRouter, a short-window memory node, three PostgreSQL query tools, an on-demand Weekly AI Insights tool, a presentation-workflow tool, and three named logger nodes. The SQL tools in this export accept no user parameters.

## Questions it can answer from the exported tools

- **Latest complete week:** total users, purchase events, purchase users, USD revenue, and purchase conversion rate. The query selects the latest row whose `week_end - week_start` is six days.
- **Weekly trends and rankings:** up to 20 complete weeks of those KPIs, plus SQL-computed conversion rate and revenue week-over-week change. This supports comparisons, revenue trend questions, and highest/lowest week rankings within returned rows.
- **Interpretation of supplied metrics:** arithmetic comparisons and bounded observations, with reporting dates, units, and caveats. The prompt asks the model to distinguish observed changes from hypotheses and avoid unsupported causal explanations.
- **Latest saved weekly insights:** the export retrieves the saved report for the latest reporting week, including its dates, report text, model name, and generation time. This is retrieval, not a fresh analysis.
- **Explicit presentation requests:** the agent can invoke the Presentation Generator tool for the latest saved complete-week report. The exported presentation workflow checks for a matching saved deck and returns its link or creates one from a template. Drive access still controls who can open it.

The embedded system prompt asks for English by default; the export's chat welcome message identifies the historical sample and says device, product, and traffic-source analyses are unavailable.

## What it cannot reliably answer from these exports

- **Live/current GA4 performance:** all cited source data is historical sample data.
- **Cross-week unique users:** `total_users` is distinct within each week. Summing it across weeks does not yield period-wide unique users, and the tools do not query user-level identifiers across a period.
- **Device, product, traffic-source, or other dimension breakdowns:** no such dimensions are returned by the assistant's exported SQL tools.
- **Arbitrary date ranges or unreturned periods:** both KPI tools have fixed behavior and no inputs. Weekly trends return at most 20 rows. Do not claim coverage outside their results.
- **Arbitrary historical saved insight reports:** `Get Saved Weekly Insights` selects only the latest report by `week_start`; it does not accept a requested week.
- **Unsupported presentation periods:** the Presentation Generator accepts a requested complete reporting week, or uses the latest complete week when none is supplied; partial or unsupported periods cannot be treated as complete-week reports.
- **Fresh report generation:** `Generate On-Demand Weekly Insights` can request a report for an eligible complete week. It uses the separate Weekly AI Insights workflow, whose workflow reference must be rebound after import.
- **Causality or explanations involving promotions, pricing, product mix, customer behavior, or external events:** these are not present in the supplied aggregate query results.
- **A validated average order value:** revenue divided by purchase events is provided by the insights workflow as “revenue per purchase”; its own prompt says this is descriptive and not necessarily validated AOV.
- **Monthly totals from weekly summaries without a defined selection rule:** weekly periods can cross calendar months and the assistant has no monthly aggregation tool.

## Snapshot and evidence caveat

The statements above describe the sanitized exports of the verified n8n graph snapshots captured on 2026-11-07. The local chat-test evidence dated 2026-11-07 records 10 of 10 reviewed cases, including a historical saved-insight retrieval and a cached presentation response. The test record does not establish every tool branch or workflow-generation path, so treat it as evidence of the tested chat session only.

The export replaces its insights and presentation workflow bindings with select-after-import placeholders and omits credential bindings. The JSON shows query intent and node wiring, not database role privileges, connected credentials, provider availability, Drive sharing, or successful runtime execution.

## Source evidence

- [`ga4-ai-analytics-assistant.json`](../workflows/exports/ga4-ai-analytics-assistant.json) — exported assistant nodes, tool descriptions, SQL, model settings, and workflow binding placeholder.
- [`ga4-assistant-chat-test-evidence-2026-11-07.md`](../output/ga4-assistant-chat-test-evidence-2026-11-07.md) — separate observed chat-test session and review.
- [`ga4-ai-analytics-assistant.md`](../workflows/docs/ga4-ai-analytics-assistant.md) — workflow documentation for the current captured graph.
- [`ai-assistant-system-prompt.md`](../prompts/ai-assistant-system-prompt.md) — saved copy of the prompt and metric rules.
