# Agent Instructions

- Use the `conventions` skill for coding and preferences.
- Make use of apps and skills from Composio for tools and context.
- Use the built-in browser where available, otherwise use Playwright headless or attach to an existing browser.
- When generating reports, prefer to create HTML files with formatted text and styled layout.
- Store temporary scripts and artifacts in a `.tmp` folder relative to the working directory.
- When administrator authorization is needed, use `osascript` on macOS or `pkexec` on Linux.
