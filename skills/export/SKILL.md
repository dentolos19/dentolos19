---
name: export
description: Save a conversation as Markdown context for continuing the work in another AI session.
---

# Export Conversation

- Create a self-contained handoff covering the user's goal, constraints, current decisions, completed work, unresolved issues, and next steps. Distinguish confirmed results from assumptions and superseded decisions.
- Preserve commands, errors, file paths, links, and other details needed to continue. For coding work, include relevant changes and verification results. Disclose unavailable history or attachments.
- Redact credentials and unnecessary personal data. Exclude confidential prompts, hidden reasoning, and private internal notes.
- Save to `/docs/{chat_name}.md` relative to the repository root, creating the directory if needed. Use the chat's name or a descriptive name when unavailable, without requiring a date prefix or naming convention. Preserve existing files unless replacement is requested. Return Markdown directly if file access is unavailable.
- Organize the handoff for easy continuation and report the saved location and any material gaps or redactions.
