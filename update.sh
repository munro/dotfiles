#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# DOTFILES SYNC
# Fetches origin, fast-forward merges if possible, writes status to:
#   ~/.local/state/dotfiles-sync
# Intended to be run via cron. Shell prompt reads the status file.
#   --auto-apply  Run `python3 install.py apply` after a successful merge
# =============================================================================

AUTO_APPLY=false
for arg in "$@"; do
  case "$arg" in
    --auto-apply) AUTO_APPLY=true ;;
    *) echo "Usage: $0 [--auto-apply]" >&2; exit 1 ;;
  esac
done

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
STATUS_FILE="$HOME/.local/state/dotfiles-sync"

mkdir -p "$(dirname "$STATUS_FILE")"
cd "$DOTFILES_DIR"

write_status() {
  local status="$1"
  local message="${2:-}"
  printf 'TIMESTAMP=%s\nSTATUS=%s\nMESSAGE=%s\n' \
    "$(date +%s)" "$status" "$message" > "$STATUS_FILE"
}

# =============================================================================
# CHECK DIRTY
# =============================================================================

if ! git diff --quiet || ! git diff --cached --quiet; then
  write_status "dirty" "Working directory has uncommitted changes"
  echo "Dotfiles working directory is dirty, cannot sync"
  exit 1
fi

# =============================================================================
# FETCH
# =============================================================================

if ! git fetch origin 2>/dev/null; then
  write_status "fetch_failed" "git fetch failed (network?)"
  echo "git fetch failed"
  exit 1
fi

# =============================================================================
# CHECK AHEAD / BEHIND
# =============================================================================

AHEAD=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 0)
BEHIND=$(git rev-list --count 'HEAD..@{u}' 2>/dev/null || echo 0)

if (( BEHIND == 0 && AHEAD == 0 )); then
  write_status "ok" "Up to date"
  echo "Already up to date"
  exit 0
fi

if (( BEHIND == 0 && AHEAD > 0 )); then
  write_status "unpushed" "${AHEAD} commits not pushed"
  echo "${AHEAD} local commits not pushed"
  exit 0
fi

# =============================================================================
# MERGE (behind > 0)
# =============================================================================

if ! git merge --ff-only '@{u}' 2>/dev/null; then
  write_status "merge_failed" "Fast-forward merge failed (diverged ${AHEAD} ahead, ${BEHIND} behind)"
  echo "Merge failed (${AHEAD} ahead, ${BEHIND} behind)"
  exit 1
fi

# Merged successfully — still might have unpushed
if (( AHEAD > 0 )); then
  write_status "unpushed" "Merged but ${AHEAD} commits not pushed"
  echo "Merged ${BEHIND} commits, but ${AHEAD} local commits not pushed"
else
  write_status "ok" "Merged ${BEHIND} commits"
  echo "Merged ${BEHIND} commits, up to date"
fi

# =============================================================================
# AUTO-APPLY
# =============================================================================

if [[ "$AUTO_APPLY" == true ]] && (( BEHIND > 0 )); then
  echo "Applying dotfiles..."
  python3 "$DOTFILES_DIR/install.py" apply
fi
