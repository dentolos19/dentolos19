# Deploy Fly App

Invokes the companion [`upload-fly-secrets`](../upload-fly-secrets/) action to replace and stage the app's secrets, deploys the app, and applies its target Machine count. The defaults match the existing `facilix` simulator deployment: immediate strategy, high availability disabled, and one Machine.

CPU and memory sizing belong in the app's `[[vm]]` section in `fly.toml`. Flyctl applies that configuration during both deployment and Machine count changes.

## Usage

```yaml
- name: Deploy Simulator
  uses: dentolos19/dentolos19/actions/deploy-fly-app@main
  with:
    working-directory: src/simulator
    secrets: |
      DATABASE_URL
      API_KEY
    machine-count: "1"
    regions: sin
    max-per-region: "1"
  env:
    FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    API_KEY: ${{ secrets.API_KEY }}
```

Use `app` or `config` when Flyctl cannot infer the app from the default `fly.toml`. Use `process-group` to apply the count to one process group.
