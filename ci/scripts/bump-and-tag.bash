#!/usr/bin/env bash

set -xeo pipefail

readonly live_run=${LIVE_RUN:-false}
# Release number
readonly version=${VERSION:?input VERSION is required}
# Git actor name
readonly git_user_name=${GIT_USER_NAME:?input GIT_USER_NAME is required}
# Git actor email
readonly git_user_email=${GIT_USER_EMAIL:?input GIT_USER_EMAIL is required}

export GIT_AUTHOR_NAME=$git_user_name
export GIT_AUTHOR_EMAIL=$git_user_email
export GIT_COMMITTER_NAME=$git_user_name
export GIT_COMMITTER_EMAIL=$git_user_email

# cargo +stable install toml-cli

# function toml_set_in_place() {
#   local tmp=$(mktemp)
#   toml set "$1" "$2" "$3" > "$tmp"
#   mv "$tmp" "$1"
# }

# # Bump Cargo version of library and top level toml
# toml_set_in_place ./plugin-library/Cargo.toml "package.version" "$version"
# toml_set_in_place Cargo.toml "package.version" "$version"

# Bump package.json version
JQ=".version=\"$version\""
package_tmp=$(mktemp)
package_json="./ts_project/package.json"
cat ${package_json} | jq "$JQ"  > "$package_tmp"
mv ${package_tmp} ${package_json}

git commit Cargo.toml ./plugin-library/Cargo.toml ${package_json} -m "chore: Bump version to $version"

if [[ ${live_run} ]]; then
  git tag --force "$version" -m "v$version"
fi

git log -10
git show-ref --tags
git push --force origin
git push --force origin "$version"