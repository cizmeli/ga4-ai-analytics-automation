# Project Sync Notes

This file summarizes the public repository for future documentation updates. Keep project documentation in English. Do not add credentials, tokens, personal data, private identifiers, or private URLs.

## Project summary

This portfolio project uses anonymized historical GA4 sample data to demonstrate weekly analytics, dashboarding, AI-assisted analysis, and presentation generation. The data is historical demonstration data, not live business traffic.

The repository contains setup guidance, sanitized workflow exports, workflow guides, sample queries, and local configuration examples. Users must supply and configure their own services, credentials, and external assets.

## Current presentation export and runtime

The published, active Presentation Generator runtime contains 41 nodes, including seven presentation-recovery nodes and 16 serialized logging calls. The sanitized, inactive portable export contains 33 nodes: it omits those seven recovery nodes and the final (16th) logger call, leaving 15 logging calls. The export is not a node-for-node copy of the published runtime. See [the workflow guide](../workflows/docs/ga4-presentation-generator.md) for the behavior and verification limits.

On 2026-11-06, a real production run of the published Assistant → Presentation Generator → Log Writer flow created a new Slides deck for 2020-12-27 through 2021-01-02 rather than reusing a cached deck. All nine Presentation stages succeeded. Nineteen logger executions in the run window succeeded without retries, and the logger helper remains active. The Assistant final-response row succeeded with `updateRunRow=true`; a later `chat-trigger-start` row had `updateRunRow=false` and skipped Upsert Run Row, so it did not overwrite the completed run with stale-start data. This is runtime evidence for the published production path after the serial logger fix.

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

- 2026-11-06 — redacted public documentation, documented the 41-node published runtime versus the 33-node portable export in commit `74fc388`, and recorded cache-hit and pinned generated-branch verification with its limits.
- 2026-11-06 — documented a successful real new-presentation production run after the serial logger fix, including successful stage logging and stale-run protection, in commit `7aa56e4`.
- 2026-11-06 — clarified the portable export/runtime difference and the completed metadata-only Supabase audit boundary.
