# Layouts

## Repository Layouts

### Single Project Layout

```
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

```
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

```
.
|-- src/
|   |-- main.py
|-- Makefile
|-- pyproject.toml
`-- <other project files>
```
