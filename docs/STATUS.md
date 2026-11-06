# Project status

Snapshot: 2026-11-06 (Europe/Berlin). This records the current n8n workflow state and the verification performed after serialized logging was introduced. It is not a production audit.

## Verified workflow state

- GA4 Weekly ETL is inactive and has no published active version. Its schedule trigger is deactivated. All available historical sample data through 2021-01-31 is loaded, so no schedule is needed.
- GA4 - Weekly AI Insights is published and active with a 24-node published graph using the v6 comparison query and prompt. Its query includes purchase_users and prev_purchase_users. It accepts a selected complete week or defaults to the latest eligible pair, requires the immediately preceding complete week, and returns not_found when no eligible comparison exists. It skips LLM generation when the saved week_start and metrics_snapshot match.
- GA4 - AI Analytics Assistant is published and active with 12 nodes. It has an authenticated chat trigger, OpenRouter model, Simple Memory, three read-only PostgreSQL tools, an on-demand insights tool, and an explicit-request presentation tool.
- GA4 - Presentation Generator is published and active. The 33-node sanitized portable export differs from the 41-node published runtime: it omits seven presentation-recovery nodes and the final (16th) logger call.
- GA4 Project Log Writer is published and active with 9 nodes, including the Has KPI Rows? branch and Return Logger Completion node. It sanitizes incoming logging payloads and upserts run, stage, and aggregate KPI summaries to a configured Google Sheets destination. Logger calls in the active Presentation workflow wait for the Log Writer and continue if logging fails. The assistant, insights, presentation, and current ETL graphs have logging calls. Its portable export is intentionally not included in this public repository.
- GA4 Temporary Read-only Permission Check is inactive and temporary; it is not part of the product workflow exports.
- A local Metabase dashboard is available. Its chart definitions, SQL, filters, refresh behavior, and datasource permissions were not audited.

## Step 32 evaluation and published v6

The published 24-node Weekly Insights version uses the v6 query and prompt; its comparison output includes purchase_users and prev_purchase_users. The separate [ga4-weekly-insights-v6-draft.sql](../sql/ga4-weekly-insights-v6-draft.sql) file remains a reference artifact, while the sanitized JSON export matches the published v6 logic.

The no-write evaluation returned 8/8 hard-gate passes on 2026-11-05 using pinned test data. Logging returned no_write/test_only, and the retest did not persist workflow output. This is evaluation evidence for the query and prompt logic, not a runtime test of the published workflow.

## Runtime and logging verification

- On 2026-11-06, a real production run of the published Assistant → Presentation Generator → Log Writer flow succeeded and created a new Slides deck for the reporting week 2020-12-27 through 2021-01-02; it did not reuse a cached deck.
- All nine Presentation stages succeeded. Nineteen Log Writer executions in the run window succeeded without retries, and the logger helper remains active.
- The Assistant final-response row succeeded with `runStatus=succeeded` and `updateRunRow=true`. The later `chat-trigger-start` row had `updateRunRow=false`, skipped Upsert Run Row, and did not overwrite the completed run with stale-start data.
- This verifies a real new-presentation production run after the serial logger fix. The missing-insights then reload branch was not tested in this round.

Existing history includes insights reports and cached returns for eligible complete weeks. Existing presentation fault-injection cases stopped before save when a copied file ID was missing or a fake Slides ID returned 404; these were expected negative tests, not evidence of a provider outage. Existing assistant history includes insights-only requests that did not invoke the presentation workflow.

## Saved draft and published logging state

Checked against n8n on 2026-11-06:

- In the active Presentation workflow, logger calls wait for the Log Writer; a logger error does not stop the parent workflow. A failed call can leave its log entry missing.
- The active published Assistant workflow and its current saved draft both contain three assistant logging stages.

The active published versions remain the runtime reference.

## Known gaps

- No sanitized workflow export has been re-imported into a disposable n8n instance during this review.
- The metadata-only Supabase audit completed catalog checks of constraints, effective schema/table/column grants, and RLS flags and policies for the three target public tables; it did not read business rows. Business-row validation and data-level policy behavior were not tested.
- Metabase question accuracy and dashboard data quality have not been audited.
- The ETL schedule is not running; the historical sample is fully loaded.
- Device-level analysis is not available in the current assistant tool set.
- Weekly comparisons are limited to complete weeks and the available historical sample.
- No API keys, passwords, OAuth tokens, credential contents, live personal data, or execution payloads belong in this repository.
