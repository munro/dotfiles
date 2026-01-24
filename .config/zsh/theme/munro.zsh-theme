# munro_v2 theme - standalone version (no oh-my-zsh dependency)

# Colors - using zsh's built-in color support
autoload -U colors && colors

# Set prompt color based on SSH connection
if [[ -v SSH_CONNECTION ]]; then
    PS1_COLOR="%F{green}"
    PS1_PREFIX="$(hostname) "
else
    PS1_COLOR="%F{magenta}"
    PS1_PREFIX=""
fi

# Virtual environment indicator
function ps1_virtual_env() {
    if [[ -n ${VIRTUAL_ENV} ]]; then
        echo -n " ${PS1_COLOR}($(basename ${VIRTUAL_ENV}))%f"
    fi
}

# Git prompt info (standalone implementation)
function git_prompt_info() {
    # Check if we're in a git repo
    if ! command git rev-parse --git-dir &> /dev/null; then
        return
    fi
    
    local ref
    ref=$(command git symbolic-ref --short HEAD 2> /dev/null) \
        || ref=$(command git rev-parse --short HEAD 2> /dev/null) \
        || return 0
    
    # Check if dirty
    local dirty=""
    if [[ -n $(command git status --porcelain 2> /dev/null | tail -n 1) ]]; then
        dirty="%F{red} ✗%f"
    else
        dirty="%F{green} ✓%f"
    fi
    
    echo "${PS1_COLOR}${ref}${dirty}%f"
}

# Set the prompts
PROMPT='${PS1_COLOR}[${PS1_PREFIX}%~]%f '
RPROMPT='$(git_prompt_info)$(ps1_virtual_env)'

# Terminal title
case "$TERM" in
    xterm*|rxvt*|screen*|tmux*|alacritty*|kitty*)
        precmd() { print -Pn "\e]0;%~\a" }
        preexec() { print -Pn "\e]0;$1\a" }
        ;;
esac
