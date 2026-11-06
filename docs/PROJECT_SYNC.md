# Project Sync Notes

This file summarizes the public repository for future documentation updates. Keep project documentation in English. Do not add credentials, tokens, personal data, private identifiers, or private URLs.

## Project summary

This portfolio project uses anonymized historical GA4 sample data to demonstrate weekly analytics, dashboarding, AI-assisted analysis, and presentation generation. The data is historical demonstration data, not live business traffic.

The repository contains setup guidance, sanitized workflow exports, workflow guides, sample queries, and local configuration examples. Users must supply and configure their own services, credentials, and external assets.

## Current presentation export and runtime

The published, active Presentation Generator runtime contains 41 nodes, including seven presentation-recovery nodes and 16 serialized logging calls. The sanitized, inactive portable export contains 33 nodes: it omits those seven recovery nodes and the final (16th) logger call, leaving 15 logging calls. The export is not a node-for-node copy of the published runtime. See [the workflow guide](../workflows/docs/ga4-presentation-generator.md) for the behavior and verification limits.

The active runtime reused an existing presentation for the requested week after the logging serialization change; expected presentation and assistant stage log events were written, and no new Slides file or presentation database record was created. A pinned generated-branch test wrote the expected log events and a run row, then reached its final response with mocked Drive and database outputs. It did not create real Slides or database records. The current published generated-presentation path has not had a real new-presentation run after that change; the earlier real generation run was on an older build.

The export has not been re-imported into a clean n8n instance. Do not describe it as import-tested.

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

- 2026-11-06 — redacted public documentation, corrected the Presentation Generator export count to 33 nodes, and recorded cache-hit and pinned generated-branch verification with its limits.
- 2026-11-06 — updated the status and presentation guide for serialized logger behavior and current runtime verification.
