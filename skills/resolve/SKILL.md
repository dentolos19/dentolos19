---
name: resolve
description: Resolve active Git merge conflicts in the current repository when the user asks to fix conflicted files or complete a conflicted merge, rebase, or cherry-pick.
---

# Resolve Git Conflicts

Resolve every active Git conflict in the current repository. Incorporate any additional instructions from the user.

1. Inspect Git status and identify every unmerged path and the operation in progress.
2. Read the conflict stages, nearby code, and relevant history when needed to understand both sides.
3. Edit each file to preserve compatible intent from both sides. Remove every conflict marker. Do not choose one side mechanically when the changes can be combined.
4. Stage only the files resolved by this task. Do not continue, abort, commit, or push the Git operation unless the user explicitly asks.
5. Verify that Git reports no unmerged paths and search resolved text files for leftover conflict markers.
6. Run the most relevant available checks for the affected code unless the user limits validation. Report any failure with enough detail to continue.

If no conflicts are active, make no changes and report that clearly.
