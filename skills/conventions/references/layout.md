# Layout

## Single Project Layout

```text
.
|-- .github/
|-- .vscode/
|-- docs/
|-- .editorconfig
|-- .env.template
|-- AGENTS.md
|-- DESIGN.md
|-- Justfile
|-- PRODUCT.md
|-- README.md
`-- <other project files>
```

## Multi-Project Layout

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
|-- AGENTS.md
|-- compose.yml
|-- DESIGN.md
|-- Justfile
|-- PRODUCT.md
|-- README.md
`-- <other project files>
```

## TypeScript Application

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
|-- tests/
|-- .editorconfig
|-- Justfile
|-- package.json
`-- <other project files>
```

## Python Application

```text
.
|-- .vscode/
|-- src/
|   `-- main.py
|-- tests/
|-- .editorconfig
|-- .python-version
|-- Justfile
|-- pyproject.toml
`-- <other project files>
```

## Editor

- In `.vscode/`, add a `Setup` task in `tasks.json` that runs `just setup` and a launch configuration in `launch.json` that runs `just start` with `Setup` as its `preLaunchTask`.
