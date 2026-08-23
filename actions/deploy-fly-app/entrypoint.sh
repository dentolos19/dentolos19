#!/usr/bin/env bash

set -euo pipefail

: "${FLY_API_TOKEN:?FLY_API_TOKEN must be set.}"

if [[ "$INPUT_HIGH_AVAILABILITY" != "true" && "$INPUT_HIGH_AVAILABILITY" != "false" ]]; then
  echo "high-availability must be either true or false." >&2
  exit 1
fi

case "$INPUT_STRATEGY" in
  canary | rolling | bluegreen | immediate) ;;
  *)
    echo "strategy must be canary, rolling, bluegreen, or immediate." >&2
    exit 1
    ;;
esac

if [[ ! "$INPUT_MACHINE_COUNT" =~ ^[0-9]+$ ]]; then
  echo "machine-count must be a non-negative integer." >&2
  exit 1
fi
if [[ -n "$INPUT_MAX_PER_REGION" && ! "$INPUT_MAX_PER_REGION" =~ ^[0-9]+$ ]]; then
  echo "max-per-region must be a non-negative integer." >&2
  exit 1
fi

deploy_args=(deploy "--ha=$INPUT_HIGH_AVAILABILITY" --strategy "$INPUT_STRATEGY")
if [[ -n "$INPUT_APP" ]]; then
  deploy_args+=(--app "$INPUT_APP")
fi
if [[ -n "$INPUT_CONFIG" ]]; then
  deploy_args+=(--config "$INPUT_CONFIG")
fi

flyctl "${deploy_args[@]}"

scale_args=(scale count "$INPUT_MACHINE_COUNT" --yes)
if [[ -n "$INPUT_APP" ]]; then
  scale_args+=(--app "$INPUT_APP")
fi
if [[ -n "$INPUT_CONFIG" ]]; then
  scale_args+=(--config "$INPUT_CONFIG")
fi
if [[ -n "$INPUT_PROCESS_GROUP" ]]; then
  scale_args+=(--process-group "$INPUT_PROCESS_GROUP")
fi
if [[ -n "$INPUT_REGIONS" ]]; then
  scale_args+=(--region "$INPUT_REGIONS")
fi
if [[ -n "$INPUT_MAX_PER_REGION" ]]; then
  scale_args+=(--max-per-region "$INPUT_MAX_PER_REGION")
fi

flyctl "${scale_args[@]}"
