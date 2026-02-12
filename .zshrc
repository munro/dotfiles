# =============================================================================
# FPATH & EARLY SETUP
# =============================================================================

typeset -U fpath  # auto-dedupe

fpath=(
  $HOME/.bun
  $HOME/.local/share/zsh/site-functions
  $HOME/.local/share/zsh/completions
  /opt/homebrew/share/zsh/site-functions
  # ubuntu
  /snap/task/current/completion/zsh
  $fpath
)

# Ensure Homebrew takes priority over system paths (path_helper in /etc/zprofile reorders)
path=("${(@)path:#/opt/homebrew/bin}")
path=("/opt/homebrew/bin" "/opt/homebrew/sbin" "${(@)path:#/opt/homebrew/sbin}")

# =============================================================================
# AUTOLOADS (grouped together, before they're used)
# =============================================================================

autoload -U colors && colors
autoload -Uz add-zsh-hook

# =============================================================================
# GIT FUNCTIONS & PROMPT HELPERS
# =============================================================================

function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done
  echo master
  return 1
}

function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return 0
    fi
  done
  echo develop
  return 1
}

function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

ZSH_THEME_GIT_PROMPT_PREFIX="git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function git_prompt_info() {
  if ! command git rev-parse --git-dir &> /dev/null; then
    return
  fi
  local ref
  ref=$(command git symbolic-ref --short HEAD 2> /dev/null) \
    || ref=$(command git rev-parse --short HEAD 2> /dev/null) \
    || return 0
  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

function parse_git_dirty() {
  local STATUS
  STATUS=$(command git status --porcelain 2> /dev/null | tail -n 1)
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# =============================================================================
# TERMINAL TITLE
# =============================================================================

function title() {
  emulate -L zsh
  setopt prompt_subst
  [[ "$TERM" == (dumb|linux|*bsd*|eterm*) ]] && return
  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty*|st*|foot*|contour*)
      print -Pn "\e]2;${2:q}\a"
      print -Pn "\e]1;${1:q}\a"
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\"
      ;;
  esac
}

function _title_precmd() {
  title "%15<..<%~%<<" "%n@%m:%~"
}

function _title_preexec() {
  local cmd=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
  title "%100>...>${cmd}%<<" "%n@%m:%~"
}

add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec

# =============================================================================
# HISTORY
# =============================================================================

HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=100000

setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE  # Commands starting with space won't be saved to history
setopt HIST_VERIFY

# =============================================================================
# ALIASES - MODERN CLI REPLACEMENTS
# =============================================================================

alias neofetch="fastfetch"

# Use $+commands hash lookup (instant) instead of command -v (subprocess)
(( $+commands[lsd] )) && alias ls="lsd -tr" || alias ls="ls --color=auto"
(( $+commands[rg] )) && alias rg="rg --max-columns=1000"
(( $+commands[bat] )) && alias cat="bat" || { (( $+commands[batcat] )) && alias cat="batcat" }
(( $+commands[duf] )) && alias df="duf"
(( $+commands[dust] )) && alias du="dust"
(( $+commands[erd] )) && alias du-fast="erd -L 3 -l -H -I"

# GNU coreutils/findutils (aliased to avoid breaking builds)
for cmd in awk base32 base64 b2sum chgrp chmod chown cp cut date find head ln \
           mkdir mv nproc od rm rmdir sed sha1sum sha224sum sha256sum sha384sum \
           sha512sum sort tail tar tee uniq wc xargs; do
  (( $+commands[g$cmd] )) && alias $cmd="g$cmd"
done
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:${MANPATH:-}"

# =============================================================================
# ALIASES - GIT & DOTFILES
# =============================================================================

alias -- -='cd -'
alias g='git'
alias gd='git diff HEAD'
alias gf='git fetch'
alias gl='git log'
alias gp='git push'
alias gr='git reset'
alias grs='git reset --soft'
alias gs='git status'

# gitk alias - use real gitk if available, otherwise git k
if (( $+commands[gitk] )); then
  alias gk='gitk'
else
  alias gk='git k'
  alias gitk='git k'
fi

# =============================================================================
# ENVIRONMENT VARIABLES (interactive-only)
# =============================================================================

