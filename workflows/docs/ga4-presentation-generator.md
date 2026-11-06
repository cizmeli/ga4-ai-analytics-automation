# GA4 Presentation Generator

**Observed state:** published and active on 2026-11-06. The published version has 32 nodes. PowerPoint export/download remains deactivated.

## Node order and purpose

- **When clicking ‘Execute workflow’** — manual invocation.
- **When Executed by Another Workflow** — called for an explicit slide request.
- **Get Presentation Data** — loads the requested complete-week insight and metrics, or defaults to the latest eligible period.
- **Weekly Report Found?** — sends an existing report to the cache path or requests the same week's insight.
- **Generate Missing Weekly Insights** — requests the report for the requested week.
- **Reload Presentation Data** — reloads that exact week after every completed insights call, including not_found.
- **Reloaded Weekly Report Found?** — returns not_found when no eligible report is present; otherwise continues.
- **Check Existing Presentation** — checks the cache by week_start and report generated_at version.
- **Presentation Needs Generation?** — branches on the cache lookup.
- **Return Existing Presentation Link** — returns a cached deck without copying, filling, or saving another record.
- **Copy Presentation Template** — copies a Drive template.
- **Prepare Presentation Fields** — formats report and KPI values; requires the copied file to contain an id.
- **Fill Presentation Placeholders** — updates text in Google Slides.
- **Save Presentation Record** — persists the deck reference after the Slides update succeeds.
- **Return Presentation Link** — returns the new deck link.
- **Export PowerPoint** — optional download node; deactivated.

## Step 30 logging

The published graph has 15 logging calls to the shared Project Log Writer: two trigger/start nodes; report fetch; both report-availability branches; missing-insight generation; both reload/availability branches; both cache branches; document generation; external persistence/export; and three return branches. These calls log stage summaries separately from presentation persistence.

The logger is documented in [GA4 Project Log Writer](ga4-project-log-writer.md). The export omits credentials and live identifiers; replace Drive, Sheets, and workflow references after import.

## Verified cache and error paths

Existing history reviewed on 2026-11-04 showed that a cached deck was returned without another template copy, placeholder fill, or presentation-record save. Pinned fault-injection cases stopped before save when the copied file id was missing or a fake Slides id returned provider 404; neither case made a Drive copy. These were expected negative tests, not evidence of a production provider outage.

See [project status](../../docs/STATUS.md). Database schema, Google Drive permissions, and workflow imports have not been revalidated during this sync.

## Workflow diagram

~~~mermaid
flowchart LR
  M[Manual Trigger] --> D[Get Presentation Data]
  C[Explicit Slide Request] --> D
  D --> F{Weekly report found?}
  F -->|yes| K[Check Existing Presentation]
  F -->|no| W[Generate Missing Weekly Insights]
  W --> R[Reload Presentation Data]
  R --> G{Reloaded report found?}
  G -->|no| MR[Return Missing Report]
  G -->|yes| K
  K --> B{Presentation needs generation?}
  B -->|yes| CP[Copy Template]
  CP --> P[Prepare Fields]
  P --> U[Fill Placeholders]
  U --> S[Save Presentation Record]
  S --> RL[Return Presentation Link]
  B -->|no| E[Return Existing Link]
  D -.-> L3[Step 30 Log 03]
  F -.-> L4[Step 30 Log 04]
  F -.-> L5[Step 30 Log 05]
  W -.-> L6[Step 30 Log 06]
  R -.-> L7[Step 30 Log 07]
  G -.-> L8[Step 30 Log 08]
  K -.-> L9[Step 30 Log 09]
  K -.-> L10[Step 30 Log 10]
  CP -.-> L11[Step 30 Log 11]
  S -.-> L12[Step 30 Log 12]
  RL -.-> L13[Step 30 Log 13]
  E -.-> L14[Step 30 Log 14]
  MR -.-> L15[Step 30 Log 15]
  M -.-> L1[Step 30 Log 01]
  C -.-> L2[Step 30 Log 02]
  L1 --> LOG[GA4 Project Log Writer]
  L2 --> LOG
  L3 --> LOG
  L4 --> LOG
  L5 --> LOG
  L6 --> LOG
  L7 --> LOG
  L8 --> LOG
  L9 --> LOG
  L10 --> LOG
  L11 --> LOG
  L12 --> LOG
  L13 --> LOG
  L14 --> LOG
  L15 --> LOG
  X[Export PowerPoint<br/>deactivated]:::inactive
  classDef inactive stroke-dasharray: 5 5,opacity:0.55
~~~

Published export: [ga4-presentation-generator.json](../exports/ga4-presentation-generator.json).