# Configuration

Use this reference when changing commands, package management, formatting or linting, ignore files, or environment files. In Flexible mode, keep the project's existing tooling and extend it only when the task requires it.

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
- Provide recipes `setup`, `start`, `compose`, `decompose`, `check`, and `migrate` in that order where applicable.
- Use lowercase recipe parameters, including variadic parameters such as `*args` and interpolations such as `{{ args }}`.
- Prefer one parameterized recipe for related variants, such as `generate [all|static|routing]`, instead of separate suffixed recipes.
- Use the example below as a base template.

```just
setup:
  bun install
  just migrate

start: compose
  bun run dev && wait
  just decompose

compose:
  docker compose up --detach --wait

decompose:
  docker compose down

check:
  bun run check

migrate *args:
  bun run db:migrate {{ args }}
```

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
- Sort variables alphabetically.
- Add default values where they are safe and known.
