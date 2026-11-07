# Project Sync Notes

This file is the continuation point for this repository. Refresh it when contents or project state change materially. Never include credentials, access tokens, private keys, personal data, or secret-bearing workflow exports.

## Repository

- GitHub repository: [`cizmeli/ga4-ai-analytics-automation`](https://github.com/cizmeli/ga4-ai-analytics-automation)
- GitHub metadata confirms the repository is public (checked 2026-11-07).
- Project artifacts are written in English; conversation with the owner may be Turkish.

## Project purpose

A learning and portfolio project based on anonymized historical GA4 ecommerce sample data (2020-11-01 through 2021-01-31): BigQuery weekly aggregation, Supabase metrics and reports, Metabase visualizations, an n8n assistant, saved weekly insights, Google Slides reports, and a shared Google Sheets log writer.

Reporting intervals start on Sunday, span seven days, and end with a one-day partial period. Exclude the partial period from complete-week comparisons. Weekly distinct users are not additive across weeks.

## Current evidence

- The four checked-in inactive exports now reflect the verified graphs captured on 2026-11-07: ETL 10 nodes, Weekly AI Insights 24, Assistant 12, and Presentation Generator 41. They omit workflow-level IDs and credential bindings, use portable placeholders for instance-specific references, and regenerate node UUIDs.
- Isolated import evidence dated 2026-11-06 records four imported inactive workflows and no executions; it predates the current export node UUID regeneration.
- Assistant test evidence dated 2026-11-07 records 10/10 clean-round test cases passing; this does not establish that all workflow branches were tested.
- Live spreadsheet inspection confirms five log workbook tabs: `Runs`, `Stage Log`, `KPI Values`, `Evaluations`, and `Changes & Backups`. See [the verified header inventory](GA4_PROJECT_LOG_SCHEMA.md). The workflow and workbook binding are intentionally not exported here.
- Dashboard notes exist, but its observed period differs from the latest chat evidence. Reinspect the live dashboard before describing it as current.
- Offline GA4 Slides template revisions and the assistant test report are in `output/`.

## Continuation rules

1. Treat `sources/` as read-only project reference material.
2. For actual workflow behavior, inspect the current workflow instance or exact export snapshot and clearly identify which one supports each claim.
3. Keep credentials, instance-specific workflow and workbook IDs, personal data, and unredacted execution payloads out of this public repository.
4. Do not claim active scheduling, current dashboard accuracy, validated database grants/RLS, or complete workflow QA without direct evidence.
5. Keep any workflow create/update/delete/activation/execution behind explicit user approval. Documentation and read-only review do not authorize workflow changes.
6. Before publishing or committing, inspect changed files for secrets, private identifiers, and unsupported claims.

## Open work

- Re-import the regenerated portable exports in an isolated n8n environment before relying on them for a deployment.
- Recheck Supabase schema/permissions and Metabase dashboard SQL/visual behavior.
- Confirm the live logger workbook schema and run the logger only against an approved test destination.
- Review licensing and redistribution rights for the public repository and any presentation assets.
