#!/usr/bin/env bash

set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN must be set.}"
: "${CLOUDFLARE_ACCOUNT_ID:?CLOUDFLARE_ACCOUNT_ID must be set.}"

wrangler=(npx --no-install wrangler)
flags=()

if [[ -n "$INPUT_WORKER_NAME" ]]; then
  flags+=(--name "$INPUT_WORKER_NAME")
fi
if [[ -n "$INPUT_ENVIRONMENT" ]]; then
  flags+=(--env "$INPUT_ENVIRONMENT")
fi
if [[ -n "$INPUT_CONFIG" ]]; then
  flags+=(--config "$INPUT_CONFIG")
fi

names_json="$(
  printf '%s\n' "$INPUT_SECRETS" |
    tr ',' '\n' |
    jq -Rsc 'split("\n") | map(gsub("^\\s+|\\s+$"; "")) | map(select(length > 0)) | unique'
)"

if [[ "$(jq 'length' <<< "$names_json")" -eq 0 ]]; then
  echo "secrets must contain at least one environment variable name." >&2
  exit 1
fi

while IFS= read -r name; do
  if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "Invalid environment variable name: $name" >&2
    exit 1
  fi
  if [[ ! -v "$name" || -z "${!name}" ]]; then
    echo "Environment variable $name is missing or empty." >&2
    exit 1
  fi
done < <(jq -r '.[]' <<< "$names_json")

purge_file="$(mktemp)"
secrets_file="$(mktemp)"
trap 'rm -f "$purge_file" "$secrets_file"' EXIT
chmod 600 "$purge_file" "$secrets_file"

"${wrangler[@]}" secret list --format json "${flags[@]}" |
  jq 'map({(.name): null}) | add // {}' > "$purge_file"
if [[ "$(jq 'length' "$purge_file")" -gt 0 ]]; then
  "${wrangler[@]}" secret bulk "$purge_file" "${flags[@]}"
fi

jq -n --argjson names "$names_json" \
  '$names | map({key: ., value: env[.]}) | from_entries' > "$secrets_file"
"${wrangler[@]}" secret bulk "$secrets_file" "${flags[@]}"
