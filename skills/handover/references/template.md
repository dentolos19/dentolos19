# Handover Template

Use this structure for `HANDOVER.md`. Remove sections that do not apply.

```markdown
# Handover: <task title>

- **Date**: <YYYY-MM-DD>
- **From**: <agent or harness and model, if known>
- **To**: <target agent, harness, or person, if known>
- **Repository**: <path or URL> at `<branch>` / `<commit>`

## Goal

<What the user wants and how success is judged. Quote the original request when it matters.>

## Current State

- **Done**: <completed work, with commits or files>
- **In progress**: <partial work and exactly where it stopped>
- **Not started**: <remaining scope>

## Decisions

- <Decision> — <reason>. Rejected: <alternative> because <reason>.

## Constraints And Preferences

- <User instructions, conventions, and boundaries the receiver must respect.>

## Relevant Files

- `<path>` — <purpose and what changed>

## Environment

- **Setup**: <install and run commands>
- **Verify**: <test or check commands>
- **Variables**: <names only, and where to obtain values>

## Known Issues

- <Bugs, failed approaches, and gotchas, with what was tried.>

## Open Questions

- <Decisions awaiting the user or information still missing.>

## Next Steps

1. <Most important next action.>
2. <Following action.>

## Bundle Contents

<Only for zip bundles: what is in `files/`, whether `changes.patch` is included, and how to apply it with `git apply changes.patch`.>
```
