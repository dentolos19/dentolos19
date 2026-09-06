# Agent Instructions

## General Rules

- Make full use of the plugins and tools to help you to retrieve documentations and information.
- Before making changes, understand the existing codebase structure, conventions, and patterns.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- Use subagents when work can be meaningfully parallelized for complex tasks.
- Do not write unit tests or do browser testing unless explictly told to do so.
- If my instructions are ambiguous, ask me to clarify before proceeding.
- If administrator access is required on macOS, request authorization with `osascript`.
- If administrator access is required on Linux, request authorization with `pkexec`.

## Subagent Delegation

- Delegate codebase exploration, research, tests, and reviews.
- Break complex tasks into independent subtasks.
- Give each subagent a narrow objective and expected output.
- Keep architectural decisions, integration, and final verification in the parent agent.
- Do not delegate trivial work where coordination would cost more than doing it directly.

## Temporary Files

- If you need to store temporary files, store them in `.tmp/` within the working directory.
- Anything not related to the codebase may store files temporarily in `.tmp/`.
- The temporary folder may be used for temporary scripts, output artifacts, etc.

## Supplementary Instructions

- Always use the `dennise` skill for my personal preferences.
- Follow the `conventions` skill where possible.
- Use the `prose` skill for writing and removing AI-generated patterns.
- When resolving Git conflicts, make use of the `resolve` skill.