export GREP_COLOR='1;32'
export GREP_COLORS="mt=$GREP_COLOR"
alias grep="grep --color=auto"
export AWS_DEFAULT_OUTPUT="table"
export AWS_PAGER=""  # disable pager, print directly to console

# Pager configuration
export PAGER=less
export LESS=-R

# =============================================================================
# KEY BINDINGS
# Multiple bindings for same action = different terminals send different escape codes
# =============================================================================

# Terminal application mode (makes terminfo values work)
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  zle-line-init() { echoti smkx }
  zle-line-finish() { echoti rmkx }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e  # Emacs mode (Ctrl+A/E for start/end of line, etc.)

# Remove / from WORDCHARS so Ctrl+W stops at path separators
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Home/End keys (various terminal escape sequences)
bindkey "\e[1~" beginning-of-line   # Linux console, PuTTY
bindkey "\e[4~" end-of-line         # Linux console, PuTTY
bindkey "\e[7~" beginning-of-line   # rxvt
bindkey "\e[8~" end-of-line         # rxvt
bindkey "\eOH" beginning-of-line    # xterm application mode
bindkey "\eOF" end-of-line          # xterm application mode
bindkey "\e[H" beginning-of-line    # xterm normal mode
bindkey "\e[F" end-of-line          # xterm normal mode

# History navigation
bindkey "\e[5~" beginning-of-history  # Page Up
bindkey "\e[6~" end-of-history        # Page Down

# # Up/Down with prefix search (type "git" then up-arrow to find git commands)
# autoload -U up-line-or-beginning-search down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# bindkey '^[[A' up-line-or-beginning-search
# bindkey '^[[B' down-line-or-beginning-search

# Insert/Delete
bindkey "\e[2~" quoted-insert  # Insert key
bindkey "\e[3~" delete-char    # Delete key

# Word navigation (various terminal escape sequences)
bindkey "\e[5C" forward-word       # Ctrl+Right (some terminals)
bindkey "\eOc" emacs-forward-word  # Ctrl+Right (rxvt)
bindkey "\e[5D" backward-word      # Ctrl+Left (some terminals)
bindkey "\eOd" emacs-backward-word # Ctrl+Left (rxvt)
bindkey "\e\e[C" forward-word      # Alt+Right
bindkey "\e\e[D" backward-word     # Alt+Left
bindkey "^[[1;5D" backward-word    # Ctrl+Left (xterm)
bindkey "^[[1;5C" forward-word     # Ctrl+Right (xterm)

# Whole-path jumps (by whitespace)
bindkey "^[[1;6D" vi-backward-blank-word  # Shift+Ctrl+Left (Cursor IDE)
bindkey "^[[1;6C" vi-forward-blank-word   # Shift+Ctrl+Right (Cursor IDE)
bindkey "^[b" vi-backward-blank-word      # Alt+B (Mac Terminal)
bindkey "^[f" vi-forward-blank-word       # Alt+F (Mac Terminal)

# Menu completion
bindkey "\e[Z" reverse-menu-complete  # Shift+Tab

# # Edit command in $EDITOR with Ctrl-x Ctrl-e
# autoload -U edit-command-line
# zle -N edit-command-line
# bindkey '^x^e' edit-command-line

# Disable F10 (some terminals send this accidentally)
bindkey -s '\e[21~' ''

# =============================================================================
# LS COLORS
# =============================================================================

if [[ -f "~/.ls_colors.sh" ]]; then
  source ~/.ls_colors.sh
fi

# =============================================================================
# SHELL OPTIONS
# =============================================================================

setopt ExtendedGlob
setopt CombiningChars  # Better Unicode handling for combining characters
setopt no_nomatch
setopt RcQuotes RecExact LongListJobs TransientRprompt MenuComplete MagicEqualSubst InteractiveComments CompleteInWord PromptSubst
# EXTENDED_HISTORY records timestamp and duration for each command
# Note: SHARE_HISTORY (set above) makes INC_APPEND_HISTORY redundant
setopt ExtendedHistory
setopt AutoPushd PushdMinus AutoCd PushdToHome PushdSilent PushdIgnoreDups AutoResume
unsetopt BgNice AutoParamSlash Hup Correct CorrectAll Beep

