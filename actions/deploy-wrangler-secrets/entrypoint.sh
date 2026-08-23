#!/usr/bin/env bash

set -euo pipefail

: "${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN must be set.}"
: "${CLOUDFLARE_ACCOUNT_ID:?CLOUDFLARE_ACCOUNT_ID must be set.}"

if [[ "$INPUT_PRUNE" != "true" && "$INPUT_PRUNE" != "false" ]]; then
  echo "prune must be either true or false." >&2
  exit 1
fi

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

secrets_file="$(mktemp)"
existing_secrets_file="$(mktemp)"
trap 'rm -f "$secrets_file" "$existing_secrets_file"' EXIT
chmod 600 "$secrets_file" "$existing_secrets_file"
printf '{}\n' > "$existing_secrets_file"

if [[ "$INPUT_PRUNE" == "true" ]]; then
  "${wrangler[@]}" secret list --format json "${flags[@]}" |
    jq 'map({(.name): null}) | add // {}' > "$existing_secrets_file"
fi

jq -n --argjson names "$names_json" --slurpfile existing "$existing_secrets_file" \
  '($existing[0] // {}) + ($names | map({key: ., value: env[.]}) | from_entries)' \
  > "$secrets_file"
"${wrangler[@]}" secret bulk "$secrets_file" "${flags[@]}"
