# GA4 Project Log Writer

**Observed state:** published active shared helper, 9 nodes. Four GA4 workflows invoke it through logging nodes. **GA4 - AI Analytics Assistant** uses `Log Assistant Run Start`, `Log Assistant Agent Stage`, and `Log Assistant Run Completion`; the other three use `Step 30` logging nodes.

## Serial node order and purpose

1. **When Executed by Another Workflow** — receives a logging event.
2. **Sanitize Logging Payload** — filters input to allowlisted run, stage, and aggregate KPI fields.
3. **Upsert Stage Row** — records a sanitized stage result.
4. **Update Run Row?** — checks whether run-level status should be updated.
5. **Upsert Run Row** — upserts the sanitized run summary when the check is true; the false path skips this write.
6. **Expand KPI Rows** — maps aggregate KPIs into rows after the run-row check and any run-row upsert.
7. **Has KPI Rows?** — checks whether the expansion produced rows before the KPI upsert.
8. **Upsert KPI Row** — upserts KPI summaries when rows are present; the false path skips this write.
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
  T["When Executed by Another Workflow"] --> S[Sanitize Logging Payload] --> U[Upsert Stage Row] --> RQ{Update Run Row?}
  RQ -->|Yes| RU[Upsert Run Row]
  RQ -->|No| K[Expand KPI Rows]
  RU --> K
  K --> HQ{Has KPI Rows?}
  HQ -->|Yes| KP[Upsert KPI Row] --> C[Return Logger Completion]
  HQ -->|No| C
~~~

Portable export: intentionally not included in this public repository.
