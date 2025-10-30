#!/usr/bin/env bash
# setup-git-commit-aliases.sh
# Install Git aliases for conventional commits

set -eu

SCOPE="--global"   # global config by default
FORCE="0"          # if --force is given, overwrite existing aliases

usage() {
  cat <<EOF
Usage: $(basename "$0") [--global|--local] [--force]

Options:
  --global   Install aliases in global git config (~/.gitconfig). (default)
  --local    Install aliases in local git config (./.git/config).
  --force    Overwrite existing aliases if they exist.

After installation:
  git commit-fix  "message"
  git commit-feat "message"
  git commit-doc  "message"
  git commit-ref  "message"
  git commit-chore "message"
  git commit-test "message"
  git commit-style "message"
  git commit-perf "message"
  git commit-build "message"
  git commit-ci   "message"
  git commit-revert "message"

Generic alias:
  git cm <type> "message"
  Supported types: fix, feat, docs, refactor, chore, test, style, perf, build, ci, revert

Examples:
  git commit-fix "fix NPE on upload"
  git cm feat "add pagination on /users"
  git cm refactor "isolate UserSync service"
EOF
}

while [ "${#}" -gt 0 ]; do
  case "${1}" in
    --global) SCOPE="--global";;
    --local)  SCOPE="--local";;
    --force)  FORCE="1";;
    -h|--help) usage; exit 0;;
    *) echo "Unknown option: ${1}"; usage; exit 1;;
  esac
  shift
done

# Utility to set an alias
set_alias() {
  name="$1"
  value="$2"

  if [ "$FORCE" = "1" ]; then
    git config $SCOPE "alias.${name}" "${value}"
    echo "✔ alias.${name} (FORCE)"
  else
    if git config $SCOPE --get "alias.${name}" >/dev/null 2>&1; then
      echo "• alias.${name} already exists (skip). Use --force to overwrite."
    else
      git config $SCOPE "alias.${name}" "${value}"
      echo "✔ alias.${name}"
    fi
  fi
}

# Create a "git commit-<tag>" alias => [TAG] : message
mk_commit_alias() {
  tag="$1" # ex: FIX
  # Create an inline shell "subcommand", POSIX compatible
  body='!f(){ msg="$*"; if [ -z "$msg" ]; then printf "Message: "; read msg; fi; git commit -m "['"$tag"'] : $msg"; }; f'
  set_alias "commit-$(echo "$tag" | tr 'A-Z' 'a-z' | sed 's/refactor/ref/g')" "$body"
}

echo "==> Installing Git aliases ($SCOPE)"

# Individual aliases
mk_commit_alias "FIX"
mk_commit_alias "FEAT"
mk_commit_alias "DOC"
mk_commit_alias "REFACTOR"
mk_commit_alias "CHORE"
mk_commit_alias "TEST"
mk_commit_alias "STYLE"
mk_commit_alias "PERF"
mk_commit_alias "BUILD"
mk_commit_alias "CI"
mk_commit_alias "REVERT"

# Generic alias: git cm <type> "message"
# Mapped types -> [TYPE] :
CM_BODY='!f(){
  type="$1"; shift || true
  msg="$*"
  if [ -z "$type" ]; then echo "Usage: git cm <type> \"message\""; exit 1; fi
  if [ -z "$msg" ]; then printf "Message: "; read msg; fi
  case "$type" in
    fix|feat|docs|refactor|chore|test|style|perf|build|ci|revert)
      U=$(printf %s "$type" | tr "a-z" "A-Z")
      git commit -m "[$U] : $msg"
      ;;
    doc) git commit -m "[DOC] : $msg" ;;
    ref) git commit -m "[REFACTOR] : $msg" ;;
    *) echo "Unknown type: $type"; echo "Types: fix feat docs refactor chore test style perf build ci revert"; exit 1 ;;
  esac
}; f'
set_alias "cm" "$CM_BODY"

# Shortcut: git amend => commit --amend --no-edit
set_alias "amend" "commit --amend --no-edit"

# Display what was added
echo
echo "Done. Examples:"
echo '  git commit-fix  "fix bug X"'
echo '  git commit-feat "add Y"'
echo '  git cm refactor "extract logic Z"'
echo '  git amend   # to amend without changing the message'
