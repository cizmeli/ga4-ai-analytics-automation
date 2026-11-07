# GA4 Presentation Generator

The Presentation Generator prepares or reuses a presentation for an eligible reporting week. It can be requested through the assistant or started manually.

## Published runtime

The published, active graph captured on 2026-11-07 contains 41 nodes. The inactive portable export has the same 41-node structure, including seven presentation-recovery nodes and 16 serialized logging calls.

- Retrieves the requested week's report, with a fallback to the latest eligible period when no week is specified.
- If the report is missing, requests an update and checks again. It returns `not_found` when no eligible report is available.
- Reuses an existing presentation when it matches the source report; otherwise, it prepares a new presentation and returns its link.
- Logging calls wait for the Log Writer and continue if logging fails.

## Portable export

The sanitized JSON export contains the same 41 nodes as the captured live graph and is inactive for portable use. Its 16 logging calls are:

- `Log Presentation — Manual run started`
- `Log Presentation — Subworkflow run started`
- `Log Presentation — Source report loaded`
- `Log Presentation — Report available`
- `Log Presentation — Report unavailable`
- `Log Presentation — Insights generated`
- `Log Presentation — Reloaded report available`
- `Log Presentation — Reloaded report unavailable`
- `Log Presentation — Existing presentation not found`
- `Log Presentation — Existing presentation found`
- `Log Presentation — Presentation content prepared`
- `Log Presentation — Presentation record saved`
- `Log Presentation — Presentation result returned`
- `Log Presentation — Existing presentation returned`
- `Log Presentation — Report not found returned`
- `Log Presentation — Duplicate presentations detected`

Workflow IDs, credentials, the GCP project, and the Slides template are omitted or replaced with portable placeholders.

## Verification limits

No production workflow was executed for this synchronization. The graph and structural review do not establish that every report-generation, recovery, or logging branch succeeds.

A clean n8n import has not been validated. Review and configure the export before use.

See [project status](../../docs/STATUS.md) for related project notes.
