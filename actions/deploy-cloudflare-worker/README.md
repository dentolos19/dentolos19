# Deploy Cloudflare Worker

Deploys a Cloudflare Worker with the project's local Wrangler package, then invokes the companion [`upload-worker-secrets`](../upload-worker-secrets/) action to replace its secrets.

The calling project must install Wrangler before running this action. The action invokes the project's local Wrangler package with `npx --no-install wrangler`.

## Usage

```yaml
- name: Deploy Worker
  uses: dentolos19/dentolos19/actions/deploy-cloudflare-worker@main
  with:
    working-directory: src/worker
    secrets: |
      CLERK_SECRET_KEY
      NOTION_API_KEY
  env:
    CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
    CLERK_SECRET_KEY: ${{ secrets.CLERK_SECRET_KEY }}
    NOTION_API_KEY: ${{ secrets.NOTION_API_KEY }}
```

Use `entrypoint`, `worker-name`, `environment`, or `config` when Wrangler cannot infer the deployment target from the default configuration. Set `minify: "true"` to minify the bundled Worker.
