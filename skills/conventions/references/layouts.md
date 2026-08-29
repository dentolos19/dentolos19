# Repository Layouts

## Standalone TypeScript Web Application

Keep a standalone TypeScript application at the repository root:

```
.
|-- .github/
|-- .vscode/
|-- migrations/
|-- public/
|-- src/
|   |-- components/
|   |-- lib/
|   |-- routes/
|   |-- server.ts
|   `-- styles.css
|-- bun.lock
|-- Makefile
|-- package.json
|-- tsconfig.json
`-- <framework configuration>
```

Add `public/` only for static assets. Add `migrations/` at this project root when the application owns a database.

## Single Python Application

Keep a small Python web app, service, or CLI flat at the repository root:

```text
.
|-- .github/
|-- .vscode/
|-- lib/           # Add when integrations or domain support justify it.
|-- routes/        # Add when web routes no longer belong in main.py.
|-- main.py
|-- Makefile
|-- pyproject.toml
`-- uv.lock
```

Keep a small CLI's modules beside `main.py`. Add focused packages such as `lib/`, `routes/`, or `parsers/` as the application grows. Do not introduce a nested installable-package layout unless packaging or imports require it.

## Mixed-Runtime Application

Use the root as an orchestration layer and put each runnable process under `src/<role>`:

```text
.
|-- .github/
|-- .vscode/
|-- src/
|   |-- app/               # Bun, TypeScript, React, or a Worker.
|   |   |-- src/
|   |   |-- package.json
|   |   `-- bun.lock
|   |-- server/            # Python backend or application container.
|   |   |-- main.py
|   |   |-- pyproject.toml
|   |   `-- uv.lock
|   `-- simulator/         # Optional independent auxiliary process.
|       |-- main.py
|       |-- pyproject.toml
|       `-- uv.lock
|-- Makefile
`-- compose.yml            # Only when local containers need orchestration.
```

Use `app` for the user-facing full-stack TypeScript or Worker application and `server` for its Python API or container. Name other processes by their responsibility, such as `simulator`, `ingest`, or `worker`; avoid numbered or generic directories.

Each boundary owns its own dependencies. The root `Makefile` orchestrates them with `cd` or `$(MAKE) -C`; a root `package.json`, `pyproject.toml`, or lockfile is unnecessary unless the root is itself a real package.

## Boundary Rules

- Put a manifest and lockfile beside the code they govern.
- Put `Dockerfile`, `.dockerignore`, `fly.toml`, `wrangler.json`, database configuration, and migrations beside the service they deploy or modify.
- Put cross-service `compose.yml`, repository-level workflows, and orchestration at the root. Store documentation and notes in the repository's `/docs` directory.
- Keep sample data close to its consumer. Use a root `samples/` only when multiple boundaries share it.
- Use Git LFS for large tracked binaries such as video samples; do not use LFS for normal source or small images.
- Keep generated output out of the tree. Commit generated artifacts only when a platform or consumer requires them.

## TypeScript Source Shape

Use these stable responsibilities:

- `src/components` contains reusable application components.
- `src/components/ui` contains generated or reusable UI primitives. Avoid editing or reformatting generated primitives unless necessary.
- `src/hooks` contains reusable React hooks.
- `src/lib` contains domain logic, integrations, database access, server functions, and platform bindings, grouped by responsibility as they grow.
- `src/lib/database/index.ts` exposes database construction; `src/lib/database/schema.ts` defines the schema.
- `src/routes` follows the router's filesystem convention.

For TanStack Router, use route groups such as `(public)` and `(platform)`, `$id` for dynamic segments, `__root.tsx` for the root route, `route.tsx` for layouts, and `index.tsx` for index routes. Co-locate route-only code in `-components` and non-visual route support in `-helpers`. Shared code moves to `src/components`, `src/hooks`, or `src/lib` instead of reaching across route folders.

Prefer direct imports through the `#/` alias. Use an `index.ts` only when it exposes a deliberate module boundary, not as a blanket barrel for every directory.

## Python Source Shape

Use `main.py` as the executable and importable application entrypoint. Keep it focused on application construction, router registration, lifecycle hooks, and startup.

As a service grows:

- Put API routers in `routes/`.
- Put databases, external clients, models, storage, and other integrations in `lib/`.
- Put a substantial specialized subsystem in a named package such as `parsers/`.
- Keep operational settings in `config.py` and validated environment access in `environment.py` when both concerns exist.

Avoid a catch-all `utils.py` when a function has a clear domain owner. A small application may keep a few genuinely shared helpers there.

## Repository Documentation

Creating `README.md` is optional. When it exists or is requested, keep it basic:

1. Start with `# <Icon> <Project Name>`.
2. Describe the project's entire purpose in one simple sentence.
3. Show an application preview when one exists.
4. Add only useful sections such as `Installation` or `Tutorials`.
5. End with `## License` and link to the project's license exactly once.

Use `/docs` for documentation, notes, and other maintained project context. Add `LICENSE` for a public or distributable project.
