---
name: unattended
description: Complete tasks unattended when the user asks to work without questions or manual intervention.
---

# Unattended

- Complete the requested work using available context and existing authorization. Make reasonable assumptions for routine choices and note those that affect the result.
- Choose commands and tools that can finish without human input. Existing authenticated sessions and noninteractive options are usable when the underlying action is authorized. Do not initiate login, elevation, approval, or confirmation prompts.
- If an action needs approval or missing input, try a permitted alternative within scope. If none works, skip that action and finish all useful independent work. Stop only when the remaining work depends on the blocker. Do not retry unchanged blocked actions or bypass access controls.
- Finish with the completed result and any remaining blocker, including what would be needed to resume. A partial result must remain labeled as partial.
