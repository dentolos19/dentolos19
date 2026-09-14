# Delivery

Use this reference when updating dependencies, changing deployment automation, verifying a project, or delivering Git changes. Preserve working project behavior and make the smallest compatible update.

## Dependencies

- Use the package manager already established by the project.
- For Bun projects, use `bun update` to refresh compatible dependencies and the lockfile.
- For Python projects, use `uv lock --upgrade` and keep `.python-version` aligned with the supported interpreter.
- For .NET projects, update compatible non-major package versions and restore the project.
- Set `@types/node` and `@types/bun` to `latest` wherever they are declared and applicable.
- Treat a `0.x` minor upgrade as potentially breaking. Keep the existing minor line unless project verification establishes compatibility.
- Do not use dependency updates as an excuse for an unrelated framework migration.

## Deployment Workflows

- Use `Production` as the deployment environment name.
- Use established current actions such as `actions/checkout@v4`, `actions/setup-node@v6`, `oven-sh/setup-bun@v2`, `extractions/setup-just@v4`, and `cloudflare/wrangler-action@v4` where applicable.
- Install Just only when the workflow runs a `just` command.
- Route workflow commands through existing Just recipes, such as `just build` or `just migrate`, when those recipes represent the same operation.
- Install Bun dependencies with `bun install --frozen-lockfile` in CI.
- Preserve existing secret and variable names unless their values are available for a coordinated migration.
- Keep workflow names descriptive, such as `Web Deployment`, and name the deployment step for its target, such as `Deploy Worker`.

## Verification

- Run `just check` when the repository provides it. Fix errors and actionable warnings at their shared cause instead of suppressing rules.
- Verify updated lockfiles with the native package manager.
- Run a production build for deployable applications and a deployment dry run when the platform supports one without changing remote state.
- Run `git diff --check` before delivery.
- Do not commit, amend, push, deploy, or change remote settings unless the user requests that operation.

## Git Delivery

- Create one commit per repository when the user requests commits across multiple projects.
- Use the exact commit subject supplied by the user.
- Fetch before pushing and use a normal fast-forward push for new commits.
- Use `--force-with-lease` only when pushing explicitly requested amended history.
- Report repositories without configured remotes instead of inventing a destination.
