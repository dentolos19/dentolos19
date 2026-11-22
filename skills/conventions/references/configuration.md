# Configuration

- Always have a `.editorconfig` file within the repository. Refer to `dentolos19` repo for the template.

## Ignores

- Use the `.gitignore` file in `dentolos19` as the base template for any project.
- Sync other ignore files, including `.dockerignore`, using the local `.gitignore` as the base.
- Put normal rules at the top and exception rules at the bottom, with an empty line separating them.
- Sort rules alphabetically. Do not add comments.

## Just

- Use `Justfile` as the central command interface, with `setup`, `install`, `start`, and `check`; add other recipes as needed, following the reference project's order.
- Start with `set dotenv-load`; select `.env` by default or `.env.<environment>` through an `environment` variable, and propagate it to nested commands.
- Use frozen dependency installs. For Bun checks, use `bun lint --fix && bun fmt && bun check --no-script`; for Python, use `uv run ruff check --fix && uv run ruff format && uv run ty check`, adding ty import paths only as needed.
- Skip `compose`/`decompose` when `CI=true`; add `compose` dependencies to recipes requiring local services.
