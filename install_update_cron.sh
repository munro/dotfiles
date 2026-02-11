#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# INSTALL / UPDATE / REMOVE the dotfiles-sync cron job.
#   ./install_update_cron.sh           Install or fix the cron entry
#   ./install_update_cron.sh --remove  Remove the cron entry
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$DOTFILES_DIR/update.sh"
MARKER="# dotfiles-sync"
SCHEDULE="*/30 * * * *"
CRON_LINE="$SCHEDULE $SCRIPT --auto-apply >/dev/null 2>&1 $MARKER"

remove_cron() {
  local current
  current=$(crontab -l 2>/dev/null || true)
  if echo "$current" | grep -qF "$MARKER"; then
    echo "$current" | grep -vF "$MARKER" | crontab -
    echo "Removed dotfiles-sync cron job"
  else
    echo "No dotfiles-sync cron job found"
  fi
}

install_cron() {
  local current
  current=$(crontab -l 2>/dev/null || true)

  if echo "$current" | grep -qF "$CRON_LINE"; then
    echo "Cron job already correct"
    echo "  $CRON_LINE"
    return
  fi

  # Remove stale entry if marker exists but line differs
  if echo "$current" | grep -qF "$MARKER"; then
    current=$(echo "$current" | grep -vF "$MARKER")
    echo "Replaced outdated cron entry"
  else
    echo "Installed cron entry"
  fi

  echo "$current"$'\n'"$CRON_LINE" | crontab -
  echo "  $CRON_LINE"
}

case "${1:-}" in
  --remove) remove_cron ;;
  "")       install_cron ;;
  *)        echo "Usage: $0 [--remove]" >&2; exit 1 ;;
esac
