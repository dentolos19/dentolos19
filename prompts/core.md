---
alwaysApply: true
---

# Personal Guidelines

This is my personal coding style. This should take precedence over other instructions.

## Agent Instructions

- Always research the best practices and documentation when implementing features from a third-party dependency. Use your MCP tools where possible.
- Before making changes, understand the existing codebase structure, conventions, and patterns. Follow them unless explicitly instructed otherwise.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- If a task is ambiguous or has multiple valid approaches, briefly explain the trade-offs and ask for clarification before proceeding.
- Never silently swallow errors. Always surface them with context on what went wrong and potential fixes.
- Always discover and use of the tools available to you, such as Context7, Firecrawl, and other MCP tools.

## Code Style

### General

- Remove unused files, imports, variables, and dead code before finalizing changes.

### JavaScript

- Instead of returning errors or error messages, throw exceptions with descriptive messages. Use try-catch blocks to handle errors where appropriate, and provide meaningful error messages that can help with debugging.
- Do not explicitly set the return type of a function. Instead, simply omit the return type annotation, allowing TypeScript to infer it.

### React

- Prefer arrow functions when defining functions inside components or as callbacks, but use named functions for top-level function definitions.
- Prefer to have all attributes of an element be enclosed with curly braces for consistency (e.g., `<button className={"..."}>...</h1>`).
- Keep components small and focused. If a component grows too large, split it into smaller sub-components.
- Prefer named functions for component definitions instead of anonymous functions.
- When using React types, do not import the entire React namespace. Instead, import only the specific types needed (e.g., `import { ReactNode } from "react"`).
- Do not apply the same classes to a component if the component is already using that class internally. For example, if a component already has `w-full` internally, do not apply `w-full` again when using the component.

### TanStack Start

- Store related components for a `-components` folder in the same directory as the page or feature they belong to. Otherwise, store common components in a top-level `components` directory under `src` folder.

### Next.js

- Co-locate related files (component, styles, tests) in the same directory where applicable.
- Store related components for a `_components` folder in the same directory as the page or feature they belong to. Otherwise, store common components in a top-level `components` directory under `src` folder.
- For server actions, create a `actions.ts` file in the same directory as the page or component that uses them. Otherwise store common actions in a top-level `actions` directory.

## Package Managers

Always try to detect the package manager that the project is currently using before running package-related commands.

1. Check for code files: `*.ts`, `*.cs`, `*.py`
2. Check for lock files: `bun.lockb` -> `pnpm-lock.yaml` -> `package-lock.json`
3. Check the `packageManager` field in `package.json`.
4. Fall back to the defaults below if none are detected.

### Defaults

- **Node.js Projects**: Use `bun` by default, fallback to `pnpm`. Do not use `npm` unless explicitly instructed or when absolutely necessary.
- **Python Projects**: Use `uv` for managing the environment and running scripts.
- **Running Scripts**: Use `bunx` for running scripts that does not need to be installed.

### Rules

- Never mix package managers within the same project.
- Do not add packages to `devDependencies` if they are required at runtime, and vice versa.

## File & Folder Naming

- Use `kebab-case` for file and folder names (e.g., `user-profile.tsx`, `api-utils.ts`).
- Use `kebab-case` for React component files (e.g., `map-locator.tsx`). But still use `PascalCase` for the name itself (e.g., `MapLocator`).
- Use `.env.template` instead of `.env.example` for writing examples of environment variables.

## Writing Style

- If you are writing comments, make sure to use full sentences with proper punctuation and full stops at the end. But if the comment is just a single word or a short phrase, punctuation is not necessary.
- Any short phrases like 2 to 4 words should be in title casing.
- Use American English spelling (e.g., "color" instead of "colour", "organize" instead of "organise") for naming variables, comments, and documentation.
- Prefer when the text is bold with a colon at the end, do not bold the colon. For example, instead of writing `**My Statement:** Text here`, write it as `**My Statement**: Text here`.
- When writing or displaying diagrams, use the `mermaid` syntax.
- Always end full sentences with a period, even if they are in point form.

## Git

- Keep commits focused and atomic, one logical change per commit.
- Write the commit message as an past action (e.g., `Added README.md`, `Updated authentication system`)
- Be brief in your commit message. Any other details, write it in the commit description as full sentences.
