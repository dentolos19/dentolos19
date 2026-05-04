# Web Development

This instructions are for web development.

## Coding Styles

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

### Next.js

- Co-locate related files (component, styles, tests) in the same directory where applicable.
- Store related components for a `_components` folder in the same directory as the page or feature they belong to. Otherwise, store common components in a top-level `components` directory under `src` folder.
- For server actions, create a `actions.ts` file in the same directory as the page or component that uses them. Otherwise store common actions in a top-level `actions` directory.

### TanStack Start

- Store related components for a `-components` folder in the same directory as the page or feature they belong to. Otherwise, store common components in a top-level `components` directory under `src` folder.

## Package Managers

Always try to detect the package manager that the project is currently using before running package-related commands.

1. Check for code files: `*.ts`, `*.cs`, `*.py`
2. Check for lock files: `bun.lockb` -> `pnpm-lock.yaml` -> `package-lock.json`
3. Check the `packageManager` field in `package.json`.
4. Fall back to the defaults below if none are detected.

### Defaults

- **Node.js Projects**: Use `bun` by default, fallback to `pnpm`.
- **Python Projects**: Use `uv` for managing Python environments and running scripts.
- **Running Scripts**: Use `bunx` for running scripts that does not need to be installed.
