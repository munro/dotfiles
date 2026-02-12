# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

export GOBIN=$HOME/.local/bin

# -----------------------------------------------------------------------------
# Git Identity
# -----------------------------------------------------------------------------

export EMAIL="500774+munro@users.noreply.github.com"
export GIT_AUTHOR_NAME="Ryan Munro"
export GIT_AUTHOR_EMAIL="500774+munro@users.noreply.github.com"
export GIT_COMMITTER_NAME="Ryan Munro"
export GIT_COMMITTER_EMAIL="500774+munro@users.noreply.github.com"

# -----------------------------------------------------------------------------
# Tool-specific
# -----------------------------------------------------------------------------

export EDITOR="vim"  # in zshenv so GUI apps and scripts know preferred editor
export VIMINIT='source ~/.config/vim/vimrc'
export PYTHONPYCACHEPREFIX="$HOME/.cache/pycache"
export UV_COMPILE_BYTECODE=1
export OVERCOMMIT_DISABLE=1
export CDK_DISABLE_CLI_TELEMETRY=true

# -----------------------------------------------------------------------------
# HOMEBREW
# -----------------------------------------------------------------------------

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# =============================================================================
# PATH SETUP
# =============================================================================

typeset -U path  # auto-dedupe

path=(
  # Mise shims (fallback for non-interactive shells like Cursor)
  "$HOME/.local/share/mise/shims"
  # User tools
  "$HOME/.config/tools.local"
  "$HOME/.config/tools"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/.rbenv/bin"
  "$HOME/.juliaup/bin"
  "$HOME/.pyenv/bin"
  "$HOME/.lmstudio/bin"
  # Homebrew
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/opt/homebrew/opt/mysql-client/bin"
  "/opt/homebrew/opt/libpq/bin"
  # System
  "/usr/local/bin"
  "/usr/local/sbin"
  "/Applications/SWI-Prolog.app/Contents/MacOS"
  $path
)

# Low priority (append)
path+=(
  "/Library/TeX/texbin"
)

# Remove non-existent PATH entries
path=( ${^path}(N) )

# =============================================================================
# LOCAL SETTINGS
# =============================================================================

if [[ -f ~/.zshenv.local ]]; then
  source ~/.zshenv.local
fi

# =============================================================================
# MISE (must be last - overrides PATH with version-managed tools)
# =============================================================================

export MISE_SHELL=zsh
eval "$(mise activate zsh)"
eval "$(mise hook-env -s zsh 2>/dev/null)" || true  # run hook immediately for non-interactive shells
