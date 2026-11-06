# Setup guide

## Prerequisites

- Docker Desktop, n8n, and a Google Cloud project where BigQuery access is enabled.
- Access to the public bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_* dataset.
- A Supabase PostgreSQL project.
- Google Drive and Slides assets you control.
- Google Sheets access for the shared Project Log Writer.
- Metabase OSS if you want the local dashboard.

## Configure n8n

1. Create a PostgreSQL credential for Supabase using the Session Pooler host/user shown in the Supabase Connect panel, port 5432, database postgres, and SSL enabled. Do not put the password in this repository.
2. Add Google BigQuery, Google Drive/Slides, and Google Sheets credentials in n8n's credential store.
3. Import one sanitized JSON from workflows/exports/ at a time. Every portable export has active=false; assign credentials to matching nodes.
4. Replace the presentation-template, Google Sheets document, BigQuery project, and called-workflow references with resources in your own instance.
5. The live Project Log Writer is documented, but its portable export is intentionally not included in this public repository. Configure a separate helper in your own n8n instance before connecting test workflows to a test spreadsheet.
6. Confirm node parameters and expressions against your n8n version. The exports are portable starting points, not turnkey credentials.
7. Keep the ETL schedule disabled. The historical sample period is already loaded, and the source ETL is inactive. Do not enable a schedule unless the source data and reload plan change.

## Step 30 logging prerequisite

The four included workflow exports contain 35 Step 30 calls to the Project Log Writer helper. Every call uses the `SELECT_WORKFLOW_AFTER_IMPORT` placeholder because the helper workflow export is not included in this public repository. Logger calls now continue on error: an unresolved helper can leave a log entry missing, but does not stop the parent workflow.

Before running an imported workflow, choose one option:

1. Install and configure your own Project Log Writer helper, then select it in every Step 30 node to replace the `SELECT_WORKFLOW_AFTER_IMPORT` placeholder. Configure its spreadsheet destination and credentials in your own n8n instance.
2. If you do not want logging, disable or remove every Step 30 call in that imported workflow before running it.

Connect your own helper before running if you want log entries. Unresolved references are safe for the main flow, but those log entries will be absent. Verify the references in each imported workflow; the helper calls are independent of the assistant's GA4 data tools.

## Database

sql/schema.sql is an example of the tables used by the assistant and presentation workflows. Inspect existing tables, constraints, and grants before applying DDL. The live database grants and RLS have not been audited in this documentation pass.

## BigQuery period query

The ETL export contains the current inactive configuration. It uses week_start and week_end returned by Supabase and bounds _TABLE_SUFFIX to the requested interval. The historical sample range is exhausted; test any future range changes in a disposable copy.

## Step 32 draft

sql/ga4-weekly-insights-v6-draft.sql is a read-only, unpublished query draft. It is not part of the published workflow export and must not be treated as the active n8n query.

## Metabase

Use the sample in docker/compose.yaml for a local demo only. Connect a dedicated PostgreSQL role with SELECT access. The observed local dashboard URL is http://localhost:3001; keep authentication enabled.

## After import

- Test the assistant with non-sensitive sample questions.
- Confirm the assistant excludes partial periods from full-week comparisons.
- Test on-demand insight generation only against a disposable/test period.
- Manually request slide generation once and inspect the copied file and cached URL.
- Keep the execution log pointed at a non-production spreadsheet until the field allowlist is reviewed.