# Project status

Snapshot: 2026-11-06 (Europe/Berlin). This records the current n8n workflow state and the verification performed after serialized logging was introduced. It is not a production audit.

## Verified workflow state

- GA4 Weekly ETL is inactive and has no published active version. Its schedule trigger is deactivated. All available historical sample data through 2021-01-31 is loaded, so no schedule is needed.
- GA4 - Weekly AI Insights is published and active with a 24-node published graph using the v6 comparison query and prompt. Its query includes purchase_users and prev_purchase_users. It accepts a selected complete week or defaults to the latest eligible pair, requires the immediately preceding complete week, and returns not_found when no eligible comparison exists. It skips LLM generation when the saved week_start and metrics_snapshot match.
- GA4 - AI Analytics Assistant is published and active with 12 nodes. It has an authenticated chat trigger, OpenRouter model, Simple Memory, three read-only PostgreSQL tools, an on-demand insights tool, and an explicit-request presentation tool.
- GA4 - Presentation Generator is published and active. Its sanitized export is synchronized in this repository.
- GA4 Project Log Writer is published and active with 9 nodes, including the Has KPI Rows? branch and Return Logger Completion node. It sanitizes incoming logging payloads and upserts run, stage, and aggregate KPI summaries to a configured Google Sheets destination. Logger calls in the active Presentation workflow wait for the Log Writer and continue if logging fails. The assistant, insights, presentation, and current ETL graphs have logging calls. Its portable export is intentionally not included in this public repository.
- GA4 Temporary Read-only Permission Check is inactive and temporary; it is not part of the product workflow exports.
- A local Metabase dashboard is available. Its chart definitions, SQL, filters, refresh behavior, and datasource permissions were not audited.

## Step 32 evaluation and published v6

The published 24-node Weekly Insights version uses the v6 query and prompt; its comparison output includes purchase_users and prev_purchase_users. The separate [ga4-weekly-insights-v6-draft.sql](../sql/ga4-weekly-insights-v6-draft.sql) file remains a reference artifact, while the sanitized JSON export matches the published v6 logic.

The no-write evaluation returned 8/8 hard-gate passes on 2026-11-05 using pinned test data. Logging returned no_write/test_only, and the retest did not persist workflow output. This is evaluation evidence for the query and prompt logic, not a runtime test of the published workflow.

## Runtime and logging verification

- On 2026-11-06, the published Presentation workflow reused an existing presentation for the requested week. Expected stage log events for the presentation and assistant were written. No new Slides file or presentation database record was created.
- A pinned test of the saved generated-presentation branch recorded all expected stage log events and one run row, then reached the final response using mocked Drive and database outputs. It did not create a real Slides file or database record.
- A direct pinned Log Writer test reached its completion branch, but the Sheets upserts were pinned, so it performed no external write.
- The current published generated-presentation path has not had a real new-presentation run after the logging serialization change. A previous real generation run was on an earlier build.
- The missing-insights then reload branch was not tested in this round.

Existing history includes insights reports and cached returns for eligible complete weeks. Existing presentation fault-injection cases stopped before save when a copied file ID was missing or a fake Slides ID returned 404; these were expected negative tests, not evidence of a provider outage. Existing assistant history includes insights-only requests that did not invoke the presentation workflow.

## Saved draft and published logging state

Checked against n8n on 2026-11-06:

- In the active Presentation workflow, logger calls wait for the Log Writer; a logger error does not stop the parent workflow. A failed call can leave its log entry missing.
- The active published Assistant workflow and its current saved draft both contain three assistant logging stages.

The active published versions remain the runtime reference.

## Known gaps

- No sanitized workflow export has been re-imported into a disposable n8n instance during this review.
- Actual Supabase table constraints, grants, and RLS have not been independently checked.
- Metabase question accuracy and dashboard data quality have not been audited.
- The ETL schedule is not running; the historical sample is fully loaded.
- Device-level analysis is not available in the current assistant tool set.
- Weekly comparisons are limited to complete weeks and the available historical sample.
- No API keys, passwords, OAuth tokens, credential contents, live personal data, or execution payloads belong in this repository.
