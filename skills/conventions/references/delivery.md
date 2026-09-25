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
- For Cloudflare Workers, name the workflow `Cloudflare Deployment` and the job and deployment step `Deploy Worker`.
- Preserve each workflow's existing concurrency policy. Do not copy concurrency settings from a reference project.
- Use established actions such as `actions/checkout@v4`, `actions/setup-node@v6`, `oven-sh/setup-bun@v2`, and `extractions/setup-just@v4` where applicable. Set up uv or .NET when the project's recipes need them.
- Install Just only when the workflow runs a `just` command.
- Run `just deploy` as the Cloudflare deployment step. The recipe installs frozen dependencies, builds when applicable, uploads Worker secrets with `wrangler secret bulk`, and runs `wrangler deploy`; do not repeat these commands or use a second Worker deployment action in the workflow.
- Pass Cloudflare credentials at the job level and build inputs and Worker secret values to the deployment step. Preserve existing secret and variable names.
- Run migrations separately with `just migrate` after deployment when the project needs them, retaining its existing arguments and environment values.
- Set up every runtime used by `just deploy` before invoking it, including Node.js for the secret JSON command and Bun, uv, or .NET as applicable.
- Keep deployment timeouts appropriate to the project; use 60 minutes for the Cloudflare workflow unless its build needs longer.

## Database Migrations

- Recreate an unpublished migration only after checking whether it has been applied and reconciling the development database.

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
