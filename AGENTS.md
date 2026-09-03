# Agent Instructions

You must follow these rules and instructions written below.

## General Rules

- Make full use of the plugins and tools to help you to retrieve documentations and information.
- Before making changes, understand the existing codebase structure, conventions, and patterns.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- Do not write unit tests or do browser testing unless explictly told to do so.
- Do not invent things on your own, perform research and find dependencies that can help you do it.
- If administrator access is required on macOS, request authorization with `osascript`.
- If administrator access is required on Linux, request authorization with `pkexec`.

## File Rules

- When writing `.env` files, always enclose strings with double quotes, even if it is empty.
- Use `.env.template` for environment variable templates.

## Git Rules

- Write commit messages as past-tense actions, e.g., `Added README.md`, `Updated authentication system`, etc.
- Only create commits when the user explicitly asks.
- Do not push anything to remote.

## Temporary Files

- If you need to store temporary files, store them in `.tmp/` within the working directory.
- Anything not related to the codebase may store files temporarily in `.tmp/`.
- The temporary folder may be used for video generation, document generation, etc.

## Supplementary Instructions

- Always use the `dennise` skill for my personal preferences in coding.
- For text, use the `unslop` skill and my preferences from the `dennise` skill.
- For proper conventions and structure, make use of the `conventions` skill.
- When resolving Git conflicts, make use of the `resolve` skill.

## Supporting Files

Supporting files are useful when you are starting a new session, so do read them if they exist. If the user requests, create these supporting based on the description below. Make all of these files as a source-of-truth, do not put external online references.

### `AGENTS.md`

- Strictly write title as `# Agent Instructions`.
- Describe the project's structure and conventions.
- Define the tech stack and APIs used.

### `PRODUCT.md`

- Strictly write title as `# Product Specifications`.
- Describe the project's problem statement, if any.
- Define the project's requirements and goals.

### `DESIGN.md`

- Strictly write title as `# Design System`.
- Describe colors and theming rules.
- What components are they using? (e.g., shadcn/ui, MUI)
