#!/usr/bin/env bash
# Build only the public website. Keep this version aligned with website.yml.
set -euo pipefail
cd "$(dirname "$0")/.."
quarto_version="1.10.18"

if ! command -v quarto >/dev/null 2>&1 || [[ "$(quarto --version)" != "$quarto_version" ]]; then
  if [[ "$(uname -s)" != Linux || "$(uname -m)" != x86_64 ]]; then
    printf 'Install Quarto %s locally before running this script.\n' "$quarto_version" >&2
    exit 1
  fi
  quarto_tmp="$(mktemp -d)"
  trap 'rm -rf "$quarto_tmp"' EXIT
  curl --fail --location --retry 3 \
    "https://github.com/quarto-dev/quarto-cli/releases/download/v${quarto_version}/quarto-${quarto_version}-linux-amd64.tar.gz" \
    --output "$quarto_tmp/quarto.tar.gz"
  tar -xzf "$quarto_tmp/quarto.tar.gz" -C "$quarto_tmp"
  export PATH="$quarto_tmp/quarto-${quarto_version}/bin:$PATH"
fi

quarto render
