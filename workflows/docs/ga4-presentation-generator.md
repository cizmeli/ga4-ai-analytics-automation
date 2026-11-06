# GA4 Presentation Generator

The Presentation Generator prepares or reuses a presentation for an eligible reporting week. It can be requested through the assistant or started manually.

## Published runtime

The published, active runtime contains 41 nodes. Its graph includes seven presentation-recovery nodes and 16 serialized logging calls, including a final logger call.

- Retrieves the requested week's report, with a fallback to the latest eligible period when no week is specified.
- If the report is missing, requests an update and checks again. It returns `not_found` when no eligible report is available.
- Reuses an existing presentation when it matches the source report; otherwise, it prepares a new presentation and returns its link.
- Logging calls wait for the Log Writer and continue if logging fails.

## Portable export

The sanitized JSON export contains 33 nodes and is inactive for portable use. It omits the seven presentation-recovery nodes and the final (16th) logger call, so it contains 15 logging calls and does not exactly match the published runtime. Generic placeholders must be configured for your own environment before use.

## Verification limits

On 2026-11-06, a real production run of the published Assistant → Presentation Generator → Log Writer flow created a new Slides deck for 2020-12-27 through 2021-01-02 rather than reusing a cached presentation. The logger helper remains active.

The same run exercised the missing-insights then reload path: `Weekly Report Found?` took its no-result branch, `Generate Missing Weekly Insights` succeeded, `Reload Presentation Data` ran, and `Reloaded Weekly Report Found?` took its found branch. Presentation stages 06 and 07 succeeded. All nine Presentation stages succeeded, and 19 Log Writer executions in the run window succeeded without retries. The Assistant final-response row succeeded with `updateRunRow=true`; a later `chat-trigger-start` row had `updateRunRow=false` and skipped Upsert Run Row, preventing stale-start data from overwriting the completed run.

A clean n8n import has not been validated. Review and configure the export before use.

See [project status](../../docs/STATUS.md) for related project notes.
