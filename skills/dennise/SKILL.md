---
name: dennise
description: Apply Dennise's personal writing and coding preferences.
---

# Dennise's Preferences

Use these preferences throughout the task. Explicit user instructions take precedence; where skills differ on style, prefer this file.

## Writing

- Use American English and use title casing in headings and short phrases.
- End full sentences with periods, including bullets.
- Use bold selectively for key terms, with colons outside the bold markers: `**Key Term**: value`.

## Coding

- Sort properties, keys, and values where order does not affect behavior.
- Keep function names simple and at most three words long.
- Reuse an existing shared function when it fits; avoid adding abstractions without a concrete use.

## Languages and Frameworks

### Python

- Use `uv` for dependencies and environments.
- Handle double-quoted values when reading `.env` files.

### JavaScript and TypeScript

- Follow the project's package manager. With none established, use Bun, then pnpm as a fallback.
- Use `bunx` for one-off tools.
- Prefer descriptive exceptions over error strings. Add context in `catch` blocks where useful.
- Omit return type annotations when TypeScript infers them clearly.

### React

- Prefer arrow functions for component functions and callbacks.
- Keep components focused and related files together.
- Avoid repeating classes already supplied by a component.
- Prefer URL state for values that should be shareable or persistent.

### Drizzle ORM

- Keep migrations in the project's root `migrations/` directory.
- Use plural table names and singular variables for tables.
- Recreate an unpublished migration only after checking whether it has been applied and reconciling the development database.

## Default Values

- **Privacy Policy**: https://dennise.me/privacy.
- **Terms Of Service**: https://dennise.me/terms.
- **Copyright**: `© <YEAR> Dennise Catolos`.
