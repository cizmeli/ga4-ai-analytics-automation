# Project Sync Notes

This file is the handoff point for future updates to this repository. Refresh it whenever project state or repository contents change materially. Keep it in English. Never place credentials, access tokens, private keys, personal data, or secret-bearing exports here.

## Repository

- GitHub repository: [cizmeli/ga4-ai-analytics-automation](https://github.com/cizmeli/ga4-ai-analytics-automation)
- Visibility: public, observed on 2026-11-05. This sync did not change repository visibility.
- Default branch: main.
- Base main head before this documentation correction: 59a37a14791578a3cb673fb12f2b7a62d79c7c42.
- Pre-correction snapshot is preserved on branch backup/pre-assistant-draft-wording-2026-11-06.
- Previous documentation snapshot remains on backup/pre-doc-review-fixes-2026-11-06 at 69292337f4f2bfefeda29ce5624ddc3f4b14f129.
- Earlier pre-sync snapshot remains on backup/pre-sync-2026-11-05 at e485612d3ebc0371d317fa89e9624e0c911443b2.
- Latest recorded sync: Step 30 calls are non-blocking; logger failures can omit log entries without stopping parent workflows. See GitHub history for commits.
- Project artifacts and technical documentation are written in English. Conversation with the owner may be in Turkish.

## Project purpose and architecture

A reproducible learning/portfolio project based on anonymized historical GA4 sample ecommerce data (2020-11-01 to 2021-01-31):

1. BigQuery public GA4 sample → weekly KPI aggregation in n8n.
2. Supabase PostgreSQL stores weekly KPI data and generated artifacts.
3. Metabase visualizes weekly metrics.
4. An n8n AI Assistant uses OpenRouter and read-only PostgreSQL tools, with conversation memory and on-demand insights.
5. Weekly Insights compares a selected complete week with the preceding complete week and saves a versioned metrics snapshot.
6. Presentation Generator copies a Google Slides template, fills placeholders, and caches the result by source-report version.
7. Step 30 logging calls send allowlisted run, stage, and aggregate KPI summaries to the shared Project Log Writer, which writes to a configured Google Sheets workbook.

The data is historical, anonymized sample data, not live business traffic. Reporting weeks are Sunday through Saturday; partial weeks are excluded from full-week comparisons.

## Current workflow state observed in n8n on 2026-11-06

| Workflow | Observed state | Key behavior and caution |
|---|---|---|
| GA4 Weekly ETL | Inactive; current 10-node configuration has no published active version | Schedule Trigger is deactivated. All available historical data is loaded; no schedule is needed. The current configuration was not runtime-tested in this sync. |
| GA4 - Weekly AI Insights | Published and active; 24-node published graph | Accepts a selected complete week or defaults to the latest eligible pair; requires a consecutive prior week; unchanged metrics snapshots return the saved report. |
| GA4 - AI Analytics Assistant | Published and active; 12-node graph | Authenticated chat, read-only KPI tools, on-demand insights, and explicit-request presentation tool. The saved draft and published version both contain three logger nodes named `Log Assistant Run Start`, `Log Assistant Agent Stage`, and `Log Assistant Run Completion`. |
| GA4 - Presentation Generator | Published and active; 32-node graph | Generates or reuses a deck for an eligible requested week; returns not_found if its insight cannot be produced. PowerPoint download is deactivated. The saved draft now contains 32 nodes, including all 15 Step 30 logging calls. |
| GA4 Project Log Writer | Active shared helper; 7 nodes | Sanitizes run/stage/KPI summaries and upserts them to configured Google Sheets. This is an external write path. |
| GA4 Temporary Read-only Permission Check | Inactive temporary workflow | Excluded from product exports. |

The Step 32 v6 Weekly Insights query is an unpublished draft. It adds purchase_users and prev_purchase_users to the comparison projection and passed 8/8 no-write output hard gates on 2026-11-05. It is stored separately in [sql/ga4-weekly-insights-v6-draft.sql](../sql/ga4-weekly-insights-v6-draft.sql); the active published export remains unchanged.

## Repository contents

- README.md — overview, architecture, current state, quick start, and KPI contract.
- workflows/exports/*.json — four included portable workflow exports with active=false; active production flows are based on their published versions. The ETL export is its current inactive configuration. The active Project Log Writer is documented, but its portable export is intentionally not included in this public repository.
- workflows/docs/*.md — node descriptions, behavior notes, and Mermaid diagrams, including Step 30 logging.
- prompts/ai-assistant-system-prompt.md — current published assistant system prompt.
- prompts/assistant-test-prompts.md — manual assistant checks.
- sql/ga4-weekly-insights-v6-draft.sql — unpublished read-only Step 32 query draft.
- sql/schema.sql, sql/weekly_analytics.sql — schema example and reusable analytics SQL.
- docs/SETUP.md, docs/SECURITY.md, docs/STATUS.md, docs/COSTS_AND_ROADMAP.md — setup, security, verified state, and planning notes.
- docker/compose.yaml, .env.example, .gitignore — local setup helpers.

All included exports omit n8n credential bindings and live workflow, node, webhook, Drive, Sheets, BigQuery-project, and subworkflow identifiers. Portable exports are inactive. Reconnect credentials and rebind placeholders after import. Structural JSON parsing is not equivalent to testing an import or execution.

## Ground rules for future updates

1. Start from the current GitHub main and verify its head before writing.
2. Treat the ChatGPT project's sources/ directory and synced reference files as read-only. Use them as source material without modifying or publishing them wholesale.
3. When documenting behavior, inspect the current n8n workflow or latest published export. Clearly distinguish active published behavior, inactive configuration, and drafts.
4. Keep project files in English. Keep README and per-workflow Mermaid diagrams aligned with current workflow connections.
5. Never commit API keys, passwords, OAuth tokens, private keys, credential exports, live personal data, or unredacted execution logs. Keep .env.example limited to variable names and safe placeholders.
6. The repository is public as observed on 2026-11-05. Do not change visibility without explicit approval.
7. Do not claim scheduled ETL, validated database grants/RLS, or tested workflow imports unless each has been implemented and verified. On-demand insight generation is bounded to eligible complete weeks in the historical dataset.
8. Before writing to GitHub, inspect changed files for secrets, private identifiers, unsupported claims, and accidental data. Keep before-backups outside the repository and update this handoff after each material change.

## Open work and verification gaps

- Re-import sanitized workflows into a disposable n8n instance and verify they open; reconnect credentials and validate node versions/expressions without touching active production workflows.
- Verify Supabase table definitions, constraints, grants, and RLS for weekly_kpis, weekly_insights, and weekly_presentations.
- Audit Metabase dashboard questions, SQL, filters, date range, and datasource role.
- Verify local Docker/Metabase lifecycle and networking before relying on the sample Compose file.
- Confirm licensing and redistribution rights before adding a license, screenshots, or other assets.

## Update log

- 2026-11-06 — aligned Assistant workflow node-list labels with the current published nodes in commit `278a8e41`.

- 2026-11-06 — aligned Assistant and Presentation draft status with published workflows in commit `859857d1`.

- 2026-11-06 — updated the four workflow exports and logger guidance in commit `216d0d3e` after making Step 30 calls non-blocking.

- 2026-11-06 — documented the non-blocking Step 30 logger behavior across 35 calls; failed log writes can leave entries missing without stopping parent workflows.
- 2026-11-06 — aligned Assistant published/draft logger names in status documentation with the current workflow.
- 2026-11-06 — corrected Assistant saved-draft documentation: all three logger nodes are present, with names differing from the published version.
- 2026-11-04 — documented selected-week on-demand insights and same-week presentation reload behavior.
- 2026-11-04 — added GitHub-rendered Mermaid workflow diagrams.
- 2026-11-04 — added the Weekly AI Insights export and related documentation.