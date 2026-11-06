# GA4 AI Analytics Assistant

**Observed state:** published and active on 2026-11-06. The published version has 12 nodes. Chat Trigger requires n8n user authentication. The model is OpenRouter google/gemini-3.1-flash-lite; Simple Memory is connected.

## Node order and purpose

1. **When chat message received** — authenticated chat UI and welcome text.
2. **OpenRouter Chat Model** — language model provider.
3. **AI Agent** — selects tools based on user intent and grounds answers in results.
4. **Get Latest Week KPIs** — read-only latest complete-week metrics.
5. **Get Weekly Trends** — read-only complete-week trend data.
6. **Simple Memory** — conversational context.
7. **Get Saved Weekly Insights** — reads saved reports from weekly_insights.
8. **Generate On-Demand Weekly Insights** — requests an insight for an eligible complete week.
9. **Generate Weekly Presentation** — calls the presentation generator only for an explicit slide request.
10. **Step 30 Log Assistant 01 chat trigger/start** — logs the sanitized start event.
11. **Step 30 Log Assistant 02 agent/tool summary** — logs the sanitized tool-stage summary.
12. **Step 30 Log Assistant 03 final response** — logs the sanitized completion stage.

An insights-only request does not call the presentation tool. A cache hit skips the insights-generation LLM and save node. A combined report-and-slides request returns report text and the deck link for the same week. If a requested insight is missing, the Presentation workflow requests that week from Weekly Insights, reloads it, and creates or reuses the deck, or returns not_found.

The published prompt is [ai-assistant-system-prompt.md](../../prompts/ai-assistant-system-prompt.md). Manual checks are [assistant-test-prompts.md](../../prompts/assistant-test-prompts.md). The sanitized export is [ga4-ai-analytics-assistant.json](../exports/ga4-ai-analytics-assistant.json).

## Logging

The three Step 30 nodes call the shared [GA4 Project Log Writer](ga4-project-log-writer.md). They write allowlisted run/stage summaries to Google Sheets. No raw prompt or full node input/output is intended for the log.

## Workflow diagram

~~~mermaid
flowchart LR
  C[Authenticated Chat Trigger] --> A[AI Agent]
  M[OpenRouter Chat Model] -. language model .-> A
  S[Simple Memory] -. context .-> A
  A -. read-only tool .-> K[Get Latest Week KPIs]
  A -. read-only tool .-> T[Get Weekly Trends]
  A -. read-only tool .-> I[Get Saved Weekly Insights]
  A -. eligible-week request .-> W[Generate On-Demand Weekly Insights]
  W --> PG[(weekly_insights)]
  A -. explicit slides only .-> P[Generate Weekly Presentation]
  C -.-> L1[Step 30 Log 01]
  A -.-> L2[Step 30 Log 02]
  P -.-> L3[Step 30 Log 03]
  L1 --> LOG[GA4 Project Log Writer]
  L2 --> LOG
  L3 --> LOG
~~~

## Failure handling

- If an insights tool reports not_found, explain that no eligible complete-week comparison exists; do not invent a report.
- If a tool fails, acknowledge the failure. Existing invalid-input and presentation fault-injection behavior is summarized in [project status](../../docs/STATUS.md).
- Use only presentation links returned by the presentation workflow; Google Drive sharing permissions still apply.