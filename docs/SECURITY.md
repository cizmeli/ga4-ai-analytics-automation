# Security and credentials

- Keep API keys, OAuth tokens, database passwords, service-account JSON, n8n encryption keys, and private endpoint URLs in the appropriate credential manager or local secret store. Never commit them.
- The checked-in workflow exports omit n8n credential references. Reassign credentials after import.
- Use TLS/SSL for Supabase PostgreSQL connections. Use separate least-privilege roles for ETL writes, assistant reads, and Metabase reads.
- PostgreSQL tools in an AI workflow should be read-only. Restrict the database role itself; a system prompt alone is not an authorization boundary.
- RLS being enabled does not necessarily constrain a privileged direct PostgreSQL role. Inspect the actual login role, grants, and policies.
- Keep n8n chat authentication enabled. Avoid public/anonymous dashboard sharing.
- Workflow exports refer to Google assets through placeholder IDs; reconnect to assets you control after import.
- Review workflow JSON diffs before committing future exports. They can include SQL, expressions, prompts, IDs, and accidental sample data.
