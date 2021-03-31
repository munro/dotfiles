function ps1_virtual_env() {
    if [[ -n ${VIRTUAL_ENV} ]]; then
        echo -n " %{$fg[magenta]%}($(basename ${VIRTUAL_ENV}))%{$reset_color%}"
    fi
}

PROMPT='%{$fg[magenta]%}[%~] %{$reset_color%}'
RPROMPT='$(git_prompt_info)$(ps1_virtual_env)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓"
