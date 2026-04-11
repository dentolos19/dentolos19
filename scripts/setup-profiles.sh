#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Profiles..."

cp "$SCRIPT_DIR/../configs/biome.json" "$HOME/biome.json"
cp "$SCRIPT_DIR/../.editorconfig" "$HOME/.editorconfig"

echo "Profiles installed successfully!"
