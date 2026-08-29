# Makefile Interface

The root `Makefile` is the canonical interface for people working in the repository. Package scripts and runtime CLIs remain available, but documentation and routine instructions lead with `make`.

## Standard Targets

| Target     | Requirement                                             | Meaning                                                                                                                      |
| ---------- | ------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `setup`    | Always.                                                 | Perform first-start initialization and install every project boundary's dependencies without overwriting user configuration. |
| `check`    | Always.                                                 | Format and lint every maintained code boundary using its established auto-fix commands.                                      |
| `start`    | Always.                                                 | Start the complete local application, including every process required for its normal development path.                      |
| `build`    | When the project builds an artifact.                    | Build all production artifacts without deploying them.                                                                       |
| `migrate`  | When a database has migrations.                         | Apply local development migrations for every owning boundary.                                                                |
| `seed`     | When repeatable seed data exists.                       | Seed only the local development data store by default.                                                                       |
| `test`     | Only when a test suite exists or the user requests one. | Run the established test suites; do not create an empty test target.                                                         |
| `deploy`   | Only when local deployment is intentionally supported.  | Invoke the explicit deployment path; never run it without user authorization.                                                |

Add service-specific targets such as `start-app`, `start-server`, `logs-server`, or `migrate-app` when they are useful, but keep the standard aggregate target authoritative. `make start` must not start only the frontend in a frontend-plus-backend repository.

For a CLI, `make start` invokes its entrypoint. If the command requires input, accept a documented variable such as `make start ARGS="<arguments>"` and pass `$(ARGS)` to the entrypoint.

Declare every action target in `.PHONY`. Keep target names lowercase and use hyphens for qualifiers. Put the common onboarding targets first: `setup`, `start`, and `check`, followed by conditional lifecycle targets.

## Recipe Rules

- Delegate to the package-local command instead of duplicating its implementation. Use `cd src/app && bun run ...`, `cd src/server && uv run ...`, or `$(MAKE) -C <directory> ...` when the nested directory intentionally has its own Makefile.
- Run all relevant boundaries from aggregate targets. A failure in any setup, check, build, migration, or generation step must fail the Make target.
- Keep `setup` idempotent. It may install dependencies and generate local types. It must not replace `.env`, reset a database, migrate a remote database, or deploy infrastructure.
- Make `migrate`, `seed`, and other unqualified data targets local. Name remote variants explicitly, such as `migrate-remote`, and require the deployment context the command actually needs.
- Let `check` apply formatting before lint auto-fixes. Do not hide substantive command output or swallow failures.
- Keep shell orchestration portable to the repository's supported development environments. Do not require a process-manager dependency solely to run two commands.
- Use variables only for values that genuinely vary. Do not turn a short Makefile into an indirection layer.
- Keep CI-specific frozen installs in CI when local `setup` intentionally updates or resolves the lockfile.

## Single TypeScript Example

```makefile
.PHONY: setup start check build migrate

setup:
	bun install

start:
	bun run dev

check:
	bun run check

build:
	bun run build

migrate:
	bun run db:migrate
```

Omit conditional targets such as `build` or `migrate` when the project does not support them. A standalone Python application follows the same shape with `uv sync`, `uv run main.py`, and Ruff commands.

## Mixed-Runtime Example

Use named development subtargets and run them concurrently through Make:

```makefile
.PHONY: setup start start-app start-server check migrate

setup:
	cd src/app && bun install
	cd src/server && uv sync

start:
	$(MAKE) -j 2 start-app start-server

start-app:
	cd src/app && bun run dev

start-server:
	cd src/server && uv run main.py

check:
	cd src/app && bun run check
	cd src/server && uv run ruff format
	cd src/server && uv run ruff check --fix

migrate:
	cd src/app && bun run db:migrate
```

Adjust the job count and subtargets to the processes required by the real development path. If the TypeScript development server already starts or embeds a Python container, do not start a duplicate backend process; include any separate simulator or dependency that is still required.

## Documentation And Editor Integration

Show `make setup`, `make start`, and `make check` in the README and contribution instructions. Explain package-local commands only when maintainers need to run one boundary independently.

Keep `.vscode/launch.json` aligned with the Make interface. The primary launch configuration should run `make start` from the repository root. Optional `App` and `Server` configurations may call the corresponding service-specific Make targets, with a compound configuration when that improves debugging.
