# Configuration

- Always have a `.editorconfig` file within the repository. Refer to `dentolos19` repo for a template.
- Use the `*.gitignore` files in `dentolos19` repo as a base.

## Just

- Use `Justfile` as a central command interface for projects, with commands for setup, building, and deploying.
- Always have `set dotenv-load` at the start of the file to load environment variables.
- For all projects, you must at least have `setup`, `install`, `start`, and `check` recipes.
- Projects can have up to these recipes in this order: `setup`, `install`, `start`, `build`, `check`, `test`, `migrate`, and `deploy`.
- Refer to my project references as a base template.

## VS Code

- You must always have a launch configuration, with the templates below.
- In the reference, strictly follow the same order of keys and values.

### `launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "App",
      "type": "node-terminal",
      "request": "launch",
      "command": "just start",
      "preLaunchTask": "Setup",
      "postDebugTask": "Decompose",
      "serverReadyAction": {
        "pattern": "Local:.+(https?://.+)",
        "uriFormat": "%s",
        "action": "openExternally"
      }
    }
  ]
}
```

### `tasks.json`

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Setup",
      "type": "shell",
      "command": "just setup prerun",
      "presentation": {
        "close": true
      }
    },
    {
      "label": "Decompose",
      "type": "shell",
      "command": "just decompose",
      "presentation": {
        "close": true
      }
    }
  ]
}
```
