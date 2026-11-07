# Costs and roadmap

## Cost model

- BigQuery public sample data is publicly readable; queries still consume project quota and can incur scan charges depending on billing setup. Always filter _TABLE_SUFFIX.
- Supabase, Metabase OSS, local Docker, and n8n deployment costs depend on account tier, hosting, availability, storage, and current vendor terms. Recheck pricing before use.
- OpenRouter inference cost depends on model pricing, token usage, prompt size, and routing. No cost estimate is asserted because live pricing and usage are not captured here.
- Google Slides API quota and Drive storage apply to presentation creation and updates.
- The Project Log Writer makes Google Sheets API writes for run, stage, and aggregate KPI records; this document does not estimate quota or cost.
- Local scheduling stops when the host or Docker is stopped. The historical sample is fully loaded and the ETL schedule remains disabled.

## Roadmap

1. Confirm weekly_kpis, weekly_insights, and weekly_presentations constraints, column types, and least-privilege grants against the live database.
2. Audit Metabase datasource, questions, dashboard filters, chart calculations, and data range.
3. If the project adds a new data period, test ETL date boundaries, empty-week behavior, validation, and idempotency in a disposable setup.
4. Keep the selected-complete-week on-demand insights path and the inactive ETL schedule documented separately.
5. Retain the 2026-11-05 no-write evaluation evidence for the v6 purchase-user comparison; the evaluated query was subsequently published in the active workflow.
6. Add device KPIs only after defining and validating their grain and schema.
7. Confirm redistribution rights before adding a license, screenshots, or other assets.