# =============================================================================
# MISC ZSH SETTINGS
# =============================================================================

MAILCHECK=60
# mailpath+=( /var/spool/mail/${USER}(/N) ~/MailDir(/N) )  # Linux-only, not used on macOS
# [[ $ZSH_VERSION == *-dev* ]] && manpath=( ~/.local/share/man(/N) )  # Only for zsh dev versions
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;'
READNULLCMD=less

TIMEFMT=$(
  print -rP '%B %%J %b%K{60}%F{183} %%U %K{183}%F{60} user'\
    '%K{60}%F{183} %%S %K{183}%F{60} system'\
    '%K{60}%F{183} %%P %K{183}%F{60} cpu'\
    '%K{60}%F{183} %%*E %K{183}%F{60} total %f%k'
)
REPORTTIME=1

WATCHFMT=$(
  print -rP '%K{60}%F{183} %%n %K{183}%F{60} has %%a %%l @ %%D{%%T} %%D %f%k'
)

# =============================================================================
# COMPLETION SYSTEM - BASIC SETUP
# =============================================================================

# Helper function for styled completion format strings
function format_style() {
  if (( $(tput colors) == 8 )); then
    print -r -- "$@"
  else
    print -r -- "%K{183}%B%F{60} $1 %K{60}%F{183} $argv[2,-1] %f%k"
  fi
}

# accept-exact options:
# | Value      | Behavior                                                    |
# |------------|-------------------------------------------------------------|
# | true       | Always accept exact matches immediately                     |
# | false      | Never accept exact, always show full menu                   |
# | '*(N)'     | Accept exact only if it's an existing file (null glob)      |
# | continue   | Accept exact match but still show other completions too     |
zstyle ':completion:*' accept-exact continue
# Completers - tried in order until one succeeds:
# | Completer     | What it does                                      | Example                                    |
# |---------------|---------------------------------------------------|--------------------------------------------|
# | _expand       | Expands globs & variables before completing       | $HOM<TAB> → /Users/ryan                    |
# | _extensions   | Completes file extensions after *. or ?.          | *.<TAB> → *.txt, *.md, *.py                |
# | _complete     | Standard completion - matches prefix              | gi<TAB> → git, gist                        |
# | _correct      | Spelling correction for commands                  | gti<TAB> → "correct to git?"               |
# | _approximate  | Fuzzy matching - allows N errors in word          | makfe<TAB> → Makefile                      |
# | _ignored      | Shows completions filtered by ignored-patterns    | _priv<TAB> → shows _private_func           |
# | _match        | Glob pattern matching in completion               | *foo*<TAB> → matches containing "foo"      |
# | _prefix       | Ignores suffix after cursor when completing       | fi|le.txt<TAB> → completes "fi" part only  |
# | _list         | Lists completions without inserting               | (just shows options, no insert)            |
# | _history      | Completes from command history                    | ssh<TAB> → ssh user@host (from history)    |
# | _oldlist      | Reuses previous completion list                   | (performance optimization)                 |
# | _menu         | Forces menu selection mode                        | (always show menu)                         |
zstyle ':completion:*' completer _expand _extensions _complete _ignored _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:*:*:*' menu select=2  # Show menu when 2+ matches
zstyle ':completion:*' file-sort access  # Sort by last access time (recently used first)
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"
[[ -d "$HOME/.cache/zcompcache" ]] || mkdir -p "$HOME/.cache/zcompcache"
zstyle ':completion:*:*:_poetry:*' ignored-patterns '*'
zstyle ':completion:*:*:poetry:*' ignored-patterns '_*'

# =============================================================================
# COMPLETION SYSTEM - COLORS & FORMATTING
# =============================================================================

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion::complete:lsof:*' menu yes select

zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# =============================================================================
# COMPLETION SYSTEM - MANUALS
# =============================================================================

zstyle -e ':completion:*:manuals.*' insert-sections 'if [[ $OSTYPE = solaris* ]]; then reply=(false); else reply=(true); fi'
zstyle ':completion:*:manuals' separate-sections true

# =============================================================================
# COMPLETION SYSTEM - VERBOSITY & DISPLAY
# =============================================================================

