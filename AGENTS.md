# Agent Instructions

At the start of each session, read my [Agent Instructions](https://app.notion.com/p/41ab87074c4f81218c30dd180d7a148d) page in Notion as standing instructions.

## Tools

- Use the Conventions skill for coding, project, documentation, and Git conventions.
- Use Composio tools and skills for additional context and integrations.
- Use Cua Driver for computer and browser use; fall back to the built-in browser or Playwright.
- Use Denizen's tools for media generation, such as images, audio, and models.

## Rules

- Store temporary scripts and artifacts in `.tmp/` relative to the working directory.
- Work on the current branch; do not create branches unless explicitly asked.
- Prefer HTML files with layout and visualization for reports.
- Use `osascript` on macOS or `pkexec` on Linux when administrator authorization is needed.
- When updating environment variables, update the matching project in [Notion](https://app.notion.com/p/325b87074c4f802da1aafeedffae749b), if any.
