# Project status

Snapshot: 2026-11-06 (Europe/Berlin). This reflects the open n8n instance, existing execution history, and the Step 32 no-write evaluation performed on 2026-11-05. It is not a production audit. The presentation link-return fix was validated without changing workflow activation state.

## Verified workflow state

- GA4 Weekly ETL is inactive. Its current 10-node configuration has no published active version, and its schedule trigger is deactivated. All available historical sample data through 2021-01-31 is loaded, so no schedule is needed. The current configuration was not runtime-tested for this update; the latest successful ETL execution in reviewed history was 2026-10-25.
- GA4 - Weekly AI Insights is published and active with a 24-node published graph using the v6 comparison query and prompt. Its query includes purchase_users and prev_purchase_users. It accepts a selected complete week or defaults to the latest eligible pair, requires the immediately preceding complete week, and returns not_found when no eligible comparison exists. It skips LLM generation when the saved week_start and metrics_snapshot match.
- GA4 - AI Analytics Assistant is published and active with 12 nodes. It has an authenticated chat trigger, OpenRouter model, Simple Memory, three read-only PostgreSQL tools, an on-demand insights tool, and an explicit-request presentation tool. Successful assistant runs were present in reviewed 2026-11-04 history.
- GA4 - Presentation Generator is published and active. Its presentation link-return fix was validated, and its sanitized export is synchronized in this repository.
- GA4 Project Log Writer is active with 7 nodes. It sanitizes incoming logging payloads and upserts run, stage, and aggregate KPI summaries to a configured Google Sheets destination. The assistant, insights, presentation, and current ETL graphs have Step 30 logging calls. Its portable export is intentionally not included in this public repository.
- GA4 Temporary Read-only Permission Check is inactive and temporary; it is not part of the product workflow exports.
- The Metabase dashboard is visible at http://localhost:3001. Its chart definitions, SQL, filters, refresh behavior, and datasource permissions were not audited.

## Step 32 evaluation and published v6

The published 24-node Weekly Insights version uses the v6 query and prompt; its comparison output includes purchase_users and prev_purchase_users. The separate [ga4-weekly-insights-v6-draft.sql](../sql/ga4-weekly-insights-v6-draft.sql) file remains a reference artifact, while the sanitized JSON export now matches the published v6 logic.

The no-write evaluation returned 8/8 hard-gate passes on 2026-11-05 using pinned test data. Logging returned no_write/test_only, and the retest did not persist workflow output. This is evaluation evidence for the query and prompt logic; the published workflow was not run as part of this documentation sync.

## Existing execution evidence reviewed

- Existing Weekly Insights history includes generated reports and cached returns for eligible complete weeks. A cache hit skips the insights-generation LLM and save node.
- Existing presentation fault-injection cases stopped before save when the copied file ID was missing or a fake Slides ID returned 404. These were expected negative tests, not evidence of a production provider outage.
- Existing assistant history includes insights-only requests that did not invoke the presentation workflow.

These are observations from prior history; the presentation link-return validation is recorded above.

## Saved draft and published logging state

Checked against n8n on 2026-11-06:

- Logger failures in active published Insights, Assistant, and Presentation workflows no longer stop the parent workflow; a failed call can leave its log entry missing. The five ETL logger calls use the same setting in the inactive draft.
- The active published 12-node version and current saved draft of `GA4 - AI Analytics Assistant` both contain three logger nodes named `Log Assistant Run Start`, `Log Assistant Agent Stage`, and `Log Assistant Run Completion`.

The active published versions remain the runtime reference.

## Known gaps

- No sanitized workflow export has been re-imported into a disposable n8n instance during this review.
- Actual Supabase table constraints, grants, and RLS have not been independently checked.
- Metabase question accuracy and dashboard data quality have not been audited.
- The ETL schedule is not running; the historical sample is fully loaded.
- Device-level analysis is not available in the current assistant tool set.
- Weekly comparisons are limited to complete weeks and the available historical sample.
- No API keys, passwords, OAuth tokens, credential contents, live personal data, or execution payloads belong in this repository.