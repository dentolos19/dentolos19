# Agent Instructions

At the start of each session, read the [Agent Instructions](https://app.notion.com/p/41ab87074c4f81218c30dd180d7a148d) page in Notion and follow it. It is my standing instruction.

## Coding Preferences

- Use the Conventions skill for coding and preferences.
- Make use of the built-in plugins and skills or Composio CLI for tools and context.
- Use Agent Browser for browser tasks, otherwise use the built-in browser or Playwright.
- When generating reports, prefer to create HTML files with layout and visualization.
- Keep validation and testing minimal. Prioritize targeted checks and avoid redundant tests.
- Do not include validation, testing, or verification details unless explicitly requested.
- Store temporary scripts and artifacts in a `.tmp` folder relative to the working directory.
- When administrator authorization is needed, use `osascript` on macOS or `pkexec` on Linux.
