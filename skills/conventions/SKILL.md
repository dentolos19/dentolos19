---
name: conventions
description: Create, restructure, or align projects using Dennise's conventions. Use when creating a new project or when the user asks.
---

# Project Conventions

Use them as defaults for new projects and when aligning existing ones. Explicit user decisions, local instructions, and compatibility requirements override them. Do not refactor working code only to match an example.

## Workflow

1. Inspect the current repository before changing it. Read local instructions, Git status, the file tree, manifests, lockfiles, the Makefile, environment templates, runtime configuration, workflows, deployment files, and relevant documentation.
2. Identify the actual process and deployment boundaries. Choose the smallest layout that represents those boundaries; do not split a single application or combine independently deployed services for visual symmetry.
3. Compare the project with the applicable conventions. Separate missing conventions from intentional product, framework, platform, and compatibility differences.
4. For an existing project, propose broad moves, package-manager migrations, deletions, or boundary changes before applying them. For a new project, establish the selected layout and root Makefile from the beginning.
5. Keep package-native commands behind the Make interface. Update documentation, editor launch settings, CI paths, imports, generated-file rules, deployment configuration, and environment templates whenever structure or commands change.
6. Run make check, then any relevant existing build or type-generation command. Do not add a test suite merely to satisfy the convention, and do not run tests or browser tests unless the user requested them. Never deploy, publish, push, or trigger a remote workflow without explicit authorization.
7. Report the selected project shape, Make targets, project boundaries, intentional deviations, and validation results.

## Core Defaults

- Put a `Makefile` at the repository root and make it the canonical human-facing interface.
- Keep a single application at the repository root. For a mixed-runtime system, use `src/app` for the frontend, `src/server` for the backend, and `src/<role>` for additional processes (e.g., `src/simulator`).

## Convention Routing

Read only the references relevant to the task:

- Read [references/layout.md](references/layout.md) whenever creating, restructuring, or reviewing project structure.
- Read [references/makefile.md](references/makefile.md) whenever creating or changing commands, development startup, onboarding, documentation, or repository orchestration.
- Read [references/delivery.md](references/delivery.md) when environment files, ignore files, Docker, Compose, editor launch settings, GitHub Actions, Cloudflare, or Fly.io are in scope.
- Read [references/typescript.md](references/typescript.md) for a JavaScript, TypeScript, React, or Cloudflare Worker project.
- Read [references/python.md](references/python.md) for a Python application, web service, or CLI project.
