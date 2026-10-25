# Costs and roadmap

## Cost model

- BigQuery public sample data is publicly readable; queries still consume project quota and can incur scan charges depending on billing setup. Always filter `_TABLE_SUFFIX`.
- Supabase, Metabase OSS, local Docker, and n8n deployment costs depend on account tier, hosting, availability, storage, and current vendor terms. Recheck pricing before use.
- OpenRouter inference cost depends on model pricing, token usage, prompt size, and routing. No cost estimate is asserted because live pricing and usage are not captured here.
- Google Slides API quota and Drive storage apply to presentation creation and update operations.
- Local scheduling stops when the host or Docker is stopped.

## Roadmap

1. Export and document `GA4 - Weekly AI Insights`, then verify table schema and node SQL.
2. Audit Metabase datasource, questions, dashboard filters, chart calculations, and data range.
3. Test ETL date boundary, empty-week behavior, data checks, and idempotent upsert in a disposable setup.
4. Decide whether weekly insights are schedule-driven, ETL-triggered, or user-requested. Document the actual behavior clearly; preserve historical on-demand generation as a proposal until implemented and tested.
5. Add a dedicated read-only role and audit direct PostgreSQL grants/RLS.
6. Add device KPIs only after creating and validating their grain and schema.
7. Add a license and screenshots/diagram assets after confirming redistribution rights.
