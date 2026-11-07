# Security and credentials

- Keep API keys, OAuth tokens, database passwords, service-account JSON, n8n encryption keys, and private endpoint URLs in the appropriate credential manager or local secret store. Never commit them.
- The checked-in workflow exports omit n8n credential references. Reassign credentials after import.
- Use TLS/SSL for Supabase PostgreSQL connections. Use separate least-privilege roles for ETL writes, assistant reads, and Metabase reads.
- PostgreSQL tools in an AI workflow should be read-only. Restrict the database role itself; a system prompt alone is not an authorization boundary.
- RLS being enabled does not necessarily constrain a privileged direct PostgreSQL role. Inspect the actual login role, grants, and policies.
- Keep n8n chat authentication enabled. Avoid public/anonymous dashboard sharing.
- Credential-free does not mean safe for public release. Workflow exports and test evidence can still contain live resource identifiers, including Google Drive/Slides IDs, cloud project names, and n8n instance metadata. Replace them with placeholders or remove live links before external sharing.
- Review workflow JSON diffs before committing or sharing exports. They can include SQL, expressions, prompts, instance-specific IDs, and accidental sample data. Keep source workflow backups private and sanitize only a separate export copy when preparing a public release.
