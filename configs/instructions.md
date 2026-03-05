# Personal Guidelines

This is my personal coding style. This should take precedence over other instructions.

## Agent Instructions

- Always research the best practices and documentation when implementing features from a third-party dependency. Use your MCP tools where possible.
- Before making changes, understand the existing codebase structure, conventions, and patterns. Follow them unless explicitly instructed otherwise.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- If a task is ambiguous or has multiple valid approaches, briefly explain the trade-offs and ask for clarification before proceeding.
- Never silently swallow errors. Always surface them with context on what went wrong and potential fixes.
- Always assume that the app is currently running before building the project or updating any packages.

## Code Style

### General

- Prefer explicit over implicit. Avoid magic numbers and unexplained constants, extract them into named constants with a comment if necessary.
- Remove unused imports, variables, and dead code before finalizing changes.
- Ensure all new code is properly typed. Avoid using `any` in TypeScript unless absolutely necessary, and add a comment explaining why.
- Write variable names as the full word (e.g., `db` -> `database`).

### JavaScript

- Prefer arrow functions for defining function definitions.

### React

- Prefer to have all attributes of an element be enclosed with curly braces for consistency (e.g., `<h1 className={"..."}>...</h1>`).
- Do not have to wrap text inside an element with curly braces unless when necessary.
- Keep components small and focused. If a component grows too large, split it into smaller sub-components.
- Co-locate related files (component, styles, tests) in the same directory where applicable.
- Prefer named functions for component definitions.

## Package Managers

Always try to detect the package manager that the project is currently using before running package-related commands.

1. Check for code files: `*.ts`, `*.cs`, `*.py`
2. Check for lock files: `bun.lockb` -> `pnpm-lock.yaml` -> `package-lock.json`
3. Check the `packageManager` field in `package.json`.
4. Fall back to the defaults below if none are detected.

### Defaults

- **Node.js Projects**: Use `pnpm` by default.
- **Python Projects**: Use `uv` for managing the environment and running files.

### Rules

- Never mix package managers within the same project.
- Do not add packages to `devDependencies` if they are required at runtime, and vice versa.

## File & Folder Naming

- Use `kebab-case` for file and folder names (e.g., `user-profile.tsx`, `api-utils.ts`).
- Use `kebab-case` for React component files (e.g., `map-locator.tsx`). But still use `PascalCase` for the name itself (e.g., `MapLocator`).

## Writing Style

- If you are writing comments, make sure to use full sentences with proper punctuation and full stops at the end. But if the comment is just a single word or a short phrase, punctuation is not necessary.
- Any short phrases like 2 to 4 words should be in title casing.
- Use American English spelling (e.g., "color" instead of "colour", "organize" instead of "organise") for naming variables, comments, and documentation.
- Write comments that explain **why**, not **what**. The code itself should be clear enough to convey what it does.

## Git

- Keep commits focused and atomic, one logical change per commit.
- Write the commit message as an past action (e.g., `Added README.md`, `Updated authentication system`)
- Be brief in your commit message. Any other details, write it in the commit description. Write commit description as full sentences.
