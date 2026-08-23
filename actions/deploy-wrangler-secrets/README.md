# Deploy Wrangler Secrets

Bulk uploads selected environment variables as Cloudflare Worker secrets. By default, the same bulk request deletes secrets omitted from the upload, matching the final state produced by `denizen` without temporarily removing every secret.

The calling project must install Wrangler before running this action. The action invokes the project's local Wrangler package with `npx --no-install wrangler`.

## Usage

```yaml
- name: Upload Secrets
  uses: dentolos19/dentolos19/actions/deploy-wrangler-secrets@main
  with:
    secrets: |
      CLERK_SECRET_KEY
      NOTION_API_KEY
      FILLOUT_API_KEY
  env:
    CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
    CLERK_SECRET_KEY: ${{ secrets.CLERK_SECRET_KEY }}
    NOTION_API_KEY: ${{ secrets.NOTION_API_KEY }}
    FILLOUT_API_KEY: ${{ secrets.FILLOUT_API_KEY }}
```

Set `prune: "false"` to preserve secrets that are not part of the current upload. Use `working-directory`, `worker-name`, `environment`, or `config` when Wrangler cannot infer the target from the default configuration.
