# Upload Fly Secrets

Installs Flyctl, purges every existing Fly app secret, and uploads selected environment variables as the new secret set. The purge and upload are staged by default so the companion [`deploy-fly-app`](../deploy-fly-app/) action can apply them without causing an additional Machine deployment.

## Usage

```yaml
- name: Upload Secrets
  uses: dentolos19/dentolos19/actions/upload-fly-secrets@main
  with:
    working-directory: src/simulator
    secrets: |
      DATABASE_URL
      API_KEY
  env:
    FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    API_KEY: ${{ secrets.API_KEY }}
```

Set `stage: "false"` to deploy the secrets immediately. Use `app` or `config` when Flyctl cannot infer the app from the default `fly.toml`.
