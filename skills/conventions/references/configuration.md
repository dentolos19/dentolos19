# Configuration

Use this reference when changing commands, package management, formatting or linting, ignore files, or environment files. In Flexible mode, keep the project's existing tooling and extend it only when the task requires it.

## Package Management

- Follow the project's package manager. With none established, use Bun, then pnpm as a fallback.
- Use `bunx` for one-off JavaScript and TypeScript tools.
- Use `uv` for Python dependencies and environments.

## `.editorconfig`

- Keep a root `.editorconfig` in every repository.
- Use the shared configuration below exactly so editor behavior is consistent across projects.

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
max_line_length = 120
insert_final_newline = true
trim_trailing_whitespace = true
```

## `Justfile`

- Always use a `Justfile` as the main human-facing command interface.
- For deployable Cloudflare projects, start with `set dotenv-load` so local deployment can read `.env`.
- Provide recipes in this order where applicable: `setup`, `install`, `start`, `compose`, `decompose`, `build`, `check`, `migrate`, and `deploy`. Place other project-specific recipes after these.
- Make `setup` depend on `install`, then perform any local-only setup such as starting services, migrating, and seeding. Keep `install` free of those side effects so CI can use it independently.
- Keep each recipe command indented with four spaces.
- Use frozen lockfiles in `install` (`bun install --frozen-lockfile`, `uv sync --frozen`) and include each package manager in a multi-project repository. Add `build` only when the project has a real production build; omit no-op recipes and bytecode-only builds that produce no deliverable.
- Make `deploy` depend on `install` and `build` when a build exists. For Cloudflare Workers, validate the existing Worker secret values, upload them in one JSON payload with `wrangler secret bulk`, then run `wrangler deploy`. Omit the bulk upload when the Worker has no secrets. In a multi-project repository, change to the app directory before both Wrangler commands.
- Use lowercase recipe parameters, including variadic parameters such as `*args` and interpolations such as `{{ args }}`.
- Prefer one parameterized recipe for related variants, such as `generate [all|static|routing]`, instead of separate suffixed recipes.
- Use the example below as a base template.

```just
set dotenv-load

setup mode="": install
    just compose
    just migrate
    if [ "{{ mode }}" != "prerun" ]; then just decompose; fi

install:
    bun install --frozen-lockfile

start: compose
    bun run dev && wait
    just decompose

compose:
    docker compose up --detach --wait

decompose:
    docker compose down

build:
    bun run build

check:
    bun run check

migrate *args:
    bun run db:migrate {{ args }}

deploy: install build
    #!/usr/bin/env bash
    set -euo pipefail
    names=(APP_SECRET)
    for name in "${names[@]}"; do if [[ -z "${!name:-}" ]]; then echo "Missing worker secret value: $name" >&2; exit 1; fi; done
    node -e 'process.stdout.write(JSON.stringify(Object.fromEntries(process.argv.slice(1).map((name) => [name, process.env[name]]))))' "${names[@]}" | bun wrangler secret bulk
    bun wrangler deploy
```

Replace `APP_SECRET` with the project's existing Worker secret names.

## Cloudflare And Compose

- Name Wrangler configuration files `wrangler.jsonc` and update references when renaming an existing `wrangler.json`.
- In `compose.yml`, name a service's named volume after that service, such as `database` for a `database` service. Check for existing Docker volumes before renaming; a Compose rename does not migrate stored data.

## Ignore Files

- Use the `dentolos19/dentolos19` repository as the base for `.gitignore`.
- Treat `.gitignore` as the master ignore file. Derive other ignore files from it, then add tool-specific rules.
- Group rules by purpose. Keep custom rule groups between user-file and miscellaneous rule groups.
- For `.dockerignore`, copy the relevant `.gitignore` groups and add Docker-specific rules such as `.git/`.
- For multi-project repositories, have a root `.gitignore` with `general.gitignore` as the base template.
- Use the examples below as a reference.

```ignore
# Editor configurations
.vs/
.idea/

# Build files
.wrangler/
dist/

# User files
.env*
!.env*.template

# Miscellaneous files
.tmp/
.DS_Store
Desktop.ini
Thumbs.db
!.gitkeep
```

```gitignore
# Editor configurations
.vs/
.idea/

# Build files
.wrangler/
dist/

# User files
.env*
!.env*.template

# Project-specific
/src/routeTree.gen.ts

# Miscellaneous files
.tmp/
.DS_Store
Desktop.ini
Thumbs.db
!.gitkeep
```

```dockerignore
# Editor configurations
.vs/
.idea/

# Build files
.wrangler/
dist/

# User files
.env*
!.env*.template

# Docker-specific rules
.git/

# Miscellaneous files
.tmp/
.DS_Store
Desktop.ini
Thumbs.db
!.gitkeep
```

## VS Code

- For Python projects, map the workspace interpreter explicitly in `.vscode/settings.json`.
- When `.vscode/launch.json` exists, every launch configuration should set `preLaunchTask` to `Setup`.
- Define the matching task in `.vscode/tasks.json` and run `just setup`.
- Route launch commands through the Justfile, such as `just start`, when the debugger uses a terminal command.

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Setup",
      "type": "shell",
      "command": "just setup",
      "presentation": {
        "close": true
      }
    }
  ]
}
```

## Environment Files

- Name the environment template `.env.template`.
- Double-quote every value, including empty values: `KEY=""`.
- Add default values where they are safe and known.
- Sort variables alphabetically.
