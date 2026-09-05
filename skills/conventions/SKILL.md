---
name: conventions
description: Apply Dennise's project structure, configuration, and formatting conventions whenever creating or changing projects. Use Flexible mode by default and Strict mode only when explicitly requested.
---

# Project Conventions

Inspect the project's instructions, layout, manifests, and configuration first. Apply the relevant conventions below alongside the `dennise` skill.

## Modes

- **Flexible (default)**: Always apply during project work. Fit conventions into the existing structure and tooling. Keep changes within the task; use these defaults for new files and missing configuration without reorganizing unrelated code.
- **Strict (explicit only)**: Enforce every applicable convention across the requested project. Move and rename files, align tooling and formatting, and update imports, scripts, CI, and documentation to match. Existing structure alone is not an exception. Preserve behavior and report any compatibility constraint that prevents compliance.

Explicit user choices take precedence in both modes. Stack recommendations apply when choosing a stack; Strict mode does not itself request a framework rewrite.

## References

Read only what the task needs; read all applicable references for Strict alignment.

- [**Layout**](references/layout.md): Directories, naming, and project boundaries.
- [**Configuration**](references/configuration.md): Commands, package managers, formatting, and environment files.
- [**Documentation**](references/documentation.md): Project documents and titles.
- [**Git**](references/git.md): Tracked files and commits.
- [**Stack**](references/stack.md): Defaults when choosing technologies.
