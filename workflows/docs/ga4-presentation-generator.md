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

After serialized logging was introduced, the active runtime reused an existing presentation for a requested week and wrote the expected presentation and assistant stage log events. It did not create a new Slides file or presentation database record.

A pinned test of the generated-presentation branch wrote the expected stage log events and one run row, then reached the final response using mocked Drive and database outputs. It did not perform real Slides or database writes. The current published generated-presentation path has not had a real new-presentation run after the logging change; an earlier real generation run was on an older build. The missing-insights then reload branch was not tested in this round.

A clean n8n import has not been validated. Review and configure the export before use.

See [project status](../../docs/STATUS.md) for related project notes.
