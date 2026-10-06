---
name: conventions
description: Adapt project conventions when working on code, structure, stack, or Git.
---

# Project Conventions

Start with the user's request and the current repository's instructions, nearby code, and tooling. Preserve established patterns unless the task calls for changing them.

## Documentation References

Read the documentation below for the conventions and patterns to use.

- [Code](references/code.md) for coding preferences.
- [Configuration](references/configuration.md) for project configurations.
- [Git](references/git.md) for commit rules, issue/PR writing, features, and GitHub settings.
- [Layout](references/layout.md) for directories, structuring, naming, or project boundaries.
- [Stack](references/stack.md) for framework, library, service, or tool choices.

## Project References

Consult the closest project below for guidance on applying the conventions. Read only the files relevant to the decision: source for coding style, manifests for tooling, workflows for delivery, or documentation for structure and wording. Use local checkouts when available. Treat these as examples to adapt. Choose what fits the project's scale, stack, and constraints; avoid importing unrelated dependencies, files, or workflows. For new projects, use the closest example as a starting point. If a reference is unavailable, use local evidence and reasonable defaults.

- [`dentolos19`](https://github.com/dentolos19/dentolos19): Shared configuration, templates, and agent guidance.
- [`denizen`](https://github.com/dentolos19/denizen): Single-project TypeScript web application.
- [`ecoprimers`](https://github.com/dentolos19/ecoprimers): Single-project Python web application.
- [`facilix`](https://github.com/dentolos19/facilix): Multi-project web application with TypeScript and Python.

## Convention Rules

- When copying over a configuration from a project or reference, strictly follow the same order of keys, values, and formatting.
