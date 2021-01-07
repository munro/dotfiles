function ps1_virtual_env() {
    if [[ -n ${VIRTUAL_ENV_NAME} ]]; then
        echo " %{$fg[magenta]%}(${VIRTUAL_ENV_NAME})%{$reset_color%}"
    fi
}

PROMPT='%{$fg[magenta]%}[%~] %{$reset_color%}'
RPROMPT='$(git_prompt_info)$(ps1_virtual_env)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓"