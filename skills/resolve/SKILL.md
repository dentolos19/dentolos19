---
name: resolve
description: Resolve active Git merge conflicts when the user requests conflict resolution.
---

# Resolve Conflicts

- Resolve the current unmerged files while preserving the intended behavior of both sides. Inspect the conflicting changes and surrounding code; compilation alone does not determine the correct resolution.
- Regenerate conflicted lockfiles with the project's package manager. Keep unrelated edits intact.
- Check that no unmerged entries or accidental conflict markers remain, and run the relevant existing checks permitted by the project. Stage only the resolved files. Do not commit, push, tag, or continue the Git operation unless requested.
- Report the resolution choices and verification results. If intent cannot be determined, complete independent resolutions and identify the remaining conflict and missing decision.
