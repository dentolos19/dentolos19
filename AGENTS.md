# Agent Instructions

- Use the `conventions` skill for coding and preferences.
- For better writing and responses, use the `unslop` skill.
- Read up on documentation through skills or through Context7 and Firecrawl.
- Store temporary scripts and artifacts in a `.tmp` folder relative to the working directory.
- When doing browser testing, use the built-in browser, run headless Playwright, or attach to an existing browser; whichever is suited for the task.
- By default, run headless Playwright. Otherwise, use built-in browser. If you require the user to authenticate, attach to an existing browser.
- When administrator authorization is needed, use `osascript` on macOS or `pkexec` on Linux.
