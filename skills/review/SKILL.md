---
name: review
description: Review pending changes, branches, or PRs against repository standards and the request or spec. Fix findings when requested.
---

# Code Review

- Use the requested scope. Default to staged, unstaged, and untracked changes together. For branch or PR reviews, validate the base and head and compare against their merge-base; include pending changes only when requested.
- Review two axes independently: **Standards**, covering actionable defects and relevant repository conventions; and **Spec**, covering missing, incorrect, or unrequested behavior against the user's request, issue, or spec. Use independent reviewers when useful. If no requirement source is available, report the spec review as skipped rather than inventing requirements.
- Read relevant standards and trace affected behavior through callers and dependencies. Use `conventions` and primary documentation where needed. Treat code smells as judgment calls, subordinate to repository rules; report concrete costs rather than speculative cleanup or style already enforced by tooling.
- Keep review-only work read-only. When fixes are requested, complete them, preserve unrelated work, and verify the resulting changes with relevant checks. Do not commit, push, deploy, or post external comments unless requested.
- Report findings separately under `Standards` and `Spec`, ordered by severity within each. Include file and line references, evidence or the applicable requirement, impact, and a concrete correction. Cross-reference overlapping findings. For fixes, lead with the result; include remaining findings, check results, and verification gaps. State when an axis has no actionable findings or was skipped.
