# Upload Worker Secrets

Purges every existing Cloudflare Worker secret, then bulk uploads selected environment variables as the new secret set.

The calling project must install Wrangler before running this action. The action invokes the project's local Wrangler package with `npx --no-install wrangler`.

## Usage

```yaml
- name: Upload Secrets
  uses: dentolos19/dentolos19/actions/upload-worker-secrets@main
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

Use `working-directory`, `worker-name`, `environment`, or `config` when Wrangler cannot infer the target from the default configuration.