zstyle ':completion:*' verbose true
zstyle ':completion:*' extra-verbose true
zstyle ':completion:*' list-separator '::'
zstyle ':completion:*' format "$(format_style Completing: %d)"
zstyle ':completion:*' select-prompt "$(format_style Menu-selection: current selection at %p)"
zstyle ':completion:*' auto-description "specify: %d"
zstyle ':completion:*:default' list-colors 'ma=38;5;183;48;5;60' 'tc=01;36' "${(s.:.)ZLS_COLORS}"
zstyle ':completion:*:(options|flags)' list-colors '=(#s)(#b)[[:space:]]#*[[:space:]]#[[:space:]]#(::)[[:space:]]#(*)(#B)(#e)=0=38;5;111=38;5;60'
zstyle ':completion::complete:vim:option-u-1:*' fake NONE

# =============================================================================
# COMPLETION SYSTEM - PROCESS COMPLETION
# =============================================================================

zstyle ':completion:*:processes' format "$(format_style Completing: %d "(pid user lstart %%%cpu %%%mem rss args)")"
zstyle ':completion:*:processes' command 'ps -o pid,user,lstart,pcpu,pmem,rss,args -A'
zstyle ':completion:*:killall:*' command 'ps -o comm -A'

# =============================================================================
# COMPLETION SYSTEM - SUBSCRIPTS
# =============================================================================

zstyle ':completion::complete:-subscript-::' tag-order 'indexes association-keys'

# =============================================================================
# COMPLETION SYSTEM - MISC
# =============================================================================

zstyle ':completion:*' special-dirs ..
zstyle :completion::complete:-tilde-:: group-order named-directories users

# =============================================================================
# COMPLETION SYSTEM - MOST RECENT FILE
# =============================================================================

zstyle ':completion:most-recent-file:*' match-original both
zstyle ':completion:most-recent-file:*' file-sort modification
zstyle ':completion:most-recent-file:*' file-patterns '*:all\ files'
zstyle ':completion:most-recent-file:*' hidden all
zstyle ':completion:most-recent-file:*' completer _files
zle -C most-recent-file menu-complete _generic
zstyle ':completion:*:events' range 50
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' squeeze-slashes true  # Treat // as / in path completion

# =============================================================================
# COMPLETION SYSTEM - MATCHER LIST
# see COMPLETION MATCHING CONTROL in zshcompwid for details.
# when completion is invoked and zsh compares the word you typed with possible
# choices, a type of pattern matching is used and by default it appends `*' to
# the current word and any choices that doesn't match the pattern is omitted.
# an example being typing ..u<TAB> with a possible choice of `comp.sources.unix',
# with the default behavior `..u*' would not match `comp.sources.unix' thus not
# be presented.
# the matcher/matcher-list style controls what the pattern ultimately results in.
# the entire completion system is ran for each entry, thus twice in my config.
# m:{[:lower:][:upper:]}={[:upper:][:lower:]} lets any lowercase character in
# the current word be completed to itself or its uppercase counterpart and the
# same with uppercase characters matching itself or their lowercase counterpart.
# l:|=* prepends * to the current-word/match-pattern for filtering possible choices.
# r:|=* appends * to the current-word/match-pattern for filtering possible choices.
# r:|[._-]=** is checking the word for substrings matching empty string (the left
# side of the |) that has characters ., _ or - to the right of it.
# =============================================================================

# Simple case-insensitive: lowercase matches uppercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Bidirectional case-insensitive + partial word matching on . _ -
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Completion matching - tried in order:
# 1. Case-insensitive prefix (abc → Abc)
# 2. + partial at delimiters (f-b → foo-bar)  
# 3. + substring anywhere (wor → troveo_workers)
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+r:|[._-]=* r:|=*' \
  '+l:|=*'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' rehash true

# =============================================================================
# PROMPT THEME
# =============================================================================

source "$HOME/.config/zsh/theme/munro.zsh-theme"

# =============================================================================
# LOCAL SETTINGS
# =============================================================================

if [[ -f ~/.localrc ]]; then
  source ~/.localrc
fi

# =============================================================================
# COMPINIT (must be after all fpath modifications)
# =============================================================================

