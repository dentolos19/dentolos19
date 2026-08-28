#!/usr/bin/env bash

set -euo pipefail

: "${FLY_API_TOKEN:?FLY_API_TOKEN must be set.}"

if [[ "$INPUT_STAGE" != "true" && "$INPUT_STAGE" != "false" ]]; then
  echo "stage must be either true or false." >&2
  exit 1
fi

names="$({
  printf '%s\n' "$INPUT_SECRETS" |
    tr ',' '\n' |
    sed 's/^[[:space:]]*//; s/[[:space:]]*$//' |
    sed '/^$/d' |
    sort -u
})"

if [[ -z "$names" ]]; then
  echo "secrets must contain at least one environment variable name." >&2
  exit 1
fi

existing_secrets_file="$(mktemp)"
secrets_file="$(mktemp)"
trap 'rm -f "$existing_secrets_file" "$secrets_file"' EXIT
chmod 600 "$existing_secrets_file" "$secrets_file"

while IFS= read -r name; do
  if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "Invalid environment variable name: $name" >&2
    exit 1
  fi
  if [[ ! -v "$name" || -z "${!name}" ]]; then
    echo "Environment variable $name is missing or empty." >&2
    exit 1
  fi
  if [[ "${!name}" == *$'\n'* || "${!name}" == *$'\r'* ]]; then
    echo "Environment variable $name contains a line break, which Flyctl secret imports do not support." >&2
    exit 1
  fi

  printf '%s=%s\n' "$name" "${!name}" >> "$secrets_file"
done <<< "$names"

flags=()
if [[ -n "$INPUT_APP" ]]; then
  flags+=(--app "$INPUT_APP")
fi
if [[ -n "$INPUT_CONFIG" ]]; then
  flags+=(--config "$INPUT_CONFIG")
fi
flyctl secrets list --json "${flags[@]}" > "$existing_secrets_file"
if ! jq -e \
  '. == null or (type == "array" and all(.[]; ((.name // .Name) | type) == "string"))' \
  "$existing_secrets_file" > /dev/null; then
  echo "Flyctl returned an unexpected secrets list." >&2
  exit 1
fi

mapfile -t existing_names < <(jq -r '(. // []) | .[] | .name // .Name' "$existing_secrets_file")
if [[ "${#existing_names[@]}" -gt 0 ]]; then
  flyctl secrets unset --stage "${flags[@]}" "${existing_names[@]}"
fi

if [[ "$INPUT_STAGE" == "true" ]]; then
  flags+=(--stage)
fi
flyctl secrets import "${flags[@]}" < "$secrets_file"
