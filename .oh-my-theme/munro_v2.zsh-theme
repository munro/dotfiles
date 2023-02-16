local PS1_PREFIX=""
local PS1_COLOR=$fg[magenta]

if [[ -v PS1_COLOR ]]; then
	if [[ -v SSH_CONNECTION ]]; then
		export PS1_COLOR=$fg[green]
	else
		export PS1_COLOR=$fg[magenta]
	fi
fi
if [[ -v SSH_CONNECTION && -v PS1_PREFIX ]]; then
	export PS1_PREFIX="$(hostname) "
fi

function ps1_virtual_env() {
	if [[ -n ${VIRTUAL_ENV} ]]; then
		echo -n " %{$PS1_COLOR%}($(basename ${VIRTUAL_ENV}))%{$reset_color%}"
	fi
}

ZSH_THEME_TERM_TITLE_IDLE="%~"
unset ZSH_THEME_TERM_TAB_TITLE_IDLE

PROMPT='%{$PS1_COLOR%}[$PS1_PREFIX%~] %{$reset_color%}'
RPROMPT='$(git_prompt_info)$(ps1_virtual_env)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PS1_COLOR%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓"
