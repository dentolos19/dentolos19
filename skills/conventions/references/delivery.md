# Environment, Containers, And Delivery

Apply these conventions only to the deployment and local orchestration mechanisms the project actually uses.

## Environment Files

- Ignore `.env*` and explicitly allow `!.env*.template`.
- Put an environment template beside the application boundary that owns the variables. Use a root template only for variables genuinely shared by root orchestration.
- Double-quote all template values, including empty placeholders.
- Keep generic application and client variables at the top, such as `DATABASE_URL` and `VITE_API_URL`.
- Group the remaining variables by provider or library and purpose, using headings such as `# Neon (Database)`, `# Cloudflare (Storage)`, and `# Better Auth (Authentication)`.
- Sort variables within each group.
- Separate public build variables, runtime configuration, and secrets according to the framework and platform. Never expose a secret through a browser-visible prefix.
- Do not overwrite an existing environment file during `make setup`.

## Ignore Files

Build ignore files from the maintained templates in `dentolos19/dentolos19/gitignores` when that repository is available. Preserve the section order: editor configuration, build or cache files, user files, project files, then miscellaneous files.

For a single-stack repository, keep the relevant stack rules at the root. For a mixed repository, use the general rules at the root and stack-specific `.gitignore` files inside each project boundary.

Web projects normally ignore:

```text
.tanstack/
.wrangler/
node_modules/
dist/
build/
out/
coverage/
*.tsbuildinfo
*.d.ts
/src/routeTree.gen.ts
```

Python projects normally ignore:

```text
.venv/
*.egg-info/
build/
dist/
.mypy_cache/
.pytest_cache/
.ruff_cache/
__pycache__/
```

Every stack also ignores `.vs/`, `.idea/`, `.env*`, `.DS_Store`, `Desktop.ini`, and `Thumbs.db`, while allowing `.env*.template` and `.gitkeep`. Add project-specific local databases, generated uploads, platform state, or caches beside the applicable section.

Make a Python service's `.dockerignore` mirror its `.gitignore` unless the image build needs a source-controlled file that Git ignores or Docker should exclude additional large inputs.

## Docker

- Use an official slim Python base image matching `requires-python`.
- Copy uv from `ghcr.io/astral-sh/uv` instead of installing it through pip.
- Set `WORKDIR /app`.
- Copy `pyproject.toml` and `uv.lock` before application source so dependency installation remains cacheable.
- Install only the environment needed by the image. Use a system installation for a simple single-process image, or `uv sync --no-dev --frozen` when the runtime command intentionally uses `/app/.venv`.
- Install system packages in one layer with `--no-install-recommends`, then remove package-manager metadata.
- Copy application source after dependencies.
- Run as a non-root `app` user; UID `5678` is the current default.
- Set `PYTHONDONTWRITEBYTECODE=1` and `PYTHONUNBUFFERED=1`.
- Expose the actual service port and use an exec-form `CMD` for the main process.

Use a small startup script only when one container intentionally supervises multiple tightly coupled processes. It must fail fast, wait for dependencies with a bounded health check, forward termination, clean up child processes, and keep the API process in the foreground from the container's perspective.

## Compose And Service Deployment

Keep root `compose.yml` for cross-boundary local orchestration. Give services explicit build contexts, environment-file paths, port mappings, restart policy, and health checks when downstream services depend on readiness. Do not add Compose for a single process that already runs directly through `make start`.

Keep deployment configuration beside its service:

- Put `wrangler.json` beside the Worker package.
- Put `fly.toml` beside the Fly application and its `Dockerfile`.
- Put database migrations beside the project that owns the database.

Use Singapore (`sin`) as the default Fly primary region for Dennise's projects unless the product's users or infrastructure require another region. Configure machine size and autoscaling from actual workload needs rather than copying another application's values.

## GitHub Actions

Use `.github/workflows/deploy.yml` for the main web deployment workflow. The established top-level shape is:

- Name the workflow `Web Deployment`.
- Trigger it on pushes to `main` and with `workflow_dispatch`.
- Use workflow-level concurrency with `${{ github.workflow }}` and cancel an in-progress superseded run.
- Use the `Production` environment for deployment jobs.
- Create one job per independently deployable boundary when their setup and release paths differ.
- Use clear title-cased job and step names such as `Checkout Source`, `Setup Node.js`, `Setup Bun`, `Install Dependencies`, `Build Project`, `Migrate Database`, and `Deploy Worker`.
- Keep equivalent job and step names identical across workflows. Prefer concise generic names, such as `Deploy Worker` over `Deploy to Cloudflare`.

For Bun applications, check out source, set up the current supported Node.js major, set up Bun, run `bun install --frozen-lockfile`, build, apply required remote migrations, then deploy. Set `working-directory` on boundary-specific steps in a mixed repository.

Prefer the maintained composite actions for current deployments:

- Use `dentolos19/dentolos19/actions/deploy-cloudflare-worker@main` to deploy a Worker and replace its declared secret set.
- Use `dentolos19/dentolos19/actions/deploy-fly-app@main` to stage the declared Fly secrets, deploy, and apply the intended machine count.

Pass secret names through the action's `secrets` input and their values through `env`. These actions replace the remote secret set, so account for every required secret and do not invoke them casually. Do not retain older per-secret `echo | wrangler secret put` sequences when the composite action applies.

Verify current official action majors and platform requirements when creating a workflow; preserve deliberately pinned versions in an existing workflow unless the user asks to upgrade them. Never dispatch or otherwise run a deployment workflow without explicit user authorization.

## Validation

- Run `make check` for all boundaries.
- Run `make build` when defined and relevant.
- Validate referenced paths, working directories, environment names, generated artifacts, Docker build contexts, and migration locations.
- Validate workflow syntax locally when suitable tooling already exists.
- Do not deploy, upload secrets, publish images, migrate a remote database, or trigger CI as validation.
