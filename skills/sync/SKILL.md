---
name: sync
description: Compare and align a project's structure, configuration, and developer tooling with Dennise's best matching projects. Use when a project has drifted or should adopt proven conventions from other reference projects.
---

# Sync Project Conventions

Bring the current project in line with Dennise's strongest comparable projects. Treat reference projects as sources of proven conventions, not templates to copy blindly.

## Workflow

1. Inspect the current project before making changes. Read its local instructions, file tree, manifests, lockfiles, configuration files, scripts, CI workflows, deployment files, and Git status. Identify generated files and user changes that must remain untouched.
2. Inspect the selected reference projects at their current default branches. Use an existing local checkout when available. Otherwise, use read-only repository tools or clone into a temporary directory. Never modify a reference project.
3. Compare conventions that matter to the current stack:
   - Directory layout, file placement, naming, and import boundaries.
   - Package manager, dependency declarations, scripts, and lockfiles.
   - Formatter, linter, type checker, editor, environment, and Git configuration.
   - Testing, CI, deployment, container, and documentation layout when the target already uses them or the user requests them.
4. Build a concrete migration plan. For every proposed change, identify its reference project, why it fits the target, and whether it moves, merges, creates, or removes files. Separate shared conventions from choices tied to a reference project's product or infrastructure.
5. Apply minimal, coherent changes. Adapt paths, package names, commands, ports, environment variables, deployment targets, and framework versions to the current project. Preserve working behavior, public interfaces, secrets, project identity, and target-specific settings.
6. Update all affected references after moving or renaming files, including imports, scripts, workflows, documentation, ignore rules, and configuration paths. Use the package manager already established by the target project unless the user explicitly asks to migrate it.
7. Validate the result with the target project's existing formatter, linter, type checker, build, or other relevant checks. Do not add tests solely for the sync. Report checks that could not run and why.
8. Summarize the conventions adopted, their source projects, intentional differences, moved or removed files, and validation results.

## Decision Rules

- Follow explicit user choices over all reference projects.
- Prefer conventions shared by multiple relevant, maintained projects.
- When references disagree, choose the convention that best matches the target's current stack and versions. Do not combine incompatible approaches.
- Copy configuration semantics and property ordering when they apply, but retain target-specific entries and supported options.
- Do not introduce a dependency, service, workflow, or deployment platform merely because a reference project uses it.
- Do not overwrite secrets or copy secret values. Merge variable names into `.env.template` and use double-quoted placeholder values.
- Base `.gitignore` changes on the relevant files from `dentolos19/dentolos19/gitignores`, then retain required project-specific ignores such as `.next/`, `.tanstack/`, and `.wrangler/`.
- Do not delete files, replace a package manager, or perform a broad directory migration unless the user requested that scope or approved the migration plan.
- Preserve unrelated working-tree changes. Do not commit or push unless the user explicitly asks.

## Reference Projects

Prefer reference projects named by the user. Otherwise, choose the closest default based on the current project's language, framework, runtime, and deployment model:

- Use `dentolos19/denizen` for a standalone React application with an integrated TypeScript backend, including TanStack Start projects.
- Use `dentolos19/ecoprimers` for a standalone Python web application, including Flask and Django projects.
- Use `dentolos19/facilix` for a React application with an integrated Python backend.

Use more than one reference when each has a relevant strength. If no reference is a confident match, explain what is missing and ask the user to choose a project before changing files.
