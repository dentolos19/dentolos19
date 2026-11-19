---
name: handover
description: Packages the current task's context, decisions, progress, and relevant files into a handover document or zip bundle so another agent, harness, or person can continue the work without the original conversation. Use when asked to hand over, hand off, transfer, export, or checkpoint work for a different agent, session, tool, or machine.
---

# Handover

Produce a handover that lets a receiver with no access to this conversation continue the work correctly. Write for a capable stranger: state what is true now, what was decided and why, and what to do next. Prefer facts verified in the workspace over recollection.

## Choose The Output

- **Document**: a single `HANDOVER.md` when the receiver can access the same repository or workspace. This is the default.
- **Bundle**: a zip containing `HANDOVER.md`, copies of relevant files, and a patch of uncommitted changes when the receiver works elsewhere, lacks repository access, or needs files outside version control.

Follow the user's choice when given. Name the target agent or harness when known and adapt to it, for example by pointing to `CLAUDE.md`, `AGENTS.md`, or equivalent instruction files the receiver should read.

Write output to `.tmp/handover/` in the working directory unless the user names another location.

## Gather Context

Collect only what the receiver needs to act:

- The original request, goal, and success criteria in the user's own words where possible.
- Current state: what is done, in progress, and not started. Check `git status`, recent commits, and the diff rather than relying on memory.
- Decisions made, alternatives rejected, and the reasons. Include user preferences and constraints stated during the session.
- Relevant files with a one-line purpose each, plus key commands to build, run, and test.
- Environment and dependencies: runtimes, services, required environment variable names, and setup steps.
- Known issues, failed approaches, gotchas, and open questions awaiting the user.
- Concrete next steps in priority order.

## Write The Document

Use the structure in [Template](references/template.md). Omit sections that do not apply rather than filling them with placeholders. Keep it concise: link to files instead of pasting large contents, and quote only the snippets that carry a decision.

Distinguish clearly between verified facts, assumptions, and unknowns. Never report unfinished or untested work as complete.

## Build A Bundle

When producing a zip, run the bundled script with the files the receiver needs:

```bash
python3 scripts/bundle.py --document .tmp/handover/HANDOVER.md --output .tmp/handover/handover.zip [--patch] [paths ...]
```

`--patch` adds `changes.patch` with uncommitted tracked and untracked changes. Paths keep their structure relative to the working directory under `files/`. The script writes `MANIFEST.txt` listing every included file.

## Protect Sensitive Data

Exclude credentials, tokens, private keys, `.env` files, signed URLs, and personal data from both the document and the bundle. Reference secrets by variable name and where to obtain them. Review the file list before packaging and tell the user if anything was excluded for this reason.

## Deliver

Return the output path, the chosen format, a short summary of what it contains, and anything deliberately left out. Offer to send or upload it only if the user asks; sharing it externally requires their confirmation.
