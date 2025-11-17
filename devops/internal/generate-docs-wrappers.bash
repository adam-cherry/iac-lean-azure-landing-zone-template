#!/usr/bin/env bash
# Simple Terraform Docs Generator for Wrapper Modules

set -e

BASE_DIR="$(dirname "$0")/../../terraform/modules/wrappers"

echo "🧩 Generating terraform-docs for all wrapper modules in:"
echo "   $BASE_DIR"
echo

for module in "$BASE_DIR"/*/; do
  if [ -f "${module}main.tf" ]; then
    echo "📄 $(basename "$module")"
    terraform-docs markdown table --output-file README.md "$module"
  else
    echo "⚠️  Skipping $(basename "$module") — no main.tf found."
  fi
done

echo
echo "✅ Done — all wrapper module READMEs updated."
