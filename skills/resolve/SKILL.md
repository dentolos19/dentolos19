---
name: resolve
description: Inspect and resolve active Git conflicts during merges, rebases, cherry-picks, and reverts. Use when files are unmerged or the user asks to reconcile conflicting changes without continuing the Git operation automatically.
---

# Resolve Git Conflicts

Resolve every active conflict in the current repository unless the user limits the scope. A correct resolution preserves the intended behavior of both changes where they are compatible and makes an explicit choice where they are not.

## Workflow

1. Inspect `git status`, the unmerged path list, and the index stages before editing. Determine whether Git is performing a merge, rebase, cherry-pick, or revert. Record pre-existing staged and unstaged changes so they remain outside the resolution.
2. For each unmerged path, identify its conflict type and inspect the merge base, stage 2, and stage 3 when available. Read the surrounding code, related files, relevant commits, and local project instructions before deciding the intended result.
3. Resolve the file as a whole. Do not limit the review to visible conflict markers because one side may depend on adjacent changes, renamed symbols, new files, or configuration elsewhere.
4. Stage each resolved path after checking its complete diff. Stage deletions with Git as well. Never stage unrelated files or discard changes that existed before this task.
5. Verify that Git reports no unmerged index entries. Search the resolved text files for conflict markers and inspect every match, since marker-like text may be intentional fixture data.
6. Run the smallest relevant existing checks for the affected files and their dependents. Use the project's established package manager and tooling. Do not add tests solely for conflict resolution.
7. Report the resolution chosen for each file, any behavior that required judgment, the checks run, remaining non-conflict changes, and whether the Git operation is ready to continue.

## Interpreting Conflict Stages

- Stage 1 is the merge base, stage 2 is `ours`, and stage 3 is `theirs`.
- During a normal merge, `ours` is the checked-out branch and `theirs` is the branch being merged.
- During a rebase, the labels are counterintuitive: `ours` is the branch onto which commits are being rebased, while `theirs` is the commit currently being replayed. Use the operation context and commit history, not the labels alone.
- A missing stage can represent an add/add, modify/delete, rename/delete, or related tree conflict. Inspect status and history before keeping or deleting the path.

## Resolution Rules

- Combine independent changes and reconcile overlapping changes according to their behavior. Never choose `ours` or `theirs` mechanically.
- For modify/delete and rename conflicts, determine whether the deletion or rename was intentional and whether the modified content still belongs at another path.
- Preserve public interfaces, schema changes, migrations, configuration keys, and environment variable names required by either compatible change. Update affected callers and references when the resolution changes a name or location.
- Resolve manifests before lockfiles. Regenerate a conflicted lockfile with the project's established package manager when the resolved manifest requires it; do not hand-edit generated lock data unless the project does so normally.
- Resolve generated files from their source when a deterministic generator exists. Avoid mixing generated fragments from both sides.
- For binary files, submodules, secrets, or two genuinely incompatible product decisions, use repository history and explicit user instructions. If intent remains ambiguous and the choice changes behavior or loses data, stop and ask the user rather than guessing.

## Safety Boundaries

- Do not run `git merge --continue`, `git rebase --continue`, `git cherry-pick --continue`, `git revert --continue`, `git commit`, `git push`, or any abort command unless the user explicitly asks.
- Do not use destructive checkout, reset, or clean commands to resolve conflicts.
- Do not rewrite unrelated files or use broad formatting commands that touch files outside the resolution.

If no conflicts are active, make no changes and report that clearly.
