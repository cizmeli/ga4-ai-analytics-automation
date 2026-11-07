# Project Sync Notes

This file is the continuation point for this repository. Refresh it when contents or project state change materially. Never include credentials, access tokens, private keys, personal data, or secret-bearing workflow exports.

## Repository

- GitHub repository: [`cizmeli/ga4-ai-analytics-automation`](https://github.com/cizmeli/ga4-ai-analytics-automation)
- Visibility recorded as private; do not change it without explicit authorization.
- Project artifacts are written in English; conversation with the owner may be Turkish.

## Project purpose

A learning and portfolio project based on anonymized historical GA4 ecommerce sample data (2020-11-01 through 2021-01-31): BigQuery weekly aggregation, Supabase metrics and reports, Metabase visualizations, an n8n assistant, saved weekly insights, Google Slides reports, and a shared Google Sheets log writer.

Reporting intervals start on Sunday, span seven days, and end with a one-day partial period. Exclude the partial period from complete-week comparisons. Weekly distinct users are not additive across weeks.

## Current evidence

- Checked-in workflow exports are sanitized but do not match every later captured workflow snapshot. See the four files under `workflows/docs/` for per-workflow scope and differences.
- Isolated import evidence dated 2026-11-06 records four successfully imported, inactive workflows and no executions.
- Assistant test evidence dated 2026-11-07 records 10/10 clean-round test cases passing; this does not establish that all workflow branches were tested.
- Live spreadsheet inspection confirms five log workbook tabs: `Runs`, `Stage Log`, `KPI Values`, `Evaluations`, and `Changes & Backups`. See [the verified header inventory](GA4_PROJECT_LOG_SCHEMA.md). The workflow and workbook binding are intentionally not exported here.
- Dashboard notes exist, but its observed period differs from the latest chat evidence. Reinspect the live dashboard before describing it as current.
- Offline GA4 Slides template revisions and the assistant test report are in `output/`.

## Continuation rules

1. Treat `sources/` as read-only project reference material.
2. For actual workflow behavior, inspect the current workflow instance or exact export snapshot and clearly identify which one supports each claim.
3. Keep credentials, private workflow IDs, workbook IDs, personal data, and unredacted execution payloads out of this repository.
4. Do not claim active scheduling, current dashboard accuracy, validated database grants/RLS, or complete workflow QA without direct evidence.
5. Keep any workflow create/update/delete/activation/execution behind explicit user approval. Documentation and read-only review do not authorize workflow changes.
6. Before publishing or committing, inspect changed files for secrets, private identifiers, and unsupported claims.

## Open work

- Reconcile the credential-free workflow exports with current published workflow snapshots.
- Recheck Supabase schema/permissions and Metabase dashboard SQL/visual behavior.
- Confirm the live logger workbook schema and run the logger only against an approved test destination.
- Verify licenses before making the repository public or redistributing templates.
