# Project Sync Notes

This file is the handoff point for future updates to this repository. Refresh it whenever project state or repository contents change materially. Keep it in English to match the project documentation. Never place credentials, access tokens, private keys, personal data, or secret-bearing exports here.

## Repository

- GitHub repository: [`cizmeli/ga4-ai-analytics-automation`](https://github.com/cizmeli/ga4-ai-analytics-automation)
- Visibility: private (verified when the repository was prepared).
- Default branch: `main`.
- Latest recorded update: workflow diagrams added in commit `9a3d67663b24940d288af15c743c57bf4c3b0bde`.
- Project artifacts and technical documentation are written in English. Conversation with the owner may be in Turkish.

## Project purpose and architecture

A reproducible learning/portfolio project based on anonymized historical GA4 sample ecommerce data (2020-11-01 to 2021-01-31):

1. BigQuery public GA4 sample → weekly KPI aggregation in n8n.
2. Supabase PostgreSQL stores weekly KPI data and generated artifacts.
3. Metabase visualizes weekly metrics.
4. An n8n AI assistant uses OpenRouter and read-only PostgreSQL tools, with conversation memory.
5. A weekly insight workflow summarizes the latest consecutive complete weeks and saves a versioned metrics snapshot.
6. A presentation workflow copies a Google Slides template, fills placeholders, and caches the result by source-report version.

The data is historical, anonymized sample data, not live business traffic. Reporting weeks are Sunday through Saturday; partial weeks must be excluded from full-week comparisons.

## Current workflow state observed in n8n on 2026-10-25

| Workflow | Observed state | Key behavior / caution |
|---|---|---|
| `GA4 Weekly ETL` | Inactive; schedule trigger deactivated | Gets next historical week, queries BigQuery, upserts KPIs, then invokes Weekly AI Insights. Do not claim it is running automatically. |
| `GA4 - Weekly AI Insights` | Inactive | Compares the latest consecutive complete weeks; skips generation when the saved metrics snapshot is unchanged; saves report to `weekly_insights`. |
| `GA4 - AI Analytics Assistant` | Published and active | Chat interface with Simple Memory, OpenRouter Gemini 3.1 Flash Lite, read-only PostgreSQL tools, and a presentation tool. |
| `GA4 - Presentation Generator` | Published and active | Returns a cached presentation for the same report version or creates a deck from a Google Slides template. PowerPoint download node is deactivated. |

The manual and called-workflow triggers in Weekly AI Insights both run the latest-week comparison. The export does not implement arbitrary historical-week selection or user-requested generation for a chosen past period. Preserve this distinction in future docs and summaries.

## Repository contents

- `README.md` — overview, architecture Mermaid diagram, status, quick start, KPI contract, and repository map.
- `workflows/exports/*.json` — credential-free n8n exports for the four workflows.
- `workflows/docs/*.md` — node descriptions, workflow-specific notes, and Mermaid flow diagrams.
- `prompts/ai-assistant-system-prompt.md` — captured assistant system prompt.
- `prompts/assistant-test-prompts.md` — manual assistant checks.
- `sql/schema.sql`, `sql/weekly_analytics.sql` — schema example and analytics SQL.
- `docs/SETUP.md`, `docs/SECURITY.md`, `docs/STATUS.md`, `docs/COSTS_AND_ROADMAP.md` — setup, security, verified status, and planning notes.
- `docker/compose.yaml`, `.env.example`, `.gitignore` — local setup helpers.
- `docs/PROJECT_SYNC.md` — this continuation/handoff note.

Exports omit credential bindings and instance-specific IDs. Some Google Drive and subworkflow identifiers are replaced with placeholders. Reconnect credentials and rebind placeholders after import. Structural JSON parsing is not equivalent to testing an import or execution in n8n.

## Ground rules for future updates

1. Start with the current GitHub `main` and this sync note; verify the branch head before writing.
2. Treat the ChatGPT project's `sources/` directory and its synced reference files as read-only. Use those files as source material without modifying or publishing them wholesale.
3. When documenting actual behavior, inspect the current n8n workflow or latest export. Clearly separate observed implementation from plans and assumptions.
4. Keep project files in English. Keep README workflow diagrams and per-workflow Mermaid diagrams aligned with the current exported connections.
5. Never commit API keys, passwords, OAuth tokens, private keys, credential exports, live personal data, or unredacted execution logs. Keep `.env.example` limited to variable names and safe placeholders.
6. Keep the repository private unless the owner explicitly changes the visibility decision. Do not publish or change visibility without explicit approval.
7. Do not claim arbitrary historical report generation, active scheduling, validated database grants/RLS, or tested workflow imports unless each has been implemented and verified.
8. Before writing to GitHub, inspect all changed files for accidental secrets, private identifiers, and unsupported claims. Update this file with the resulting commit and remaining work.

## Open work / verification gaps

- Import each sanitized workflow into a separate or disposable n8n instance and verify it opens; then reconnect credentials and validate node versions/expressions without touching the active production workflow.
- Verify actual Supabase table definitions, constraints, grants, and RLS for `weekly_kpis`, `weekly_insights`, and `weekly_presentations` before applying any schema example.
- Audit Metabase dashboard questions, SQL, filters, date range, and datasource role. The local dashboard was visible, but its chart calculations were not independently audited.
- Verify local Docker/Metabase lifecycle and networking from the current machine before relying on the sample Compose file.
- Run workflow QA in a disposable environment: date boundaries, exhausted dataset, empty query results, idempotent writes, unchanged/changed insight snapshots, presentation cache hits, and returned URLs.
- Confirm licensing and redistribution rights before adding a license, screenshots, or other assets.

## Update log

- `9a3d676` — added GitHub-rendered Mermaid diagrams for all four n8n workflows and linked them from the README.
- `26a1b3f` — added the sanitized Weekly AI Insights workflow export and its documentation; refreshed status and roadmap.
- `d686a14` — added initial workflow exports, SQL, setup/security documentation, prompts, and repository structure.
