# Web Development

These instructions are for web development.

## Coding Style

- Remove unused files, imports, variables, and dead code before finalizing changes.
- Write self-documenting code: prefer clear names over comments. Use comments to explain _why_, not _what_.
- Use early returns to reduce nesting and improve readability.

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
- Use React composition patterns (children, render props, slots) instead of boolean prop proliferation for variants.
- Prefer server components by default in React frameworks. Only add `"use client"` when interactivity (state, effects, event handlers) is required.
- Use `kebab-case` for React component files (e.g., `map-locator.tsx`). But still use `PascalCase` for the component name itself (e.g., `MapLocator`).

### CSS and Styling

- Use Tailwind CSS utility classes for styling. Avoid writing custom CSS unless the design requires it.
- Keep class strings readable by grouping related utilities: layout → sizing → spacing → typography → colors → effects.
- Prefer responsive utility variants (`sm:`, `md:`, `lg:`) over custom breakpoint media queries.
- Use CSS custom properties for theme values when working outside Tailwind's design system.

### State Management

- Prefer URL state (search params, route params) for shareable or persistent UI state.
- Use React context sparingly and only for truly global state (theme, auth, locale).
- Co-locate state as close as possible to where it is used. Lift state up only when multiple children need it.
- Use server state (React Query, TanStack Query, or server actions) for data fetching and mutations instead of storing in client state.

### Accessibility

- Use semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<header>`, etc.) instead of generic `<div>`s.
- Ensure all interactive elements are keyboard accessible and have visible focus indicators.
- Provide accessible names for all form inputs, icons, and images (labels, aria-labels, alt text).
- Use proper heading hierarchy (`h1` → `h2` → `h3`) without skipping levels.

### Testing

- Write tests for critical business logic and user flows. Prefer behavior-oriented tests over implementation details.
- Use `data-testid` attributes for test selectors instead of relying on CSS classes or DOM structure.
- Mock at the network boundary, not at the module level, when testing data-fetching components.

### Next.js

- Co-locate related files (component, styles, tests) in the same directory where applicable.
- Store related components for a given page in a `_components` folder in the same directory as the page. Store shared/common components in a top-level `components` directory under `src`.
- For server actions, create an `actions.ts` file in the same directory as the page or component that uses them. Store common actions in a top-level `actions` directory.
- Use the `loading.tsx`, `error.tsx`, and `not-found.tsx` conventions for route-level loading and error states.
- Fetch data in server components when possible. Pass data down as props rather than fetching in client components.

### TanStack Start

- Store related components for a given route in a `-components` folder in the same directory as the route. Store shared/common components in a top-level `components` directory under `src`.

## Package Managers

Use `bun` by default, fallback to `pnpm`. And, use `bunx` for running scripts that do not need to be installed.

Always try to detect the package manager that the project is currently using before running package-related commands.

1. Check for code files: `*.ts`, `*.cs`, `*.py`
2. Check for lock files: `bun.lockb` → `pnpm-lock.yaml` → `package-lock.json`
3. Check the `packageManager` field in `package.json`.
4. Fall back to the defaults below if none are detected.
