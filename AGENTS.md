# Agent Instructions

- Apply the `dennise` skill for personal preferences and `prose` when writing or editing prose.
- Use `conventions` for structure, tooling, or documentation decisions, and `resolve` for active Git conflicts.
- Read the files and documentation relevant to the change. Use tools, plugins, and MCPs when they supply needed information.
- Keep changes within the requested scope and continue through implementation and relevant verification.
- Resolve routine ambiguity from context. Ask when a missing decision materially changes the requested outcome and cannot be inferred; continue independent work meanwhile.
- Use subagents for independent parts of complex tasks when the benefit outweighs coordination. Keep integration and final verification with the lead agent.
- Do not write unit tests or perform browser testing unless explicitly requested. Use applicable existing checks without repeating them after success unless something changes.
- Store temporary scripts and artifacts in `.tmp/` within the working directory.
- When administrator authorization is needed, use `osascript` on macOS or `pkexec` on Linux, subject to the environment's permissions.

## Supplementary Documentations

- [**Writing Skills**](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra)
