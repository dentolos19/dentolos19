---
name: review
description: Review uncommitted code changes before commit.
---

# Review Changes

- Review staged, unstaged, and untracked changes as one change set. Trace affected behavior through relevant callers and dependencies, distinguishing introduced defects from pre-existing issues.
- Focus on actionable correctness, security, data-loss, and usability problems. Use applicable best-practice skills and primary documentation when they help assess the changes. Avoid speculative findings and unrelated cleanup.
- For review-only requests, report findings without editing. When fixes are requested, complete them within scope, preserve unrelated work, and review the resulting change set.
- Run relevant existing checks according to repository instructions and report verification gaps. Do not commit, push, or deploy unless requested.
- Report findings by severity with file and line references, impact, and a concrete correction. For review-and-fix requests, lead with the result and important fixes. Include check results and remaining risks, and say explicitly when no actionable findings remain.
