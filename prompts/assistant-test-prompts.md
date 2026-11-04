# Manual AI Assistant checks

Run chat prompts from the authenticated n8n chat UI after importing the workflows and assigning least-privilege credentials. Confirm responses use tool output and state the actual historical reporting dates. Use manual workflow triggers for invalid-input and fault-injection checks in a disposable environment.

## Assistant prompts

- What are the latest complete-week KPIs?
- Which complete reporting week had the most purchases?
- How did revenue change from the previous complete reporting week?
- What was the purchase conversion rate in the latest complete week?
- How many unique users were there across all weeks? (Expected: explain that weekly distinct counts cannot be summed to produce a period-unique count.)
- Which device converted best? (Expected: explain that device-level data is unavailable until its table/tool exists.)
- Generate weekly insights for the week starting 2020-11-22. (Expected: return the saved report or generate it if the snapshot is new; do not create slides unless asked.)
- Generate a Google Slides presentation for the latest saved weekly report. (Expected: create a deck or reuse the cached deck for that report version; return only the workflow-provided link.)
- Generate insights for 2020-11-22 and create a slide deck. (Expected: call both tools because slides were explicitly requested.)
- Generate insights for 2020-10-25. (Expected: explain that no eligible complete-week comparison exists and return `not_found`; do not invent an analysis.)
- Generate reports for every historical week automatically. (Expected: explain that an on-demand request can target an eligible complete week, while the Weekly ETL schedule is inactive.)

## Workflow-level cache and error checks

- Invoke Weekly AI Insights with `requested_week=not-a-date`. Expected: the current SQL date cast fails at **Get Weekly Comparison** with a database parsing error; later nodes do not run.
- Invoke Weekly AI Insights for a week whose saved `week_start` and `metrics_snapshot` match. Expected: return `status=cached`; skip the insights-generation LLM and save node.
- Pin a malformed Copy Presentation Template result without an `id`. Expected: stop at **Prepare Presentation Fields** with `Copied presentation ID is missing`; no Slides update or save.
- In a disposable test, pass a fake Slides ID. Expected: provider 404 before **Save Presentation Record**.
- Ask for insights only and inspect the assistant execution. Expected: no presentation tool/subexecution. A cache hit may still run the assistant's own routing/model while skipping the insights-generation LLM.

Existing execution evidence is listed in [project status](../docs/STATUS.md). The referenced executions are existing history, not fresh runs from this documentation update.

## Read-only execution inspection

These commands list and inspect executions; they do not trigger workflows. Use the instance-specific workflow ID locally.

```sh
/opt/homebrew/bin/n8n-cli workflow list --name=GA4 --format=table --limit=10
/opt/homebrew/bin/n8n-cli execution list --workflow=<workflow-id> --limit=10 --format=table
/opt/homebrew/bin/n8n-cli execution get <execution-id> --format=table
```
