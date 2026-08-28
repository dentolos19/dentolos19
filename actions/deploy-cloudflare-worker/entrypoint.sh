#!/usr/bin/env bash

set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN must be set.}"
: "${CLOUDFLARE_ACCOUNT_ID:?CLOUDFLARE_ACCOUNT_ID must be set.}"

if [[ "$INPUT_MINIFY" != "true" && "$INPUT_MINIFY" != "false" ]]; then
  echo "minify must be either true or false." >&2
  exit 1
fi

deploy_args=(npx --no-install wrangler deploy)
if [[ -n "$INPUT_ENTRYPOINT" ]]; then
  deploy_args+=("$INPUT_ENTRYPOINT")
fi
if [[ -n "$INPUT_WORKER_NAME" ]]; then
  deploy_args+=(--name "$INPUT_WORKER_NAME")
fi
if [[ -n "$INPUT_ENVIRONMENT" ]]; then
  deploy_args+=(--env "$INPUT_ENVIRONMENT")
fi
if [[ -n "$INPUT_CONFIG" ]]; then
  deploy_args+=(--config "$INPUT_CONFIG")
fi
if [[ "$INPUT_MINIFY" == "true" ]]; then
  deploy_args+=(--minify)
fi

"${deploy_args[@]}"
