# Layout

- Keep repository-wide configuration, `Makefile`, and project documents at the root. Create directories only when needed.
- Keep a single application's manifest and framework configuration at its root, with source in `src/` and static assets in `public/`.
- Put independently run applications under `src/<name>/`, such as `src/app/`, `src/server/`, or `src/scraper/`. Each owns its manifest, configuration, source, and lockfile unless managed by a shared workspace.
- In web apps, use `src/components/` and `src/lib/`. Keep routes in the framework's route directory and co-locate feature-specific files.
- Use kebab-case for TypeScript component and utility filenames, snake_case for Python modules, and native language or framework naming where required.
- Put database migrations in `migrations/` at the owning app's root and database code under `src/lib/database/`.
- Use `scripts/` for maintained utilities, `docs/` for documentation, and `.tmp/` for temporary work.
- Keep shared container orchestration in root `compose.yml`; keep service-specific Dockerfiles with their services.
