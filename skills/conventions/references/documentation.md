# Documentation

Write documentation for the next agent or engineer. Keep each file short, factual, and current. Link to code instead of duplicating it.

## Writing Style

- Use American English.
- Use Title Case for headings and short phrases, such as link text and table headers.
- End full sentences with periods, including in bullets. Leave fragments, such as link lists and prerequisites, without periods.
- Use bold sparingly for key terms, with punctuation outside the markers: `**Key Term**: Content`.

## Root Files

- `README.md`: The public overview for humans. See [README.md](#readmemd).
- `AGENTS.md`: The index. It holds general instructions, commands, and links to the other documents. It is read first, so keep it brief. If `CLAUDE.md` is needed, it contains only `@AGENTS.md`.
- `PRODUCT.md`: What is being built and why. It covers the purpose, users, core features, and scope, including what is out of scope.
- `DESIGN.md`: How it should look and feel. It covers the design system, tokens, components, and UI framework rules. Create it only for projects with a user interface.

Use these exact top-level headings:

- `AGENTS.md`: `# Agent Instructions`
- `PRODUCT.md`: `# Product Specifications`
- `DESIGN.md`: `# Design System`
- `docs/README.md`: `# Documentation Guidelines`

## `README.md`

`README.md` is the public overview for humans. Link to `AGENTS.md`, `PRODUCT.md`, `DESIGN.md`, and `docs/README.md` instead of repeating them.

### Structure

Use the sections below in this order, omitting any that do not apply.

```markdown
<img alt="<Project Name>" src="banner.png">

---

<One or two short paragraphs: what the project does, who it is for, and its core approach.>

## Features

- **<Area>**: <What it does.>

## Tech Stack

- [<Framework>](<official url>) <and what it is used for>.

## Getting Started

### Prerequisites

- [<Tool>](<official url>) <minimum version> or newer

### Setup

1. <Copy `.env.template` to `.env` and fill in the keys.>
2. <Run `just setup`.>
3. <Run `just start` and open the local URL.>

## Documentation

- [<Guide Title>](docs/guides/<topic>.md)

## License

Licensed under the [MIT License](LICENSE).
```

- Keep feature bullets to one line each.
- Treat `### Setup` as the canonical quick start. Do not repeat it in a guide; write guides only for what goes beyond it.
- Put each setup command in its own fenced block under its step.
- Link the project's actual license, and omit `## License` when there is none.

### Banner

- Save it at the repository root as `banner.png`.
- Render at 2560x640, a 4:1 ratio drawn at 1280x320 and scaled 2x for high-density displays.
- Compose it for the banner format instead of cropping or fading an existing image. Build it as HTML or SVG.
- Use only the project name as the `alt` text.

## Agent Instructions

Structure `AGENTS.md` as below. Omit `## Rules` when there are none, and add a section for a project-specific tool, such as Effect, only when agents need it.

```markdown
# Agent Instructions

<One or two sentences on what the project is and where it runs.>

## Commands

- `just setup`: <What it does.>
- `just start`: <What it does.>

## Stack

<One sentence naming the frameworks, services, and tools.>

## Rules

- <Project-specific rule that agents would otherwise get wrong.>

## Documentation

- [Product Specifications](PRODUCT.md)
- [Design System](DESIGN.md)
- [Documentation Guidelines](docs/README.md)
- [<Guide Title>](docs/guides/<topic>.md)
```

- List every `Justfile` recipe in `Justfile` order.
- Under `## Documentation`, link to guides, not individual decisions or plans. A rule may link to the decision it comes from.

## Documentation Folder

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

- `README.md`: Copied instructions from this file so other developers and their agents follow them without this skill. Link it from `AGENTS.md`. Create it when setting up `docs/`, and keep it in sync when these instructions change.
- `decisions/`: Architecture decision records. One decision per file, numbered in order with kebab-case titles.
- `guides/`: How-to documents for recurring tasks, such as setup, deployment, and runbooks. Title each with a Title Case `#` heading.
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

## Skills

When authoring or revising skills, `AGENTS.md`, or task prompts, follow the [Skill Authoring Best Practices](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices). Write third-person descriptions that state what the skill does and when to use it, keep `SKILL.md` concise, load detailed guidance from references only when relevant, and define outcomes and boundaries without prescribing unnecessary steps.
