---
alwaysApply: true
---

# Agent Instructions

This is my personal coding style. This should take precedence over other instructions.

## Orchestration Role

As the master orchestration agent, follow this workflow for every task:

1. **Clarify** the objective internally before acting. If the task is ambiguous, ask the user.
2. **Plan** by identifying what files need to change, what approach to take, and what risks exist.
3. **Explore** the codebase to understand existing patterns before writing new code.
4. **Delegate** focused subtasks to specialized subagents when the work is complex or spans multiple domains.
5. **Verify** by running type checks, linters, and tests after making changes.
6. **Summarize** what changed, what was verified, and any remaining risks or next steps.

## Agent Instructions

- Always research the best practices and documentation when implementing features from a third-party dependency. Use your MCP tools (Firecrawl, Context7, etc.) to fetch up-to-date docs.
- Before making changes, understand the existing codebase structure, conventions, and patterns. Read the relevant files first. Follow project conventions unless explicitly instructed otherwise.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- If a task is ambiguous or has multiple valid approaches, briefly explain the trade-offs and ask for clarification before proceeding.
- Never silently swallow errors. Always surface them with context on what went wrong and potential fixes.
- Always discover and use the tools available to you, such as Context7 for documentation, Firecrawl for web research, and other MCP tools.
- Make full use of subagents (explore, analyze, build, general) when available to parallelize work. Use `@plan` for complex architecture, `@explore` for code inspection, `@analyze` for bug/security review, and `@build` for implementation.
- Use the `todowrite` tool to track progress on complex multi-step tasks. Keep one task `in_progress` at a time.
- **Commit discipline**: Only create commits when explicitly asked by the user. Never commit without confirmation.

## Communication Style

- Be direct and concise. Prioritize actionable next steps over unnecessary explanation.
- When summarizing completed work, list: (1) what changed, (2) what was verified, and (3) any remaining risks.
- Use bold for key terms with the colon outside the bold markers: `**Key Term**: value`.
- Always end full sentences with a period, even in bullet points.

## File Naming

- Use `kebab-case` for file and folder names (e.g., `user-profile.tsx`, `api-utils.ts`).
- Use `kebab-case` for React component files (e.g., `map-locator.tsx`). But still use `PascalCase` for the component name itself (e.g., `MapLocator`).
- Use `.env.template` instead of `.env.example` for environment variable templates.

## Writing Style

- Write comments as full sentences with proper punctuation. Short phrases (2-4 words) may omit punctuation.
- Use title casing for short phrases like section headers or labels.
- Use American English spelling (e.g., "color" instead of "colour", "organize" instead of "organise").
- When displaying diagrams, use `mermaid` syntax.
- Do not use emojis unless explicitly requested by the user.

## Git Instructions

- Keep commits focused and atomic — one logical change per commit.
- Write commit messages as past-tense actions (e.g., `Added README.md`, `Updated authentication system`).
- Keep the commit subject brief. Put additional details in the commit description as full sentences.
- Follow the Git Safety Protocol: never force-push to main/master without explicit confirmation, never skip hooks unless asked, never update git config.
- Only create commits when the user explicitly asks. This maintains user control over the commit history.

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

### React

- Prefer arrow functions when defining functions inside components or as callbacks, but use named function declarations for top-level function definitions.
- Use named function declarations for component definitions (e.g., `function MyComponent({...}: Props) {`).
- Prefer curly braces for all element attributes for consistency (e.g., `className={"..."}`).
- Keep components small and focused. If a component grows too large, split it into smaller sub-components.
- When using React types, import only the specific types needed (e.g., `import { ReactNode } from "react"`), never the entire React namespace.
- Do not apply the same classes to a component if the component is already using that class internally. For example, if a component already has `w-full` internally, do not apply `w-full` again when using the component.
- Use React composition patterns (children, render props, slots) instead of boolean prop proliferation for variants.
- Prefer server components by default in React frameworks. Only add `"use client"` when interactivity (state, effects, event handlers) is required.

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

Always try to detect the package manager that the project is currently using before running package-related commands.

1. Check for code files: `*.ts`, `*.cs`, `*.py`
2. Check for lock files: `bun.lockb` → `pnpm-lock.yaml` → `package-lock.json`
3. Check the `packageManager` field in `package.json`.
4. Fall back to the defaults below if none are detected.

### Defaults

- **Node.js Projects**: Use `bun` by default, fallback to `pnpm`.
- **Python Projects**: Use `uv` for managing Python environments and running scripts.
- **Running Scripts**: Use `bunx` for running scripts that do not need to be installed.
