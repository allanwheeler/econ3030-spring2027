#!/usr/bin/env bash
# Fail closed before uploading: new public resources must be explicitly approved here.
set -euo pipefail
site="${QUARTO_PROJECT_OUTPUT_DIR:-_site}"
while IFS= read -r path; do
  relative="${path#"$site"/}"
  case "$relative" in
    index.html|schedule.html|resources.html|styles.css|search.json|.nojekyll|site_libs/*|slides/01-first-data-analysis.html|data/teaching/cafe-sales.csv) ;;
    *) printf 'Unexpected publication file: %s\n' "$relative" >&2; exit 1 ;;
  esac
done < <(find "$site" -type f)
for page in index.html schedule.html resources.html slides/01-first-data-analysis.html data/teaching/cafe-sales.csv; do
  test -s "$site/$page" || { printf 'Missing public file: %s\n' "$page" >&2; exit 1; }
done
cmp slides/01-first-data-analysis.html "$site/slides/01-first-data-analysis.html"
printf 'Publication file check passed.\n'
