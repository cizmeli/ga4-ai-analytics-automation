# Project status

Snapshot assembled 2026-11-07 (Europe/Berlin) from the checked-in exports, captured workflow backups, isolated import record, local dashboard note, and assistant test evidence. This is not a production audit.

## Verified evidence

- The checked-in exports cover Weekly ETL, Weekly AI Insights, AI Analytics Assistant, and Presentation Generator. They are credential-free, but some are older or structurally different from later captured workflow snapshots.
- The 2026-11-06 isolated n8n import test successfully imported four sanitized workflow files in n8n 2.29.9. All imported workflows were inactive; none were executed. It verifies structure only.
- The assistant's clean second-round chat evidence records 10 of 10 test cases passing on 2026-11-07, including KPI retrieval, trend reporting, correct refusal to sum weekly distinct users, device-data limitation, saved insights retrieval, and cached presentation reuse.
- Live spreadsheet metadata and header reads confirm five tabs: `Runs`, `Stage Log`, `KPI Values`, `Evaluations`, and `Changes & Backups`. Their exact header lists are in [the log schema inventory](GA4_PROJECT_LOG_SCHEMA.md). The helper export and workbook binding are not part of the repository.
- A local Metabase dashboard and one SQL/banner note are recorded. The note says Jan 17–23, while later assistant evidence says Jan 24–30; the live dashboard needs inspection before its currentness is claimed.

## Workflow state and snapshot caveats

| Workflow | Last recorded state | Caveat |
|---|---|---|
| `GA4 Weekly ETL` | Inactive; schedule deactivated in the repository export | Export has 5 nodes; isolated import evidence refers to a distinct 10-node revision. |
| `GA4 - Weekly AI Insights` | Repository export inactive | Export has 7 nodes; later captured snapshot has 24 nodes and additional return/log branches. |
| `GA4 - AI Analytics Assistant` | Published and active when observed 2026-10-25 | Repository export has 8 nodes; isolated import evidence refers to a different 12-node version. Nov 7 test covers documented chat cases, not all tool branches. |
| `GA4 - Presentation Generator` | Published and active when observed 2026-10-25; PowerPoint export node deactivated | Repository export has 12 nodes; later captured snapshot has 41 nodes. Chat evidence tested cached reuse, not all generation/recovery paths. |

## Open verification work

- Inspect the current published workflows and reconcile them with checked-in exports before distributing or importing those exports as current.
- Verify all current export imports in an isolated n8n version and exercise only in a disposable environment with explicit approved test credentials.
- Verify actual Supabase schema, grants, RLS, and least-privilege roles for the three documented tables.
- Audit Metabase questions, SQL, charts, filters, date range, live refresh, and datasource role.
- Confirm current log workbook headers and logger helper contract before connecting any workflow.
- Confirm licensing and redistribution rights before publishing the repository or presentation assets.

## Not established

- The Weekly ETL schedule is running automatically.
- Dashboard calculations and visual layout have been fully audited.
- Every report-generation, failure, cache-recovery, and logging branch has been tested.
- Database grants/RLS or production-grade import/runtime readiness have been validated.
