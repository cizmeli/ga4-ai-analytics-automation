# Project Sync Notes

This file summarizes the public repository for future documentation updates. Keep project documentation in English. Do not add credentials, tokens, personal data, private identifiers, or private URLs.

## Project summary

This portfolio project uses anonymized historical GA4 sample data to demonstrate weekly analytics, dashboarding, AI-assisted analysis, and presentation generation. The data is historical demonstration data, not live business traffic.

The repository contains setup guidance, sanitized workflow exports, workflow guides, sample queries, and local configuration examples. Users must supply and configure their own services, credentials, and external assets.

## Current presentation export

The sanitized Presentation Generator export contains 33 nodes and is inactive for portable use. Its behavior is documented at [workflows/docs/ga4-presentation-generator.md](../workflows/docs/ga4-presentation-generator.md).

The existing runtime cache-hit path was verified. The generated-presentation path has not been rerun on the current workflow version. A clean n8n import has not been validated; do not describe the export as import-tested.

## Repository map

- `README.md` — project overview, safe setup summary, and validation notes.
- `workflows/exports/` — sanitized portable workflow files.
- `workflows/docs/` — public workflow guides.
- `prompts/` and `sql/` — example prompts and analytics references.
- `docs/` — setup, security, status, and project notes.
- `docker/` and `.env.example` — local configuration examples.

## Update guidance

1. Check the current repository and relevant public artifacts before changing documentation.
2. Describe behavior at a public, user-facing level. Avoid publishing internal workflow topology, private identifiers, credential details, personal data, or private links.
3. Distinguish configured behavior from sanitized examples and state what was actually verified.
4. Do not claim workflow imports, generated-presentation runs, or other checks unless they were performed on the documented version.
5. Keep changes limited to the documentation that needs to stay aligned with current public artifacts.

## Update log

- 2026-11-06 — redacted public documentation and corrected the Presentation Generator export count to 33 nodes. Documented the verified cache-hit path and current validation limits.
