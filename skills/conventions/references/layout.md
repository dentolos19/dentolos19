# Layouts

Use this reference when adding, moving, or renaming files and directories, or when defining project boundaries. Preserve the existing layout in Flexible mode unless the task requires a new boundary.

## Repository Layouts

### Single Project Layout

```text
.
|-- .github/
|-- .vscode/
|-- docs/
|-- AGENTS.md
|-- Makefile
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
|-- compose.yml
|-- Makefile
`-- <other project files>
```

## Project Layouts

### TypeScript Application

```text
.
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
|-- src/
|   |-- main.py
|-- Makefile
|-- pyproject.toml
`-- <other project files>
```
