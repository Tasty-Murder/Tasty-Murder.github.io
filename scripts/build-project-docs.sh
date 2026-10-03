#!/usr/bin/env bash
# Build each project's MkDocs docs into public/projects/<name>/.
#
# Every site deploy rebuilds every project's docs from its default branch,
# so a blog-only deploy never drops them. Project repos trigger a rebuild
# when their docs change by sending a `project-docs-updated`
# repository_dispatch to this repo.
#
# PROJECTS_TOKEN: fine-grained PAT with Contents: read on each project repo
# (they may be private). Required — deploying without it would wipe the
# live docs.
set -euo pipefail

# name  repo
PROJECTS=(
  "regshot-rs Tasty-Murder/regshot-rs"
)

: "${PROJECTS_TOKEN:?PROJECTS_TOKEN secret is not set — see scripts/build-project-docs.sh}"

root=$(pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

for entry in "${PROJECTS[@]}"; do
  read -r name repo <<<"$entry"
  echo "::group::$name ($repo)"
  src="$work/$name"
  git clone --quiet --depth 1 --filter=blob:none --sparse \
    "https://x-access-token:${PROJECTS_TOKEN}@github.com/${repo}.git" "$src"
  git -C "$src" sparse-checkout set docs
  python3 -m venv "$work/$name-venv"
  "$work/$name-venv/bin/pip" install --quiet -r "$src/docs/requirements.txt"
  # The project's mkdocs.yml must set site_url to
  # https://tasty-murder.github.io/projects/<name>/.
  (cd "$src" && "$work/$name-venv/bin/mkdocs" build --strict \
    --site-dir "$root/public/projects/$name")
  echo "::endgroup::"
done
