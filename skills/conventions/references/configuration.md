# Configuration

## Commands and Dependencies

- Use a root `Makefile` as the human-facing command interface. Provide `setup`, `start`, and `check` where applicable. Declare command targets `.PHONY`.
- Delegate JavaScript commands to package scripts and Python commands to `uv run`. Coordinate separate apps from the root Makefile.
- Use Bun with `bun.lock` for JavaScript and TypeScript; use pnpm when Bun is incompatible. Flexible mode keeps the detected package manager.
- Use uv with `pyproject.toml` and `uv.lock` for Python. Keep development tools in the `dev` dependency group.
- Keep one lockfile per dependency workspace. A mixed Python/TypeScript project may need both lockfiles.

## Formatting and Types

- Use UTF-8, LF, spaces, a final newline, and a 120-column line limit. Trim trailing whitespace; retain syntax-required tabs in Makefiles.
- Use Oxfmt and Oxlint for JavaScript/TypeScript. Set Oxfmt `printWidth` to `120`, enable `sortImports`, and enable `sortTailwindcss` when using Tailwind.
- Use Ruff for Python with `line-length = 120` in `pyproject.toml`.
- `check` formats and fixes lint issues: `oxfmt --write` then `oxlint --fix`, or `uv run ruff format` then `uv run ruff check --fix`. Inspect existing commands before running them; use file-scoped checks for Flexible edits.
- Exclude generated and vendored files from formatting. Keep generated shadcn files under `src/components/ui/` out of bulk fixes.
- Use TypeScript strict checking and ESM where supported. For bundler-based apps, map `#/*` to `./src/*` consistently in package imports and TypeScript configuration.
- Keep type generation separate from type checking. Regenerate route and platform types when their inputs change.

## Environment

- Use `.env.template` with placeholder values. Double-quote every string, including empty values: `KEY=""`.
- Keep environment files within the same directory of app that loads them.
