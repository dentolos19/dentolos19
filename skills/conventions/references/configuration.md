# Configuration

Use this reference when changing commands, package management, formatting or linting, ignore files, or environment files. In Flexible mode, keep the project's existing tooling and extend it only when the task requires it.

## Makefiles

- Always use a `Makefile` as the main human-facing command interface.
- Provide targets `setup`, `start`, and `check` where applicable.
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
- Group rules by purpose. Keep project-specific rules between user-file and miscellaneous groups. Put Docker-specific rules in `.dockerignore`.
- For `.dockerignore`, copy the relevant `.gitignore` groups and add Docker-specific rules such as `.git/`.

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

# Project-specific rules

# Docker-specific rules

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
