# Project status

Snapshot: 2026-11-06 (Europe/Berlin). This reflects the open n8n instance, existing execution history, and the Step 32 no-write evaluation performed on 2026-11-05. It is not a production audit. No workflow was activated or run for this documentation sync.

## Verified workflow state

- GA4 Weekly ETL is inactive. Its current 10-node configuration has no published active version, and its schedule trigger is deactivated. All available historical sample data through 2021-01-31 is loaded, so no schedule is needed. The current configuration was not runtime-tested for this update; the latest successful ETL execution in reviewed history was 2026-10-25.
- GA4 - Weekly AI Insights is published and active with a 24-node published graph. It accepts a selected complete week or defaults to the latest eligible pair, requires the immediately preceding complete week, and returns not_found when no eligible comparison exists. It skips LLM generation when the saved week_start and metrics_snapshot match.
- GA4 - AI Analytics Assistant is published and active with 12 nodes. It has an authenticated chat trigger, OpenRouter model, Simple Memory, three read-only PostgreSQL tools, an on-demand insights tool, and an explicit-request presentation tool. Successful assistant runs were present in reviewed 2026-11-04 history.
- GA4 - Presentation Generator is published and active with a 32-node published graph. If a requested report is missing, it asks Weekly Insights for that same week, reloads the report, and then reuses or creates a deck. It returns not_found when no eligible insight is produced. PowerPoint download remains deactivated.
- GA4 Project Log Writer is active with 7 nodes. It sanitizes incoming logging payloads and upserts run, stage, and aggregate KPI summaries to a configured Google Sheets destination. The assistant, insights, presentation, and current ETL graphs have Step 30 logging calls. Its portable export is intentionally not included in this public repository.
- GA4 Temporary Read-only Permission Check is inactive and temporary; it is not part of the product workflow exports.
- The Metabase dashboard is visible at http://localhost:3001. Its chart definitions, SQL, filters, refresh behavior, and datasource permissions were not audited.

## Step 32 draft and evaluation

The unpublished v6 draft of the Weekly Insights comparison query adds purchase_users and prev_purchase_users. The separate draft SQL is [ga4-weekly-insights-v6-draft.sql](../sql/ga4-weekly-insights-v6-draft.sql). It is not included in the published workflow export and has not been activated.

The no-write evaluation returned 8/8 hard-gate passes on 2026-11-05. It used pinned test data; logging nodes returned no_write/test_only, and the retest did not persist workflow output. The independent reviewer classified the “contribute to the observed change” wording as arithmetic decomposition, not a business-causality claim.

## Existing execution evidence reviewed

- Existing Weekly Insights history includes generated reports and cached returns for eligible complete weeks. A cache hit skips the insights-generation LLM and save node.
- Existing presentation fault-injection cases stopped before save when the copied file ID was missing or a fake Slides ID returned 404. These were expected negative tests, not evidence of a production provider outage.
- Existing assistant history includes insights-only requests that did not invoke the presentation workflow.

These are observations from existing history, not new executions from this sync.

## Saved draft and published logging state

Checked against n8n on 2026-11-06:

- The active published 12-node version of `GA4 - AI Analytics Assistant` contains three Step 30 logging calls. Its current saved draft contains none. Keep the published version as the runtime reference; reconcile the logging nodes and connections before publishing the draft.
- The active published 32-node version of `GA4 - Presentation Generator` contains 15 Step 30 logging calls. Its current saved draft has 17 nodes and contains none. Reconcile the logging nodes and connections before publishing the draft, or its runtime flow would lose those calls.

The active published versions remain the runtime reference.

## Known gaps

- No sanitized workflow export has been re-imported into a disposable n8n instance during this review.
- Actual Supabase table constraints, grants, and RLS have not been independently checked.
- Metabase question accuracy and dashboard data quality have not been audited.
- The ETL schedule is not running; the historical sample is fully loaded.
- Device-level analysis is not available in the current assistant tool set.
- Weekly comparisons are limited to complete weeks and the available historical sample.
- No API keys, passwords, OAuth tokens, credential contents, live personal data, or execution payloads belong in this repository.