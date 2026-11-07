# GA4 Analytics Project: Workflow Technical Reference

## Scope and snapshot boundary

This reference describes the four sanitized n8n exports captured from the verified graphs on 2026-11-07. Each export is inactive, omits workflow-level IDs and credential bindings, replaces instance-specific selections with portable placeholders, and uses regenerated node UUIDs. All node counts and names below refer to those captured graphs.

The Assistant, Weekly AI Insights, and Presentation Generator were published and active when captured. Weekly ETL is inactive and its Schedule Trigger is disabled. The graph snapshots and independent structural review do not establish successful imports, connected credentials, database permissions, or runtime behavior. No workflow was executed for this sync.

## 1. GA4 - AI Analytics Assistant

**Export:** [ga4-ai-analytics-assistant.json](../workflows/exports/ga4-ai-analytics-assistant.json) · **12 nodes**, including 3 logger calls.

The authenticated chat trigger feeds the AI Agent, connected to the OpenRouter Chat Model, Simple Memory, three read-only PostgreSQL tools, the on-demand Weekly AI Insights tool, and the Presentation Generator tool. The two workflow tools use placeholders and must be rebound after import.

The three logger nodes call the shared Project Log Writer:

- `Log Assistant Run Start`
- `Log Assistant Agent Stage`
- `Log Assistant Run Completion`

The export contains no live credentials. Database access permissions and connected services are not established by its SQL and wiring.

## 2. GA4 - Weekly AI Insights

**Export:** [ga4-weekly-ai-insights.json](../workflows/exports/ga4-weekly-ai-insights.json) · **24 nodes**, including 12 logger calls.

Manual or called-workflow triggers feed `Get Weekly Comparison`. `Weekly KPI Comparison Found?` routes missing comparisons to `Return Missing KPI`. Eligible comparisons continue through `Check Report Needs Generation` and `Needs AI Generation?`; a matching saved snapshot returns through `Return Saved Insights`, while a new or changed snapshot goes through `Generate Weekly Insights`, `OpenRouter Chat Model`, `Save Weekly Insights`, and `Return Generated Insights`.

The logger nodes call the Project Log Writer at workflow entry, comparison, decision, generation, persistence, and return stages:

- `Log Insights — Manual run started`
- `Log Insights — Subworkflow run started`
- `Log Insights — Weekly KPI comparison loaded`
- `Log Insights — KPI comparison available`
- `Log Insights — KPI comparison unavailable`
- `Log Insights — Report generation required`
- `Log Insights — Saved report reused`
- `Log Insights — Weekly report generated`
- `Log Insights — Weekly report saved`
- `Log Insights — Generated report returned`
- `Log Insights — Saved report returned`
- `Log Insights — KPI data unavailable returned`

The workflow needs an eligible complete-week comparison and a connected PostgreSQL database and model credential. The portable export does not establish those resources or permissions.

## 3. GA4 - Presentation Generator

**Export:** [ga4-presentation-generator.json](../workflows/exports/ga4-presentation-generator.json) · **41 nodes**, including 7 presentation-recovery nodes and 16 logger calls.

Manual or called-workflow triggers start the presentation path. It reads the requested reporting week, requests missing insights when needed, reloads the report, and returns `not_found` if the report remains unavailable. For an available report, the flow searches exact weekly Slides, resolves possible matches, and either returns a reusable presentation, reports ambiguity, recovers a prior candidate, or copies and fills the configured template before saving a presentation record and returning the link.

The recovery nodes are `Search Exact Weekly Slides`, `Resolve Presentation Candidate`, `Candidate Needs Copy?`, `Candidate Reusable?`, `Return Ambiguous Presentation`, `Presentation Recovered?`, and `Return Tool Result - recovered`.

The 16 logger nodes call the shared Project Log Writer:

- `Log Presentation — Manual run started`
- `Log Presentation — Subworkflow run started`
- `Log Presentation — Source report loaded`
- `Log Presentation — Report available`
- `Log Presentation — Report unavailable`
- `Log Presentation — Insights generated`
- `Log Presentation — Reloaded report available`
- `Log Presentation — Reloaded report unavailable`
- `Log Presentation — Existing presentation not found`
- `Log Presentation — Existing presentation found`
- `Log Presentation — Presentation content prepared`
- `Log Presentation — Presentation record saved`
- `Log Presentation — Presentation result returned`
- `Log Presentation — Existing presentation returned`
- `Log Presentation — Report not found returned`
- `Log Presentation — Duplicate presentations detected`

The export replaces the Weekly AI Insights and Project Log Writer references, Google Drive template ID, credentials, and other instance-specific configuration with placeholders. A new presentation depends on compatible Slides assets, Google permissions, and database tables; those were not revalidated here.

## 4. GA4 Weekly ETL

**Export:** [ga4-weekly-etl.json](../workflows/exports/ga4-weekly-etl.json) · **10 nodes**, including 5 logger calls. The workflow is inactive and its Schedule Trigger is disabled.

The main path is `Schedule Trigger` → `Supabase-Get Next Week` → `BigQuery-Weekly KPIs` → `Supabase-Upsert KPIs` → `Trigger Weekly AI Insights`. It requests the next bounded historical date window, aggregates the public GA4 sample, saves weekly KPIs, and then invokes Weekly AI Insights.

Its logger nodes are:

- `Log ETL — Workflow run started`
- `Log ETL — Next weekly window loaded`
- `Log ETL — Weekly KPIs aggregated`
- `Log ETL — Weekly KPIs saved`
- `Log ETL — Insights workflow handoff completed`

The data range is historical sample data ending on 2021-01-31. All available source data is already loaded, so the schedule must remain disabled.

## Shared logging and operation

All 36 logger calls send stage summaries to the shared Project Log Writer. That helper and its workbook binding are not included in the repository. Configure your own helper and credentials after importing; unresolved logger references can omit log rows but do not stop the parent workflow.

See each [workflow document](../workflows/docs/) for the detailed node notes and diagrams, and [project status](../docs/STATUS.md) for evidence limits.
