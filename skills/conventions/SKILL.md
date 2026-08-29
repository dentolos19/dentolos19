---
name: conventions
description: Create, restructure, or align projects using Dennise's conventions. Use when creating a new project or when the user asks.
---

# Project Conventions

Use them as defaults for new projects and when aligning existing ones. Explicit user decisions, local instructions, and compatibility requirements override them. Do not refactor working code only to match an example.

## Core Defaults

- Put a `Makefile` at the repository root and make it the canonical human-facing interface. Every project provides `make setup`, `make start`, and `make check`. `make start` starts every process required for the repository's normal local development. Read [references/makefiles.md](references/makefiles.md) before creating or changing project commands.
- Model independently runnable or deployable processes as project boundaries. Keep a single application at the repository root. For a mixed-runtime system, use `src/app` for the TypeScript application, `src/server` for the Python backend or container, and `src/<role>` for additional processes such as `src/simulator`.
- Give every project boundary its own manifest, lockfile, runtime configuration, ignore rules, and deployment files. Do not create a synthetic root package workspace when the services do not share packages.
- Use Bun for JavaScript and TypeScript and commit `bun.lock`. Use uv for Python and commit `uv.lock`. Do not also maintain npm, pnpm, pip, Poetry, or `requirements.txt` metadata for the same project.
- Keep the repository root lean. It owns orchestration and repository-wide material such as the `Makefile`, `.github`, root ignore rules, `compose.yml`, license, and `/docs`. Product code belongs inside its application boundary.
- Store secrets only in ignored environment files or the deployment platform. Provide `.env.template` when variables require documentation, and double-quote every template value, including empty placeholders.
- Strictly synchronize equivalent names across code, configuration, workflows, commands, and documentation. When variants conflict, use the shorter, more generic name unless an external interface requires another name.

## Convention Routing

Read only the references relevant to the task:

- Read [references/layouts.md](references/layouts.md) whenever creating, restructuring, or reviewing project boundaries and file placement.
- Read [references/makefiles.md](references/makefiles.md) whenever creating or changing commands, development startup, onboarding, documentation, or repository orchestration.
- Read [references/typescript.md](references/typescript.md) for a JavaScript, TypeScript, React, TanStack Start, Drizzle, or Cloudflare Worker project.
- Read [references/python.md](references/python.md) for a Python application, web service, CLI, worker, or simulator.
- Read [references/delivery.md](references/delivery.md) when environment files, ignore files, Docker, Compose, editor launch settings, GitHub Actions, Cloudflare, or Fly.io are in scope.

## Workflow

1. Inspect the current repository before changing it. Read local instructions, Git status, the file tree, manifests, lockfiles, the `Makefile`, environment templates, runtime configuration, workflows, deployment files, and relevant documentation.
2. Identify the actual process and deployment boundaries. Choose the smallest layout that represents those boundaries; do not split a single application or combine independently deployed services for visual symmetry.
3. Compare the project with the applicable conventions. Separate missing conventions from intentional product, framework, platform, and compatibility differences.
4. For an existing project, propose broad moves, package-manager migrations, deletions, or boundary changes before applying them. For a new project, establish the selected layout and root `Makefile` from the beginning.
5. Keep package-native commands behind the Make interface. Update documentation, editor launch settings, CI paths, imports, generated-file rules, deployment configuration, and environment templates whenever structure or commands change.
6. Run `make check`, then any relevant existing build or type-generation command. Do not add a test suite merely to satisfy the convention, and do not run tests or browser tests unless the user requested them. Never deploy, publish, push, or trigger a remote workflow without explicit authorization.
7. Report the selected project shape, Make targets, project boundaries, intentional deviations, and validation results.

## Guardrails

- Preserve project identity, behavior, APIs, data, secrets, deployment targets, and unrelated working-tree changes.
- Do not introduce a database, framework, service, container, cloud platform, or dependency unless the project actually needs it.
- Do not copy product-specific ports, domains, account IDs, database IDs, bucket names, environment variables, or infrastructure settings from another project.
- Do not overwrite an existing `.env` file or copy a secret value into source control.
- Keep remote migration and deployment targets explicit. A plain `make migrate` is local by default; use a clearly named remote target only when the project needs one.
- Do not commit or push unless the user explicitly asks.
