# Coding

Use this reference when writing or reviewing source code.

## General

- Sort properties, keys, and values where order does not affect behavior.
- Keep function names simple and at most three words long.
- Reuse an existing shared function when it fits; avoid abstractions without a concrete use.

## JavaScript And TypeScript

- Declare module-level functions and components with named `function` declarations.
- Use anonymous arrow functions for callbacks and functions declared inside another function, component, method, or block.
- Do not assign a module-level arrow function or function expression to a variable when a function declaration expresses the same behavior.
- Keep a callable value as a variable when it is produced by a factory, wrapper, or other expression rather than declared directly.
- Prefer descriptive exceptions over error strings. Add context in `catch` blocks when it helps diagnose the failure.
- Omit return type annotations when TypeScript infers them clearly.

## React

- Keep components focused and related files together.
- Avoid repeating classes already supplied by a component.
- Prefer URL state for values that should be shareable or persistent.

## Drizzle ORM

- Use plural table names and singular variables for tables.
