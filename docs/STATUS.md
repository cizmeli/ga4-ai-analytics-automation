# Project status

Snapshot: 2026-10-25 (Europe/Berlin). This status reflects the local n8n UI, visible Metabase tab, and the provided project plan; it is not a production audit.

## Verified from the open n8n instance

- `GA4 Weekly ETL` exists and has five nodes: Supabase next-week query → schedule trigger → BigQuery weekly aggregation → Supabase upsert → trigger Weekly AI Insights.
- The ETL workflow is inactive, and its schedule trigger visibly reads **Deactivated**.
- `GA4 - AI Analytics Assistant` is published/active and contains an authenticated chat trigger, OpenRouter Chat Model (`google/gemini-3.1-flash-lite`), AI Agent, Simple Memory, three PostgreSQL read tools, and a presentation workflow tool.
- The assistant's latest-week and trend queries use `weekly_kpis`; saved insights reads `weekly_insights`.
- `GA4 - Presentation Generator` is published/active, with manual and called-workflow triggers, PostgreSQL data/cache steps, Google Drive template copy, placeholder preparation, Slides HTTP update, optional PowerPoint download node (deactivated), and returned link.
- Browser tabs show the local Metabase dashboard and the assistant chat endpoint.
- Credential-free exports exist for ETL, AI Assistant, and Presentation Generator.

## Known but not verified in this pass

- The project plan says BigQuery weekly aggregation returned one row, Supabase table and Postgres connection were created, and initial weekly metrics were checked. These statements are carried forward from user-confirmed project notes, not newly re-run.
- Dashboard data accuracy, SQL question definitions, refresh behavior, and visual QA have not been audited.
- `GA4 - Weekly AI Insights` appears in the n8n workflow list and is invoked by ETL, but this export/config has not yet been included here.
- Metabase is planned on port 3001, but Docker lifecycle and datasource permissions were not inspected.
- Supabase table definitions for `weekly_insights` and `weekly_presentations` must be confirmed against the actual database before applying the example schema.

## Not implemented or not established

- Do not describe on-demand generation of arbitrary historical weekly reports as implemented. The supplied conversation contains report-status rows and a discussion questioning pre-generating every week; further exact workflow behavior must be checked.
- Device breakdown is not in the current assistant tool set.
- ETL schedule is not running.
- No real API keys, database passwords, OAuth tokens, presentation IDs, or workflow credential IDs are committed here.
