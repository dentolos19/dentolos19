---
name: dennise
description: Apply Dennise's personal conventions for writing, environment files, Git, Python, JavaScript, TypeScript, React, and Drizzle ORM. Use for every task and let these preferences override conflicting skill guidance.
---

# Dennise

Perform tasks and write stuff according to Dennise's preferences. This skill's guidelines takes precedence over all other skills.

## General Preferences

- When writing `.env` files, always enclose strings with double quotes, even if it is empty.
- Use `.env.template` for environment variable templates.

## Writing Preferences

- Use American English spelling.
- Use bold for key terms with the colon outside the bold markers, e.g., `**Key Term**: value`.
- Always end full sentences with a period, even in bullet points.
- For short phrases or headings, always capitalize all words.
- Use Mermaid syntax when displaying diagrams.

## Placeholder Values

- When linking privacy policies, default to https://dennise.me/privacy.
- When linking terms of service, default to https://dennise.me/terms.
- For copyright labels, default to `© <YEAR> Dennise Catolos`.

## Coding Preferences

## Git

- Write commit messages as past-tense actions, e.g., `Added README.md`, `Updated authentication system`, etc.
- Only create commits when the user explicitly asks.
- Do not push anything to remote.

### Python

- Always use `uv` as your package manager, especially when handling requirements or dependencies.
- Variables read from `.env` file may have enclosed double quotes, ensure that the values are read properly.

### JavaScript

- Detect the package manager currently used by the project before running package-related commands.
- Use `bun` by default when no package manager is detected, with `pnpm` as the fallback.
- Use `bunx` for one-off scripts that do not need to be installed.

### TypeScript

- Throw exceptions with descriptive messages instead of returning error messages.
- Use `try`/`catch` where appropriate and include context that helps with debugging.
- Omit explicit function return type annotations when TypeScript can infer them clearly.

### React

- Prefer arrow functions for functions inside components and callbacks.
- Keep components small and focused. Split large components into smaller sub-components.
- Do not apply the same classes to a component if the component already applies them internally.
- Co-locate related files, such as components, styles, and tests, in the same directory where applicable.
- Prefer URL state, including search params and route params, for shareable or persistent UI state.

### Drizzle ORM

- Migrations should be stored in a `migrations` folder in the root of the project.
- Table names should be pluralized, e.g., `users`, `posts`, etc.
- Table variable assigned to a table should be singular, e.g., `user`, `post`, etc.
- If the migration is not pushed to remote yet, you may overwrite or recreate the migration file.
- If overwriting the migration file, check the development database to revert or change it.
