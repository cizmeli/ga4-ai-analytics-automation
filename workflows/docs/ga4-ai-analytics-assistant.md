# GA4 AI Analytics Assistant

**Observed state:** published and active in n8n. Chat Trigger requires n8n user authentication. The model is OpenRouter `google/gemini-3.1-flash-lite`, temperature 0.1, max tokens 1024. Simple Memory is connected. Export has no credential references.

## Node order and purpose

1. **When chat message received** — authenticated chat UI and welcome text.
2. **OpenRouter Chat Model** — language model provider.
3. **AI Agent** — system rules instruct grounded answers, period/grain context, tool use, and explicit presentation requests only.
4. **Get Latest Week KPIs** — read-only query for latest complete-week KPIs and conversion rate.
5. **Get Weekly Trends** — up to 20 complete weeks with SQL-computed CVR and revenue WoW changes; excludes partial periods.
6. **Simple Memory** — conversational context buffer.
7. **Get Saved Weekly Insights** — reads the latest saved row from `weekly_insights`.
8. **Generate Weekly Presentation** — tool-workflow call to the presentation generator.

SQL and exact system message: [assistant system prompt](../../prompts/ai-assistant-system-prompt.md). Test prompts: [manual checks](../../prompts/assistant-test-prompts.md). Export: [ga4-ai-analytics-assistant.json](../exports/ga4-ai-analytics-assistant.json).
