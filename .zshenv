# =============================================================================
# PATH SETUP
# =============================================================================

typeset -U path  # auto-dedupe

# =============================================================================
# HOMEBREW
# =============================================================================

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# =============================================================================
# PATH
# =============================================================================

path=(
  # User tools
  "$HOME/.config/tools.local"
  "$HOME/.config/tools"
  "$HOME/.cargo/bin"
  "$HOME/.rbenv/bin"
  "$HOME/.juliaup/bin"
  "$HOME/.pyenv/bin"
  # Homebrew
  "/opt/homebrew/bin"
  "/opt/homebrew/sbin"
  "/opt/homebrew/opt/mysql-client/bin"
  "/opt/homebrew/opt/libpq/bin"
  # System
  "/Applications/SWI-Prolog.app/Contents/MacOS"
  "/usr/local/sbin"
  $path
)

# Low priority (append)
path+=(
  "/Library/TeX/texbin"
)

# Remove non-existent PATH entries
path=( ${^path}(N) )

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
export UV_COMPILE_BYTECODE=1
export OVERCOMMIT_DISABLE=1
export CDK_DISABLE_CLI_TELEMETRY=true

# =============================================================================
# LOCAL SETTINGS
# =============================================================================

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# =============================================================================
# MISE (must be last - overrides PATH with version-managed tools)
# =============================================================================

export MISE_SHELL=zsh
path=("$HOME/.local/share/mise/shims" $path)

# Hook on directory change to activate project-specific versions
_mise_hook_chpwd() {
  eval "$(/opt/homebrew/bin/mise hook-env -s zsh)" 2>/dev/null
}
chpwd_functions+=(_mise_hook_chpwd)
