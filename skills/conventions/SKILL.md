---
name: conventions
description: Apply repository conventions when changing structure, configuration, documentation, or stack choices.
---

# Project Conventions

Use this skill when a task needs a decision about repository structure, tooling, documentation, or stack conventions. Inspect only the files relevant to that decision. Use Flexible mode unless the user explicitly requests Strict mode.

## Modes

- **Flexible (default)**: Fit applicable conventions into the existing structure and tooling. Preserve project choices and add only what the task needs.
- **Strict (explicit only)**: Enforce applicable conventions across the requested scope, including file moves or renames and related import, script, CI, and documentation updates.

## Routing

Read only the reference that matches the task:

- [Layout](references/layout.md) for directories, naming, file moves, or project boundaries.
- [Configuration](references/configuration.md) for commands, package managers, formatters, linters, ignore files, or environment templates.
- [Documentation](references/documentation.md) for README, AGENTS, PRODUCT, DESIGN, or maintained project docs.
- [Stack](references/stack.md) for framework, library, service, or tool choices.

When a reference conflicts with established project behavior, follow the project in Flexible mode. Preserve explicit user choices in either mode. Keep documentation current when a change affects behavior, structure, or setup.

## Project Examples

Consult these only when a comparable project shape helps resolve an ambiguity:

- [dentolos19/denizen](https://github.com/dentolos19/denizen): Standalone full-stack TypeScript application.
- [dentolos19/ecoprimers](https://github.com/dentolos19/ecoprimers): Standalone full-stack Python application.
- [dentolos19/facilix](https://github.com/dentolos19/facilix): Multi-project full-stack TypeScript application with a Python backend.
