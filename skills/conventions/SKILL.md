---
name: conventions
description: Applies the user's conventions for code, configuration, documentation, Git, layout, and stack. Use when writing code, configuring tooling, structuring projects, writing docs, or working with Git.
---

# Project Conventions

Start with the user's request and the current repository's instructions, nearby code, and tooling.

## Precedence

Decide whose repository it is before applying anything below.

- **My Repositories**: Those under the `dentolos19` GitHub account, or any repository whose history already follows these conventions. Keep the existing tooling and stack, such as npm or Vitest, until the user asks to migrate.
- **Other Repositories**: Team, work, or third-party repositories with their own established patterns. Follow the repository. Apply these conventions only where the repository has no pattern of its own. Only align strictly when explicitly asked.
- **New Projects**: Apply these conventions in full, starting from the closest reference project.

## Documentation References

Read only the references relevant to the task.

- [Code](references/code.md) for coding style.
- [Configuration](references/configuration.md) for editor configuration, ignore files, `.env` templates, the `Justfile`, etc.
- [Documentation](references/documentation.md) for writing style, documentation management, `README.md`, `AGENTS.md`, and skills.
- [Git](references/git.md) for commits, pull requests, issues, and GitHub repository settings.
- [Layout](references/layout.md) for directories and project structure.
- [Stack](references/stack.md) for framework, library, service, or tool choices.

## Reference Projects

Consult the closest project below to see the conventions applied. Read only the files relevant to the decision: source for coding style, manifests for tooling, workflows for delivery, or documentation for structure and wording. Look for local checkouts in sibling directories of the current repository or in `~/Projects/<name>` before fetching from GitHub. Treat these as examples to adapt, not files to copy wholesale; leave out dependencies, files, and workflows the project does not need. When a project copies configuration from a reference, it keeps the reference's key order, values, and formatting.

- [`dentolos19`](https://github.com/dentolos19/dentolos19): Shared configuration, templates, and agent guidance.
- [`denizen`](https://github.com/dentolos19/denizen): Single-project TypeScript web application.
- [`ecoprimers`](https://github.com/dentolos19/ecoprimers): Single-project Python web application.
- [`facilix`](https://github.com/dentolos19/facilix): Multi-project web application with TypeScript and Python.

If a reference is unavailable, use local evidence and reasonable defaults.
