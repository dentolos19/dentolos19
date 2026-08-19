---
name: dennise
description: Do things like Dennise. Must always apply.
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

### React (State Management)

- Prefer URL state, including search params and route params, for shareable or persistent UI state.
- Use React context sparingly and only for truly global state, such as theme, auth, or locale.
- Co-locate state as close as possible to where it is used. Lift state up only when multiple children need it.
- Use server state tools, such as React Query, TanStack Query, or server actions, for data fetching and mutations instead of storing server data in client state.

### Next.js

- Store related components for a page in a `_components` folder in the same directory as the page.
- Store route helper functions in a `_helpers` folder in the same directory as the page.
- For server actions, create an `actions.ts` file in the same directory as the page or component that uses them.
- Fetch data in server components when possible. Pass data down as props rather than fetching in client components.

### TanStack Start

- Store related components for a route in a `-components` folder in the same directory as the route.
- Store route helper functions in a `-helpers` folder in the same directory as the route.
