# GA4 Project Log Writer

**Observed state:** published active shared helper, 9 nodes. It is invoked by Step 30 logging nodes in the four GA4 workflows.

## Node order and purpose

1. **When Executed by Another Workflow** — receives a logging event.
2. **Sanitize Logging Payload** — filters input to allowlisted run, stage, and aggregate KPI fields.
3. **Upsert Stage Row** — records a sanitized stage result.
4. **Expand KPI Rows** — maps aggregate KPIs into rows.
5. **Has KPI Rows?** — checks whether the expansion produced rows before the KPI upsert.
6. **Upsert KPI Row** — upserts KPI summaries when rows are present.
7. **Update Run Row?** — checks whether run-level status should be updated.
8. **Upsert Run Row** — upserts the sanitized run summary.
9. **Return Logger Completion** — returns the logger completion result to the calling workflow.

The Google Sheets nodes in the live helper write to its configured logging workbook. The workbook identifier and credential are not included in this public repository. The helper's portable workflow export is intentionally not included. Configure a separate test helper and workbook before connecting test workflows.

## Privacy and operations

- This workflow is an external write path to Google Sheets.
- The sanitizer limits logged data to run/stage metadata and aggregate KPI summaries; full prompts and raw node input/output are not the intended log content.
- Keep the Sheets credential in n8n. Never commit credential data, workbook IDs, or execution payloads.
- This public repository does not include a portable JSON for the helper.

## Workflow diagram

~~~mermaid
flowchart LR
  T[Called Workflow Trigger] --> S[Sanitize Logging Payload]
  S --> U[Upsert Stage Row]
  S --> K[Expand KPI Rows]
  K --> Q{Has KPI Rows?}
  Q -->|Yes| KP[Upsert KPI Row]
  Q -->|No| C[Return Logger Completion]
  KP --> C
  S --> RQ{Update Run Row?}
  RQ --> RU[Upsert Run Row]
  RU --> C
~~~

Portable export: intentionally not included in this public repository.
