# Agent Instructions

- Use the `conventions` skill for coding and preferences.
- For better writing and responses, use the `unslop` skill.
- Make use of apps and skills from Composio for additional tools and context.
- Read up on documentation through skills or through Context7 or Firecrawl.
- Store temporary scripts and artifacts in a `.tmp` folder relative to the working directory.
- When administrator authorization is needed, use `osascript` on macOS or `pkexec` on Linux.

## Codex

- The instructions here are only for Codex.
- When doing browser testing, use the built-in browser, run headless Playwright, or attach to an existing browser; whichever is suited for the task.
- By default, run headless Playwright, otherwise, use the built-in browser. Last choice is to attach to an existing browser.
