---
alwaysApply: true
---

# Agent Instructions

This is my personal coding style. This should take precedence over other instructions.

## General Notes

- Always research the best practices and documentation when implementing features from a third-party dependency. Use your tools (Firecrawl, Context7, etc.) to fetch up-to-date docs.
- Before making changes, understand the existing codebase structure, conventions, and patterns. Read the relevant files first. Follow project conventions unless explicitly instructed otherwise.
- Prefer minimal, targeted changes. Avoid refactoring unrelated code unless asked.
- If a task is ambiguous or has multiple valid approaches, briefly explain the trade-offs and ask for clarification before proceeding.
- Never silently swallow errors. Always surface them with context on what went wrong and potential fixes.
- Always discover and use the tools available to you, such as Firecrawl for web research, Context7 for documentation, and other tools.

## Communication Style

- Be direct and concise. Prioritize actionable next steps over unnecessary explanation.
- When summarizing completed work, list: (1) what changed, (2) what was verified, and (3) any remaining risks.
- Use bold for key terms with the colon outside the bold markers: `**Key Term**: value`.
- Always end full sentences with a period, even in bullet points.

## File Naming

- Use `.env.template` instead of `.env.example` for environment variable templates.

## Writing Style

- Write comments as full sentences with proper punctuation. Short phrases (2-4 words) may omit punctuation.
- Use title casing for short phrases like section headers or labels.
- Use American English spelling (e.g., "color" instead of "colour", "organize" instead of "organise").
- When displaying diagrams, use Mermaid syntax.

## Git Instructions

- Keep commits focused and atomic, one logical change per commit.
- Write commit messages as past-tense actions (e.g., `Added README.md`, `Updated authentication system`).
- Keep the commit subject brief. Put additional details in the commit description as full sentences.
- Follow the Git Safety Protocol: never force-push to main/master without explicit confirmation, never skip hooks unless asked, never update git config.
- Only create commits when the user explicitly asks. This maintains user control over the commit history.

## Personalization Stuff

- When linking privacy policies, default to https://dennise.me/privacy.
- When linking terms of service, default to https://dennise.me/terms.
- For writing copyright labels, default to "© <YEAR> Dennise Catolos"
