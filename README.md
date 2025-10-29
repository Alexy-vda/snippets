# Snippets Repository

This repository contains a collection of useful code snippets for various usage.

## Table of Contents

- [Git Conventional Commits] (#git-conventional-commits)

## Git Conventional Commits

A collection of git aliases to help enforce conventional commit messages and keep consistency across git history.

### Available Aliases

**Individual commit aliases:**

```bash
git commit-fix   "message"   # [FIX] : message
git commit-feat  "message"   # [FEAT] : message
git commit-doc   "message"   # [DOC] : message
git commit-ref   "message"   # [REFACTOR] : message
git commit-chore "message"   # [CHORE] : message
git commit-test  "message"   # [TEST] : message
git commit-style "message"   # [STYLE] : message
git commit-perf  "message"   # [PERF] : message
git commit-build "message"   # [BUILD] : message
git commit-ci    "message"   # [CI] : message
git commit-revert "message"  # [REVERT] : message
```

**Generic alias:**

```bash
git cm <type> "message"
# Supported types: fix, feat, docs, refactor, chore, test, style, perf, build, ci, revert
```

**Additional shortcuts:**

```bash
git amend  # Amend last commit without changing the message
```

### Commit Message Format

These commands create commit messages with the following format:

```text
[TYPE] : message
```

**Examples:**

```bash
git commit-fix "fix NPE on upload"          # Creates: [FIX] : fix NPE on upload
git cm feat "add pagination on /users"      # Creates: [FEAT] : add pagination on /users
git cm refactor "isolate UserSync service"  # Creates: [REFACTOR] : isolate UserSync service
```

### Installation

You can install these aliases by running the following command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Alexy-vda/snippets/main/scripts/setup-git-commit-aliases.sh \
  | sh -s -- --global
```

**Options:**

- `--global` : Install aliases in global git config (~/.gitconfig) - **default**
- `--local` : Install aliases in local git config (./.git/config)
- `--force` : Overwrite existing aliases if they exist

**Examples:**

```bash
# Install globally (default)
curl -fsSL https://raw.githubusercontent.com/Alexy-vda/snippets/main/scripts/setup-git-commit-aliases.sh | sh -s -- --global

# Install locally in a specific repository
cd /path/to/your/repo
curl -fsSL https://raw.githubusercontent.com/Alexy-vda/snippets/main/scripts/setup-git-commit-aliases.sh | sh -s -- --local

# Force overwrite existing aliases
curl -fsSL https://raw.githubusercontent.com/Alexy-vda/snippets/main/scripts/setup-git-commit-aliases.sh | sh -s -- --global --force
```
