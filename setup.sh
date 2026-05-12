#!/usr/bin/env bash
set -e

# Check PowerShell Installation
if ! command -v pwsh &> /dev/null; then
  echo "Please install PowerShell 7 or later before running this script."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Export Environment Variables
if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a
    . "$SCRIPT_DIR/.env"
    set +a
fi

pwsh -NoProfile -File "$SCRIPT_DIR/scripts/setup.ps1"
