# Python Applications

Use these conventions for Python web applications, APIs, CLIs, workers, containers, and simulators.

## Package And Tooling

- Use uv exclusively for dependency management and commit `uv.lock`.
- Keep project metadata and dependencies in `pyproject.toml`; do not duplicate them in `requirements.txt` or another package manager.
- Use Python 3.13 for a new project unless a dependency or deployment platform requires another supported version. Record the real compatibility range in `requires-python`.
- Start application versions at `1.0.0` unless the user specifies a different release policy.
- Put development dependencies in `[dependency-groups]`. Use Ruff as the default development dependency and set its line length to 120.
- Keep dependency constraints minimal, adding lower or upper bounds only for a known feature or compatibility requirement.
- Use `uv sync` for setup and `uv run` for local commands. Do not rely on a globally installed application dependency.

A minimal `pyproject.toml` is:

```toml
[project]
name = "project-name"
version = "1.0.0"
requires-python = ">=3.13"
dependencies = []

[dependency-groups]
dev = ["ruff"]

[tool.ruff]
line-length = 120
```

## Application Shape

- Use `main.py` as the application entrypoint for both `uv run main.py` and an import string such as `main:app`.
- Keep a small application flat. Split by responsibility only when the code warrants it, using `routes/`, `lib/`, or a specific subsystem package.
- Keep application assembly in `main.py`: construct the app, register routers, connect lifecycle hooks, and provide the executable guard. Put request handlers, integrations, and algorithms in their owning modules.
- For FastAPI, define feature routers in `routes/` and include them from `main.py`. Put request and response models beside the route when they are feature-specific; move truly shared models to their domain module.
- Put databases, AI clients, storage, external APIs, and other infrastructure in `lib/`.
- Prefer descriptive module names over an expanding `utils.py`. Keep `utils.py` only for genuinely shared, low-level helpers in a small application.
- Use snake_case modules and functions, PascalCase classes, and uppercase constants. Let Ruff normalize imports and formatting.

## Environment And Configuration

Centralize environment reads per application boundary. Use `environment.py` for required variables, secrets, and validation. Use `config.py` for operational constants and derived settings when that distinction helps the service.

- Load dotenv once near the environment boundary and do not override variables already supplied by Docker or the platform.
- Strip surrounding single or double quotes when reading values because local `.env` values are intentionally double-quoted.
- Raise a descriptive error for a required missing variable.
- Provide defaults only for safe local URLs, non-secret operational settings, and explicit development behavior.
- Keep secrets wrapped or otherwise protected from accidental logging when the framework provides a suitable secret type.
- Keep one `.env.template` beside the boundary that owns the variables. Use uppercase names and double-quoted placeholders.

Do not spread direct `os.environ` reads across request handlers and domain modules when a central environment or configuration module can own them.

## Checks And Execution

The root Makefile exposes the standard commands. The Python implementation is:

```makefile
.PHONY: setup start check

setup:
	uv sync

start:
	uv run main.py

check:
	uv run ruff format
	uv run ruff check --fix
```

For an ASGI service, production starts with an explicit server command such as `uvicorn main:app --host 0.0.0.0 --port <port>`. Keep the `if __name__ == "__main__"` path useful for local development.

Do not add pytest, mypy, or another checker merely as boilerplate. Add and expose them only when the project or user requires them.
