---
name: export
description: Summarize and export a chat conversation when the user asks to export the chat.
---

# Export Conversation

## Workflow

1. Summarize and compact the conversation.
2. Use the user's destination when provided, otherwise write to `docs/chat` relative to the working directory.
3. Name the file with this format: `<YYYY-MM-DD>_<short-title>.md`

## Template

```markdown
---
name: <conversation-name>
date: <YYYY-MM-DD>
time: <HH:MM>
---

# Chat Summary

## Summary

## Goals

## Results
```
