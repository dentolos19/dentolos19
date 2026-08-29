# TypeScript Applications

Use these conventions for JavaScript, TypeScript, React, TanStack Start, and Cloudflare Worker boundaries.

## Package And Tooling

- Use Bun by default and commit `bun.lock`. Use `bunx` for one-off package executables that do not need to become project dependencies.
- Mark application packages as private and ESM with `"private": true` and `"type": "module"`.
- Map `#/*` to `./src/*` in both `package.json#imports` and `tsconfig.json#compilerOptions.paths`.
- Use Oxfmt and Oxlint for formatting and linting. The `check` script is `oxfmt --write && oxlint --fix`.
- Use a 120-column Oxfmt width, sorted imports, and sorted Tailwind classes. Exclude generated `src/components/ui/**` primitives from broad mechanical changes when the generator owns their style.
- Keep scripts ordered by lifecycle: `postinstall`, `dev`, `build`, optional `test`, `deploy`, `types`, `check`, then namespaced database or generation scripts.
- Use `postinstall` for required generated platform and route types when the project cannot build without them.
- Keep runtime dependencies in `dependencies` and build, type, lint, format, generation, and CLI tooling in `devDependencies`.
- Preserve versions in an existing application. For new dependencies, verify the current compatible version from official documentation instead of copying a reference project's version.

A typical application script set is:

```json
{
  "scripts": {
    "postinstall": "bun run types",
    "dev": "vite dev",
    "build": "vite build",
    "deploy": "wrangler deploy",
    "types": "wrangler types && tsr generate",
    "check": "oxfmt --write && oxlint --fix",
    "db:generate": "drizzle-kit generate",
    "db:migrate": "wrangler d1 migrations apply DATABASE"
  }
}
```

Include only scripts supported by the application. The root `Makefile` is the public interface and delegates to these scripts.

## TypeScript Configuration

Use strict, bundler-oriented, no-emit configuration for Vite applications:

```json
{
  "include": ["**/*.ts", "**/*.tsx"],
  "compilerOptions": {
    "target": "es2022",
    "module": "esnext",
    "moduleResolution": "bundler",
    "strict": true,
    "jsx": "react-jsx",
    "paths": {
      "#/*": ["./src/*"]
    },
    "types": ["vite/client"],
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "skipLibCheck": true,
    "noEmit": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

Add platform-generated types through the platform's generator rather than weakening the compiler options.

## React And TanStack Start

- Keep `src/router.tsx`, `src/server.ts`, and `src/styles.css` at the application source root.
- Keep the router factory small and deterministic. Enable scroll restoration, intent preloading, and a zero preload stale time unless the product needs different behavior.
- Use file-based route groups and route-local `-components` and `-helpers` folders as described in [layouts.md](layouts.md).
- Put application-wide providers, loading, not-found, access, and error states in `src/components` and assemble them in `src/routes/__root.tsx`.
- Keep UI primitives in `src/components/ui`; build feature composition outside that directory.
- Use `#/` for cross-application imports and relative imports for files inside the same small module or route-local folder.
- Keep components and hooks in kebab-case files. Export route components as required by the router and use named exports for reusable modules unless a framework integration benefits from a default export.
- Keep components focused and move reusable data access or domain behavior to `src/lib` instead of embedding it in page components.

For Vite, use port `3000` for the application, require the port when collisions would create confusing service URLs, resolve TypeScript paths, and order the common plugins as Cloudflare, TanStack Start, React, Tailwind, then development tools. Add a tunnel or extra `envPrefix` only when the project actually uses it.

## UI Configuration

For new UI projects, use shadcn/ui with Base UI. Use TypeScript, CSS variables, a neutral base, Lucide icons, and the same `#/components`, `#/components/ui`, `#/lib`, `#/lib/utils`, and `#/hooks` aliases as the source tree. Keep the CSS path accurate for the application boundary. Do not copy a registry or style variant that the product does not use.

## Data And Platform Code

- For TypeScript applications that need a relational database, use Drizzle ORM and Drizzle Kit by default.
- Put Drizzle configuration at the project boundary root and migrations in that same project's `migrations/` directory.
- Put the schema in `src/lib/database/schema.ts` and database construction in `src/lib/database/index.ts`.
- Use plural SQL table names and singular exported table variables.
- Keep server functions in `src/lib/functions` when they are application use cases. Group larger integrations or subsystems into named folders under `src/lib`.
- Keep Cloudflare bindings or container adapters under `src/lib/bindings` and export the platform-required classes from `src/server.ts`.
- Put `wrangler.json` at the Worker project root. Keep its compatibility date current for deliberate changes, enable only needed bindings, and never copy account IDs, resource IDs, domains, or bucket names.
- Keep the Worker entrypoint thin. It may route platform-specific requests or export bindings, but domain work belongs in the owning library module.
