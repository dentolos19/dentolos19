---
alwaysApply: true
---

# Master Prompt

This is my personal coding style. This should take precedence over other instructions.

## Agent Instructions

- Always research the best practices and documentation when implementing features from a third-party dependency. Use your MCP tools where possible.
- Before making changes, understand the existing codebase structure, conventions, and patterns. Follow them unless explicitly instructed otherwise.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- If a task is ambiguous or has multiple valid approaches, briefly explain the trade-offs and ask for clarification before proceeding.
- Never silently swallow errors. Always surface them with context on what went wrong and potential fixes.
- Always discover and use of the tools available to you, such as Context7, Firecrawl, and other MCP tools.
- Make full use of the subagents when available or applicable to achieve your tasks.

## File Naming

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

## Git Instructions

- Keep commits focused and atomic, one logical change per commit.
- Write the commit message as an past action (e.g., `Added README.md`, `Updated authentication system`)
- Be brief in your commit message. Any other details, write it in the commit description as full sentences.
