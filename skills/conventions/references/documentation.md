# Documentation

Write documentation for the next agent or engineer. Keep each file short, factual, and current. Link to code instead of duplicating it.

## Root Files

- `AGENTS.md`: The index. Holds general instructions, commands, and links to the other documents. Read first, so keep it brief. If `CLAUDE.md` is needed, it only contains `@AGENTS.md`.
- `PRODUCT.md`: What is being built and why. Covers the purpose, users, core features, and scope, including what is out of scope.
- `DESIGN.md`: How it should look and feel. Covers the design system, tokens, components, and UI framework rules.
- `README.md`: The public overview for humans. Do not repeat agent instructions here.

Use these exact top-level headings:

- `AGENTS.md`: `# Agent Instructions`
- `PRODUCT.md`: `# Product Specifications`
- `DESIGN.md`: `# Design System`
- `docs/README.md`: `# Documentation Guidelines`

## Docs Folder

```text
docs/
|-- README.md
|-- decisions/
|   `-- 0001-<title>.md
|-- guides/
|   `-- <topic>.md
`-- plans/
    `-- <yyyy-mm-dd>-<title>.md
```

- `README.md`: A copy of this file's instructions, adapted to the project, so other developers and their agents follow them without this skill. Link it from `AGENTS.md`. Create it when setting up `docs/`, and keep it in sync when these instructions change.
- `decisions/`: Architecture decision records. One decision per file, numbered in order with kebab-case titles.
- `guides/`: How-to documents for recurring tasks, such as setup, deployment, and runbooks.
- `plans/`: Specs and plans for work in progress. Delete when the work lands; record any lasting choice as a decision.

## Decisions

- Record a decision when choosing between options, adding or removing a dependency or service, changing architecture, data, or APIs, or deviating from these conventions.
- Do not rewrite accepted decisions. Supersede them with a new record and update the old status to `Superseded by 0007`.
- Use the template below.

```markdown
# 0001. <Title>

- Status: Proposed | Accepted | Superseded by 0000
- Date: <yyyy-mm-dd>

## Context

The problem and constraints.

## Decision

What was chosen and the alternatives considered.

## Consequences

Trade-offs and follow-up work.
```

## Rules

- Put each document in one place only. Product goes in `PRODUCT.md`, design in `DESIGN.md`, decisions in `docs/decisions/`, how-tos in `docs/guides/`, and everything else is linked from `AGENTS.md`.
- Update the relevant document in the same change as the code it describes.
- Do not add other top-level documents or `docs/` folders without recording a decision.
