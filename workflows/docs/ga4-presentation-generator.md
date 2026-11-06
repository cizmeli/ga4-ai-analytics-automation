# GA4 Presentation Generator

The Presentation Generator prepares or reuses a presentation for an eligible reporting week. It can be requested through the assistant or started manually.

## Portable export

The sanitized JSON export contains 33 nodes and is inactive for portable use. Generic placeholders must be configured for your own environment before use.

## Behavior summary

- Retrieves the requested week's report, with a fallback to the latest eligible period when no week is specified.
- If the report is missing, requests an update and checks again. It returns `not_found` when no eligible report is available.
- Reuses an existing presentation when it matches the source report; otherwise, it prepares a new presentation and returns its link.

## Verification limits

The existing runtime cache-hit path was verified. The generated-presentation path has not been rerun on the current workflow version, and a clean n8n import has not been validated. The export should be reviewed and configured before use.

See [project status](../../docs/STATUS.md) for related project notes.
