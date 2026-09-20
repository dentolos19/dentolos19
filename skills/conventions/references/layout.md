# Layouts

Use this reference when adding, moving, or renaming files and directories, or when defining project boundaries. Preserve the existing layout in Flexible mode unless the task requires a new boundary.

## Repository Layouts

- Keep Drizzle migrations in the repository root `migrations/` directory.

### Single Project Layout

```text
.
|-- .github/
|-- .vscode/
|-- docs/
|-- .editorconfig
|-- AGENTS.md
|-- Justfile
|-- PRODUCT.md
|-- README.md
`-- <other project files>
```

### Multi-Project Layout

```text
.
|-- .github/
|-- .vscode/
|-- docs/
|-- src/
|   |-- app/
|   |-- server/
|   `-- simulator/
|-- .editorconfig
|-- compose.yml
|-- Justfile
`-- <other project files>
```

### TypeScript Application

```text
.
|-- .vscode/
|-- migrations/
|-- public/
|-- src/
|   |-- components/
|   |-- lib/
|   |-- routes/
|   |-- server.ts
|   `-- styles.css
|-- package.json
`-- <other project files>
```

### Python Application

```text
.
|-- .vscode/
|-- src/
|   |-- main.py
|-- .python-version
|-- Justfile
|-- pyproject.toml
`-- <other project files>
```
