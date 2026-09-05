# Configuration

## Commmon Files

- In all repositories, always have `.editorconfig`, `Makefile`

## Makefiles

- Always use a `Makefile` as the main human-facing command interface.
- Provide targets `setup`, `start`, and `check` where applicable.
- Use the example below as a base template.

### Example

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

- Reference `dentolos19/dentolos19` repository for ignore templates.
- Always use the ignore templates as a base, add project-specific rules on top of it. (only for `.gitignore`)
- Use `.gitignore` as the master ignore files, copy the contents to other ignore files.
- With the master ignore files as the base, add tool-specific rules on top of it. (for `.dockerignore`, etc.)
- Group certain rules together with the same category or purpose.
- Use the example below as a base template.

### Example

```
# Editor configurations
.vs/
.idea/

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

## Environment Files

- Name the `.env` template as `.env.template`.
- Double-quote every string, including empty values: `KEY=""`.
- Group environment variables accordingly to where they apply.
- If no groups are applicable, just make them plain.

### Group Example

```
# Client
VITE_CLIENT_ONLY_KEY=""

# Server
SERVER_ONLY_KEY=""

## Other
BUILD_ONLY_KEY=""
```

### Plain Example

```
MY_KEY_ONE=""
MY_KEY_TWO=""
MY_KEY_THREE=""
```
