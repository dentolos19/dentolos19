# Configuration

Use this reference when changing commands, package management, formatting or linting, ignore files, or environment files. In Flexible mode, keep the project's existing tooling and extend it only when the task requires it.

## Repository Defaults

- Keep `.editorconfig` and `Makefile` in every repository.
- Use `Makefile` as the human-facing command interface when the project exposes commands.
- Provide `check`, `setup`, and `start` targets when they fit the project.
- Map those targets to the project's actual check, setup, and development commands. Add service lifecycle or migration targets only when the project needs them.

## Ignore Files

- Use the `dentolos19/dentolos19` repository as the base for `.gitignore`.
- Treat `.gitignore` as the master ignore file. Derive other ignore files from it, then add tool-specific rules.
- Group rules by purpose. Keep project-specific rules between user-file and miscellaneous groups. Put Docker-specific rules in `.dockerignore`.

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

# Project-specific rules

# Miscellaneous files
.tmp/
.DS_Store
Desktop.ini
Thumbs.db
!.gitkeep
```

For `.dockerignore`, copy the relevant `.gitignore` groups and add Docker-specific rules such as `.git/`.

## Environment Files

- Name the environment template `.env.template`.
- Double-quote every value, including empty values: `KEY=""`.
- Sort variables alphabetically.
- Add default values where they are safe and known.
