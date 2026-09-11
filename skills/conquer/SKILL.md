---
name: conquer
description: Coordinate subagents for complex tasks with independent workstreams or explicit requests to parallelize.
---

# Conquer

- Divide work where independent progress will reduce completion time or improve the result. Keep small or tightly coupled tasks together. If delegation is unavailable, work through the same dependencies locally.
- Give each subagent a bounded objective, necessary context, expected output, and any dependencies. Assign clear file ownership in shared workspaces; serialize overlapping edits. Use available concurrency without creating redundant assignments.
- Keep architectural choices, integration, and final verification with the lead agent. Continue useful work while delegates run, and reuse agents for related follow-ups.
- Review returned changes and evidence, resolve conflicting assumptions, and integrate in dependency order. Delegated work is complete only when the combined result satisfies the user's request. Finish independent work around blockers and report unresolved dependencies.
