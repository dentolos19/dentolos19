---
name: sync
description: Compare and align a project's structure, configuration, developer tooling, and automation workflows with Dennise's best matching projects. Use when a project has drifted or should adopt proven conventions from other reference projects.
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
   - Testing, deployment, container, and documentation layout when the target already uses them or the user requests them.
   - Automation workflow files and their structure under locations such as `.github/workflows/` when the target has workflows, the selected reference has an applicable workflow, or the user requests workflow synchronization. Follow the strict workflow rules below.
4. Build a concrete migration plan. For every proposed change, identify its reference project, why it fits the target, and whether it moves, merges, creates, or removes files. Separate shared conventions from choices tied to a reference project's product or infrastructure.
5. Apply minimal, coherent changes. Adapt paths, package names, commands, ports, environment variables, deployment targets, and framework versions to the current project. Preserve working behavior, public interfaces, secrets, project identity, and target-specific settings.
6. Update all affected references after moving or renaming files, including imports, scripts, workflows, documentation, ignore rules, and configuration paths. Use the package manager already established by the target project unless the user explicitly asks to migrate it.
7. Validate the result with the target project's existing formatter, linter, type checker, build, or other relevant checks. Do not add tests solely for the sync. Report checks that could not run and why.
8. Summarize the conventions adopted, their source projects, intentional differences, moved or removed files, and validation results.

## Workflow Configuration Sync

Treat an applicable reference workflow as an ordered specification, not a loose example. For each target workflow, identify one authoritative workflow from the closest matching reference project. Do not blend workflows from different references unless they cover distinct responsibilities.

1. Inventory workflow files in the target and reference. Match them by purpose rather than filename alone, and identify reference-only or target-only workflows separately.
2. Compare each matched workflow from top to bottom, including:
   - Workflow filename and top-level key ordering.
   - Workflow `name`, event triggers and filters, permissions, concurrency, defaults, and top-level environment variables.
   - Job identifiers and job ordering.
   - Each job's display name, dependencies, conditions, permissions, runner, environment, strategy or matrix, services, container, timeout, and outputs.
   - Step names and exact step ordering.
   - Whether each step uses an action or a shell command; for actions, the action owner, repository, version or commit pin, and `with` inputs; for commands, the command, shell, working directory, and environment.
3. Make the target structurally match the authoritative workflow. Preserve the reference's workflow name, job names, step names, ordering, action choices, action versions, key ordering, and command style whenever the corresponding behavior applies. Do not silently rename, reorder, combine, split, replace, upgrade, or omit steps or actions for stylistic preference.
4. Adapt only values required by the target project's actual structure and requirements, such as package-manager commands, lockfile and cache paths, runtime versions, workspace paths, build artifacts, deployment identifiers, branch filters, matrices, secret names, and environment names. Derive adaptations from the target's manifests and configuration; do not guess.
5. Keep target-only steps or jobs only when required for target-specific behavior. Place them at the nearest semantically correct point without disturbing the relative order of reference-derived steps, and label them consistently with the reference. Record every retained addition as an intentional difference.
6. Do not copy a workflow, job, permission, secret, deployment action, or external service that is inapplicable to the target. If an omission is necessary, preserve the remaining relative order and record the omitted item and reason.
7. After editing, perform a second ordered comparison against the authoritative workflow. Account for every difference in filenames, keys, jobs, step names, order, actions, versions, inputs, commands, and conditions. Fix unexplained drift before finishing.
8. Validate workflow syntax and all locally verifiable commands or referenced paths using the project's existing tooling. Do not trigger, dispatch, deploy, publish, or otherwise run a remote workflow unless the user explicitly requested it.

## Decision Rules

- Follow explicit user choices over all reference projects.
- Prefer conventions shared by multiple relevant, maintained projects.
- When references disagree, choose the convention that best matches the target's current stack and versions. Do not combine incompatible approaches.
- Copy configuration semantics and property ordering when they apply, but retain target-specific entries and supported options.
- Workflow fidelity is stricter than general configuration similarity: exact names, ordering, actions, action versions, and step structure are defaults. Deviate only for a demonstrated target requirement, and report each deviation explicitly.
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
