---
name: sync
description: Sync project structure across different user projects. Do not use this skill yet, it is still under development.
---

# Sync

> **Note**: This skill is still under development. Please do not use.

Sync project structure according to Dennise's best templates.

## Workflow

Firstly, determine what kind of project that you are currently working on. The project type definitions are below:

- **Standalone React Web App**: A project built with React and a backend combined together into a single project like TanStack Start.
- **Standalone Python Web App**: A project built with Python web framework like Flask or Django.
- **Full-Stack Web App + Integrated Python Backend**: A project with both frontend and backend components, where the backend is implemented in Python.

## Templates

For each project type, there is a corresponding repository template that you can use to sync your project structure with.

- Standalone React Web App -> `dentolos19/denizen`
- Standalone Python Web App -> `dentolos19/ecoprimers`
- React App + Integrated Python Backend -> `dentolos19/facilix`

Reference the structure strictly, follow the exact configurations from them, even the sort order of the properties.

## Gitignores

All projects should reference the `gitignores` folder from my repository `dentolos19/dentolos19` as a base. Then, you can add project-specific ignores like `.wrangler/`, `.tanstack/`, `.next/`, etc.