autoload -Uz compinit
# Use cached .zcompdump if less than 24 hours old, otherwise rebuild
if [[ -n $HOME/.cache/zsh/zcompdump(#qN.mh-24) ]]; then
  compinit -C -d "$HOME/.cache/zsh/zcompdump"
else
  compinit -d "$HOME/.cache/zsh/zcompdump"
fi

# =============================================================================
# MISE ENVIRONMENT SWITCHER
# =============================================================================

menv() {
  export MISE_ENV="$1"
  mise trust 2>/dev/null
  echo "Switched to MISE_ENV=$1"
}

# =============================================================================
# TOOLS RUNNER (t command)
# =============================================================================

function t() {
  local tool="$1"
  shift
  if [[ -x "$HOME/.config/tools.local/$tool" ]]; then
    "$HOME/.config/tools.local/$tool" "$@"
  elif [[ -x "$HOME/.config/tools/$tool" ]]; then
    "$HOME/.config/tools/$tool" "$@"
  else
    echo "Tool not found: $tool" >&2
    return 1
  fi
}

function _t_completion() {
  local tools=()
  for dir in "$HOME/.config/tools.local" "$HOME/.config/tools"; do
    [[ -d "$dir" ]] && tools+=("$dir"/*(N:t))
  done
  _describe 'tool' tools
}
compdef _t_completion t

# =============================================================================
# RELOAD SHELL (rr command)
# =============================================================================

function rr() {
  # Clear completion cache
  rm -rf ~/.cache/zsh
  # Old locations for completion cache
  rm -rf ~/.zcompdump*
  rm -rf ~/.zcompcache*
  rm -rf ~/.cache/zcompdump*
  rm -rf ~/.cache/zcompcache*


  # Exec fresh login shell (cleanest reload - replaces current process)
  exec zsh -l
}

# =============================================================================
# ZSH PLUGINS (must be after compinit)
# =============================================================================

# fzf-tab (must be before autosuggestions/syntax-highlighting)
if [[ -f ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh
  # fzf-tab configuration
  zstyle ':completion:*' format '[%d]'

  zstyle ':completion:*:descriptions' format '[%d]'

  zstyle ':completion:*:processes' format 'Completing: %d'
  zstyle ':completion:*' select-prompt 'Menu-selection: %p'

  zstyle ':fzf-tab:*' continuous-trigger '/'

  zstyle ':completion:*' menu no  # let fzf-tab handle the menu
  zstyle ':fzf-tab:*' switch-group '<' '>'


  # COMPLETES
  # zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -la --color=always $realpath'
  # zstyle ':fzf-tab:complete:kill:*' fzf-preview 'ps -p $word -o pid,user,%cpu,%mem,command'

  # zstyle ':fzf-tab:complete:(cd|lsd|ls):path-directories' fzf-preview  'lsd -la --color=always $realpath'
  zstyle ':fzf-tab:complete:*:*' fzf-preview 'fzf_tab_preview $realpath'

  zstyle ':fzf-tab:complete:kill:*' fzf-preview

  # zstyle ':fzf-tab:complete:lsd:*' fzf-preview 'bat --color=always $realpath'

  #####

  # disable sort when completing `git checkout`
  zstyle ':completion:*:git-checkout:*' sort false
  # set descriptions format to enable group support
  # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
  zstyle ':completion:*:descriptions' format '[%d]'
  # set list-colors to enable filename colorizing
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
  zstyle ':completion:*' menu no
  # preview directory's content with eza when completing cd

  # custom fzf flags
  # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
  zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
  zstyle ':fzf-tab:*' fzf-flags \
    --color=fg:1,fg+:2 --bind=tab:accept  --layout=reverse  \
    --height=40% --history=$HOME/.cache/fzf_tab_history
  # To make fzf-tab follow FZF_DEFAULT_OPTS.
  # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  # switch group using `<` and `>`
  zstyle ':fzf-tab:*' switch-group '<' '>'

  # zstyle ':fzf-tab:*' fzf-flags --no-sort
  # zstyle ':fzf-tab:*' fzf-flags
  # zstyle ':fzf-tab:complete:-command-:*' fzf-flags --no-sort --tiebreak=length
fi

# zsh-autosuggestions
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting (must be last)
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor line regexp)
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_REGEXP+=('^ *rm ' fg=red,bold)
  ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold,underline'
  ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
fi
