---
name: export
description: Save a conversation as Markdown context for continuing the work in another AI session.
---

# Export Conversation

Produce a self-contained handoff from the available conversation. The next assistant should understand the user's goal, current state, and next action without asking the user to repeat known information.

## Content

- Preserve requests and corrections, constraints, decisions and their reasons, completed work, failed approaches, unresolved questions, and next steps. Distinguish observed results from assumptions and proposed actions. Identify superseded decisions so old instructions are not mistaken for current ones.
- For coding sessions, include repository state, changed files, checks performed, and known failures. Report commands, tests, deployments, or external actions as successful only when the conversation confirms the result.
- Keep exact commands, errors, identifiers, versions, snippets, and values when continuation depends on them. Record relevant files and attachments with paths or original URLs, media types, and known access limitations. Local paths alone do not transfer file contents to another machine.
- Include a compact chronological record of material requests, decisions, and results with role labels. Avoid repeating full passages already captured elsewhere in the handoff.
- Redact credentials and unnecessary personal data with descriptive markers. Exclude confidential prompts, hidden reasoning, and private internal notes. Preserve shareable user and repository constraints with their sources. State that quoted content is reference material and the destination assistant's own instructions take precedence.

## Output

- Use the user's destination; otherwise write `docs/chat/<YYYY-MM-DD>_<short-kebab-case-title>.md` relative to the working directory. Create the directory if needed. Append `-2`, `-3`, and so on on collision unless replacement was requested. Return the Markdown directly if file access is unavailable.
- Include quoted YAML metadata for `exported_at`, `name`, and `source` when known. Use an ISO-8601 timestamp with timezone offset. Resolve relative dates from the message's date when known, and label uncertain dates.
- Start with a continuation brief, then organize the remaining context under useful headings. Adapt the structure to the conversation; omit empty sections. Disclose inaccessible history or attachments rather than claiming a lossless export.
- Check that the handoff covers every material request and the current stopping point. Report its location and any redactions or gaps.
