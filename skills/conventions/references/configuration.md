# Configuration

Use this reference when changing commands, package management, formatting or linting, ignore files, or environment files. In Flexible mode, keep the project's existing tooling and extend it only when the task requires it.

## Makefiles

- Always use a `Makefile` as the main human-facing command interface.
- Provide targets `setup`, `start`, `compose`, `decompose`, `check`, and `migrate` as ordered where applicable.
- Order `.PHONY` accordingly to order of declaration.
- Use the example below as a base template.

```
.PHONY: setup start check migrate

setup:
	bun install
	$(MAKE) migrate

start:
	bun run dev

check:
	bun run check

migrate:
	bun run db:migrate
	bun run db:seed
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

## Environment Files

- Name the environment template `.env.template`.
- Double-quote every value, including empty values: `KEY=""`.
- Sort variables alphabetically.
- Add default values where they are safe and known.
