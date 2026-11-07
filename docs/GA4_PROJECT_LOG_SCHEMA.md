# GA4 Project Log Writer — Verified Sheet Headers

The live Google Sheet **GA4 Analytics Project Log** was inspected on 2026-11-07. It contains five tabs. The lists below reproduce the visible row 1 headers exactly and in order. This is a header inventory only; no extra columns or inferred field definitions are included.

## Runs

1. `event_key`
2. `Run / execution ID`
3. `Workflow`
4. `Mode`
5. `Run time (UTC)`
6. `Date range`
7. `Prompt version`
8. `Workflow version`
9. `Model`
10. `Cache`
11. `Status`
12. `Save mode`
13. `Saved rows`
14. `Source report`

## Stage Log

1. `event_key`
2. `Execution ID`
3. `Workflow`
4. `Prompt version`
5. `Stage`
6. `Timestamp (UTC)`
7. `Duration`
8. `Status`
9. `Input count`
10. `Output count`
11. `Sanitized error summary`
12. `Source report`

## KPI Values

1. `event_key`
2. `Run ID`
3. `Workflow`
4. `Prompt version`
5. `Period`
6. `Metric`
7. `Current value`
8. `Prior value`
9. `Change`
10. `Source`

## Evaluations

1. `event_key`
2. `Case / week`
3. `Execution ID`
4. `Workflow`
5. `Prompt version`
6. `Workflow version`
7. `Evidence score`
8. `Insight score`
9. `Recommendation score`
10. `Overall score`
11. `Score basis`
12. `Hard-gate outcomes`
13. `Finding / summary`
14. `Artifact reference`

## Changes & Backups

1. `event_key`
2. `Workflow`
3. `Workflow ID`
4. `Approval / date`
5. `Change summary`
6. `Before version`
7. `After version`
8. `Backup path`
9. `SHA-256`
10. `Review / test status`

## Scope and handling

The helper workflow export and workbook binding are not included in this repository. Keep workbook identifiers and Google Sheets credentials in the connected services. The repository's workflow exports do not consistently include the later logging calls; confirm the exact target workflow version before relying on them.
