# Project status

Snapshot assembled 2026-11-07 (Europe/Berlin) from the checked-in exports, captured workflow backups, isolated import record, local dashboard note, assistant test evidence, and GitHub repository metadata. The repository is public. This is not a production audit.

## Verified evidence

- The four checked-in exports cover Weekly ETL, Weekly AI Insights, AI Analytics Assistant, and Presentation Generator. They contain no credential bindings, omit workflow-level IDs, use regenerated node UUIDs, and are inactive. The Presentation Generator export (33 nodes) differs from the 41-node published runtime described in its workflow document.
- A 2026-11-06 isolated n8n import test imported four sanitized workflow files in n8n 2.29.9. All were inactive and none were executed; that test predates the node UUID regeneration in the current exports, so the current files have not been re-imported.
- The assistant's clean second-round chat evidence records 10 of 10 test cases passing on 2026-11-07, including KPI retrieval, trend reporting, correct refusal to sum weekly distinct users, device-data limitation, saved insights retrieval, and cached presentation reuse.
- Live spreadsheet metadata and header reads confirm five tabs: `Runs`, `Stage Log`, `KPI Values`, `Evaluations`, and `Changes & Backups`. Their exact header lists are in [the log schema inventory](GA4_PROJECT_LOG_SCHEMA.md). The helper export and workbook binding are not part of the repository.
- A local Metabase dashboard and one SQL/banner note are recorded. The note says Jan 17–23, while later assistant evidence says Jan 24–30; the live dashboard needs inspection before its currentness is claimed.

## Workflow state and snapshot caveats

| Workflow | Last recorded state | Caveat |
|---|---|---|
| `GA4 Weekly ETL` | Inactive; schedule deactivated in the repository export | Current export has 10 nodes; runtime configuration was not tested in this documentation pass. |
| `GA4 - Weekly AI Insights` | Repository export inactive; captured runtime documentation describes an active 24-node version | Current 24-node export includes the documented return and logging branches and is the portable inactive representation. |
| `GA4 - AI Analytics Assistant` | Published and active when observed 2026-11-06 | Current export has 12 nodes. Nov 7 test covers documented chat cases, not all tool branches. |
| `GA4 - Presentation Generator` | Published and active in the latest recorded runtime evidence (2026-11-06); the export is inactive | Current export has 33 nodes versus the documented 41-node published runtime. Chat evidence tested cached reuse, not all generation/recovery paths. |

## Open verification work

- Inspect the current published workflows and reconcile them with checked-in exports before distributing or importing those exports as current.
- Verify all current export imports in an isolated n8n version and exercise only in a disposable environment with explicit approved test credentials.
- Verify actual Supabase schema, grants, RLS, and least-privilege roles for the three documented tables.
- Audit Metabase questions, SQL, charts, filters, date range, live refresh, and datasource role.
- Confirm current log workbook headers and logger helper contract before connecting any workflow.
- Review licensing and redistribution rights for the public repository and presentation assets; no license is included.

## Not established

- The Weekly ETL schedule is running automatically.
- Dashboard calculations and visual layout have been fully audited.
- Every report-generation, failure, cache-recovery, and logging branch has been tested.
- Database grants/RLS or production-grade import/runtime readiness have been validated.
