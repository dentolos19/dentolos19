# Configuration

- Always have a `.editorconfig` file within the repository. Copy it from the `dentolos19` repository.

## Ignores

- Start `.gitignore` from the one in `dentolos19`, and then add the stack's entries from the closest reference project's `.gitignore`.
- Sync other ignore files, including `.dockerignore`, using the local `.gitignore` as the base.
- Put normal rules at the top and exception rules at the bottom, with an empty line separating them.
- Sort each group in byte order, as `LC_ALL=C sort` does: symbols, then uppercase, then lowercase. Do not add comments.

## Environment

- List every variable the application reads in `.env.template`, sorted in byte order. Omit `.env.template` when the application reads no environment variables.
- Leave secrets empty as `KEY=""`, and fill in non-secret defaults, such as model names.
- Keep deployment credentials, such as `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_API_TOKEN`, out of `.env.template`. Set them in the workflow's top-level `env` from repository secrets.
- Keep real values in `.env`, or `.env.<environment>` for other environments, such as `.env.production`.
- In multi-project repositories, keep each project's dotenv files inside that project (for example, `src/app/.env`) rather than at the root.
- When adding, renaming, or removing a variable, update `.env.template`, the deployment workflow's secrets step, and the GitHub environment in the same change.

## Just

Use a `Justfile` as the central command interface. Start with this header:

```just
set dotenv-load
set dotenv-filename := dotenv_file
set dotenv-override

environment := ""
dotenv_file := if environment == "" { ".env" } else { ".env." + environment }
```

- Always include `setup`, `install`, `start`, and `check` recipes.
- Add others only as needed, in this order: `setup`, `install`, `start`, `compose`, `decompose`, `build`, `check`, `test`, `migrate`, `seed`, `deploy`. Put project-specific recipes after the closest standard one.
- Propagate the environment to nested commands with `just environment={{ quote(environment) }} <recipe>`. In multi-project repositories, nested `just` calls can pass `--dotenv-path`, which resolves relative to the `Justfile`'s directory.
- Use frozen dependency installs, such as `bun install --frozen-lockfile` and `uv sync --frozen`.
- For Bun checks, use `bun lint --fix && bun fmt && bun check --no-script`.
- For Python checks, use `uv run ruff check --fix && uv run ruff format && uv run ty check`.
- Skip `compose` and `decompose` when `CI=true`. Add `compose` as a dependency of recipes that need local services.

## TypeScript

- In `tsconfig.json`, put `include` and `exclude`, when present, before `compilerOptions`.
- Remove stale includes and exclusions, unused cache settings, and compiler options that repeat defaults. Keep framework-required settings, generated Cloudflare declarations, aliases, and intentional strictness options.

## GitHub Actions

- Order a workflow's top-level keys as `name`, `run-name`, `on`, `permissions`, `concurrency`, `env`, and `jobs`. Set `run-name` to match `name`, with an optional suffix in parentheses, such as the target environment.
- Use `${{ github.workflow }}-${{ github.ref_name }}` as the concurrency group, with `cancel-in-progress: true`.
- Give jobs and steps Title Case names, such as `Checkout Source`, `Setup Bun`, and `Deploy Worker`. Separate steps with an empty line.
- Deploy from a `Production` environment. Write the dotenv file with `SpicyPizza/create-envfile`, one sorted `envkey_<NAME>: ${{ toJSON(secrets.<NAME>) }}` per variable, using `vars` instead of `secrets` for non-secret values (with `directory` set to the project path, such as `src/app`, in multi-project repositories). Then run `just deploy`. Skip `create-envfile` when the application reads no environment variables.
- Format cache keys as `v{version}-{group}-{dependencies}`. Group names must contain no spaces or dashes. Include only inputs needed for cache invalidation or isolation. Use matching version, group, and scope prefixes for `restore-keys`. Separate save steps must reuse the restore step's `cache-primary-key`. Bump the version when the cache format becomes incompatible.
