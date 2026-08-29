---
name: export
description: Summarize and export the current user-visible conversation to Markdown when the user asks to save, archive, or export the chat.
---

# Export Conversation

Summarize and compact the conversations before exporting them.

## Rules

- Use the user's destination when provided. Otherwise write to `docs/chat/<YYYY-MM-DD>-<short-title>.md` relative to the working directory.
- Include a title and export date.
- Keep requests, decisions, constraints, results, changed files, and unresolved work.
- Merge repeated or superseded instructions. Remove status updates, filler, and details that do not help future work.
- Preserve code or quotations only when their exact wording matters.
