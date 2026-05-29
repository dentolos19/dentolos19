# Web Development

These instructions are for web development.

## Coding Style

### TypeScript

- Instead of returning errors or error messages, throw exceptions with descriptive messages. Use try-catch blocks to handle errors where appropriate, and provide meaningful error messages that can help with debugging.
- Do not explicitly set the return type of a function. Instead, simply omit the return type annotation, allowing TypeScript to infer it.
- Use explicit `interface` over `type` for object shapes that may be extended. Prefer `type` for unions, intersections, and mapped types.
- Use `const` assertions (`as const`) for literal types and configuration objects.
- Use the `satisfies` operator to type-check values without widening their inferred type.
- Use `kebab-case` for file and folder names (e.g., `user-profile.tsx`, `api-utils.ts`).

### React

- Prefer arrow functions when defining functions inside components or as callbacks, but use named function declarations for top-level function definitions.
- Use named function declarations for component definitions (e.g., `function MyComponent({...}: Props) {`).
- Prefer curly braces for all element attributes for consistency (e.g., `className={"..."}`).
- Keep components small and focused. If a component grows too large, split it into smaller sub-components.
- When using React types, import only the specific types needed (e.g., `import { ReactNode } from "react"`), never the entire React namespace.
- Do not apply the same classes to a component if the component is already using that class internally. For example, if a component already has `w-full` internally, do not apply `w-full` again when using the component.
- Use `kebab-case` for React component files (e.g., `map-locator.tsx`). But still use `PascalCase` for the component name itself (e.g., `MapLocator`).

### React (State Management)

- Prefer URL state (search params, route params) for shareable or persistent UI state.
- Use React context sparingly and only for truly global state (theme, auth, locale).
- Co-locate state as close as possible to where it is used. Lift state up only when multiple children need it.
- Use server state (React Query, TanStack Query, or server actions) for data fetching and mutations instead of storing in client state.

### Meta-frameworks (Next.js)

- Co-locate related files (component, styles, tests) in the same directory where applicable.
- Store related components for a given page in a `_components` folder in the same directory as the page.
- For server actions, create an `actions.ts` file in the same directory as the page or component that uses them.
- Fetch data in server components when possible. Pass data down as props rather than fetching in client components.

### Meta=frameworks (TanStack Start)

- Co-locate related files (component, styles, tests) in the same directory where applicable.
- Store related components for a given route in a `-components` folder in the same directory as the route.
- For helper functions, store them in a `-helpers` folder in the same directory as the route.

## Package Managers

Use `bun` by default, fallback to `pnpm`. And, use `bunx` for running scripts that do not need to be installed.

Always try to detect the package manager that the project is currently using before running package-related commands.

1. Check for code files: `*.ts`, `*.cs`, `*.py`
2. Check for lock files: `bun.lockb` → `pnpm-lock.yaml` → `package-lock.json`
3. Check the `packageManager` field in `package.json`.
4. Fall back to the defaults below if none are detected.
