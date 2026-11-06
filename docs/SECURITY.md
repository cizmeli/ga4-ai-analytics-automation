# Security and credentials

- Keep API keys, OAuth tokens, database passwords, service-account JSON, n8n encryption keys, and private endpoint URLs in an appropriate credential manager or local secret store. Never commit them.
- Workflow exports omit n8n credential bindings. Reassign credentials after import.
- Sanitized workflow exports are inactive portable copies, not exact copies of every published graph. The Presentation Generator export has 33 nodes; the published runtime has 41, including seven presentation-recovery nodes and a final (16th) logger call omitted from the export. Rebind external resource references after import and do not assume the export reproduces the full published behavior.
- The active Project Log Writer is documented, but its portable workflow export is intentionally not included in this public repository.
- The active Project Log Writer sends sanitized, allowlisted run, stage, and aggregate KPI summaries to its configured Google Sheets destination. This is an external write; do not point a test import at the live log sheet.
- Do not store prompts, raw node inputs/outputs, credential values, or personal data in execution logs. Review any change to the logging allowlist before publishing.
- Use TLS/SSL for Supabase PostgreSQL connections. Use separate least-privilege roles for ETL writes, assistant reads, and Metabase reads.
- PostgreSQL tools in an AI workflow should be read-only. Restrict the database role itself; a system prompt alone is not an authorization boundary.
- RLS being enabled does not necessarily constrain a privileged direct PostgreSQL role. Inspect the actual login role, grants, and policies.
- Keep n8n chat authentication enabled. Avoid public or anonymous dashboard sharing.
- This repository is public. Never commit private identifiers, live data, unredacted execution logs, or secret-bearing exports.
- Review workflow JSON diffs before committing. They can contain SQL, expressions, prompts, identifiers, and sample data.