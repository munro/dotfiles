# hyperfine "zsh -i -c 'lsd --color=always'"
# 35ms or less isn't even noticible :O
# 50-82 ms isn't terrible

if [[ -v ZSH_PROF ]]; then
    zmodload zsh/zprof
fi

fpath+=~/.zfunc

# ZSH
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="../../.oh-my-theme/munro_v2"
export DISABLE_AUTO_UPDATE="true"
export ZSH_DISABLE_COMPFIX=true
export DISABLE_UPDATE_PROMPT=true

plugins=(git)
source $ZSH/oh-my-zsh.sh

export HISTSIZE=100000000
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
unsetopt histignoredups

# Homebrew
export PIPX_HOME="$HOME/.local/share/pipx"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
export PATH="$HOMEBREW_REPOSITORY/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Alias
if command -v "lsd" >/dev/null 2>&1; then
    alias ls="lsd"
fi
if command -v "rg" >/dev/null 2>&1; then
    alias rg="rg --max-columns=1000"
    alias grep="rg --max-columns=1000"
    alias rgrep="rg --max-columns=1000"
fi
if command -v "bat" >/dev/null 2>&1; then
    alias cat="bat"
    compdef bat=cat
fi
if command -v "duf" >/dev/null 2>&1; then
    alias df="duf"
fi
if command -v "dog" >/dev/null 2>&1; then
    alias dig="$HOME/.dog_wrapper"
fi
if command -v "dust" >/dev/null 2>&1; then
    alias du="dust"
fi
if command -v "erd" >/dev/null 2>&1; then
    alias du-fast="erd -L 3 -l -H -I"
fi

# Spelling
# alias chomd="chmod"
# alias poery="poetry"
# alias poerty="poetry"
# alias poerty="poetry"

# Poetry
export POETRY_VIRTUALENVS_PATH=".venv"
export POETRY_VIRTUALENVS_IN_PROJECT="true"
export POETRY_VIRTUALENVS_CREATE="true"

# gnutls
export GUILE_TLS_CERTIFICATE_DIRECTORY="/usr/local/etc/gnutls/"

export DIRENV_LOG_FORMAT="" # Disable direnv logging?
export EDITOR="vim"
export EMAIL="500774+munro@users.noreply.github.com"
export GIT_AUTHOR_NAME="Ryan Munro"
export GIT_AUTHOR_EMAIL="500774+munro@users.noreply.github.com"
export GIT_COMMITTER_NAME="Ryan Munro"
export GIT_COMMITTER_EMAIL="500774+munro@users.noreply.github.com"

export GOBIN=$HOME/.local/bin

# gnu tools
for cmd in awk sed tar xargs tee find head tail uniq sort ln; do
    if command -v "g$cmd" >/dev/null 2>&1; then
        alias "$cmd"="g$cmd"
    fi
done

# Source tools
if [ -d "/Library/TeX/texbin" ]; then
    export PATH="$PATH:/Library/TeX/texbin"
fi
if [ -d "$HOME/.juliaup/bin" ]; then
    export PATH="$HOME/.juliaup/bin:$PATH"
fi
if [ -d "$HOME/.pyenv/bin" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
fi

# Bindkeys!
bindkey "\e[1~" beginning-of-line    # Home
bindkey "\e[4~" end-of-line          # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history       # PageDown
bindkey "\e[2~" quoted-insert        # Ins
bindkey "\e[3~" delete-char          # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line       # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# for guake
bindkey "\eOF" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "\e[3~" delete-char # Del
# Disable F10 key
bindkey -s '\e[21~' ''

# Cool ls colors
if [ -f "$HOME/.ls_colors.sh" ]; then
    source ~/.ls_colors.sh
fi

# Local settings
if [ -f "$HOME/.localrc" ]; then
    source ~/.localrc
fi

# fnm
if command -v "fnm" >/dev/null 2>&1; then
    alias nvm=fnm
    eval $(fnm env)
fi

# cache
# autoload -Uz compinit
# compinit -C

# Auto complete
zstyle ':completion:*' accept-exact '*(N)'

# Cool functions
function woozy() {
    git commit -a -m "🥴"
}
function lazy_source() {
    eval "$1 () { [ -f $2 ] && source $2 && $1 \$@ }"
}
function print_colors() {
    for x in {0..8}; do for i in {30..37}; do
        for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done
        echo
    done; done
    echo ""
}
function mac_view_slow_spotlight() {
    sudo fs_usage -w -f filesys mds_stores
}
function zsh_profile() {
    time ZSH_PROF=1 zsh -i -c exit
}
function my_upgrade_oh_my_zsh() {
    (
        cd ~/
        if [[ -n "$(git status -s)" ]]; then
            echo "Please commit dotfiles before upgrade oh-my-zsh"
            exit 1
        fi
        rm -rf ~/.oh-my-zsh
        git clone --depth=1 --branch=master git@github.com:ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        rm -rf ~/.oh-my-zsh/.git
        git add .oh-my-zsh
        git commit -m "Upgrade oh my zsh"
    )
}
function update_ls_colors() {
    curl https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/lscolors.sh >>~/.ls_colors.sh
}

# beep boop
if [[ -v ZSH_PROF ]]; then
    zprof
fi

# https://thevaluable.dev/zsh-completion-guide-examples/
# https://github.com/sindresorhus/pure
# https://github.com/finnurtorfa/zsh/blob/master/completion.zsh
# https://unix.stackexchange.com/questions/214657/what-does-zstyle-do
zstyle ':completion:*' completer _extensions  _complete _approximate _ignored
zstyle ':completion:*' regular true
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"
zstyle ':completion:*:*:_poetry:*' ignored-patterns '*'
zstyle ':completion:*:*:poetry:*' ignored-patterns '_*'

# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# # Completers for my own scripts
# zstyle ':completion:*:*:sstrans*:*' file-patterns '*.(lst|clst)'
# zstyle ':completion:*:*:ssnorm*:*' file-patterns '*.tsv'

zstyle ':completion::complete:lsof:*' menu yes select
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '

## completion system
# zstyle ':completion:*:approximate:'                 max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
# zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
# zstyle ':completion:*:correct:*'                    insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
# zstyle ':completion:*:corrections'                  format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:correct:*'                    original true                       #
# zstyle ':completion:*:default'                      list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'                 format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'  # format on completion
# zstyle ':completion:*:*:cd:*:directory-stack'       menu yes select              # complete 'cd -<tab>' with menu
# zstyle ':completion:*:expand:*'                     tag-order all-expansions            # insert all expansions for expand completer
zstyle ':completion:*:history-words'                list false                          #
zstyle ':completion:*:history-words'                menu yes                            # activate menu
zstyle ':completion:*:history-words'                remove-all-dups yes                 # ignore duplicate entries
zstyle ':completion:*:history-words'                stop yes                            #
zstyle ':completion:*'                              matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
zstyle ':completion:*:matches'                      group 'yes'                         # separate matches into groups
zstyle ':completion:*'                              group-name ''
# if [[ -z "$NOMENU" ]] ; then
#   zstyle ':completion:*'                            menu select=2                       # if there are more than 5 options allow selecting from a menu
# else
#   setopt no_auto_menu # don't use any menus at all
# fi
# zstyle -e ':completion:*'                           special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'
# zstyle ':completion:*:messages'                     format '%d'                         #
# zstyle ':completion:*:options'                      auto-description '%d'               #
# zstyle ':completion:*:options'                      description 'yes'                   # describe options in full
# zstyle ':completion:*:processes'                    command 'ps -au$USER'               # on processes completion complete all user processes
# zstyle ':completion:*:*:-subscript-:*'              tag-order indexes parameters        # offer indexes before parameters in subscripts
zstyle ':completion:*'                              verbose true                        # provide verbose completion information
zstyle ':completion:*:warnings'                     format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
# zstyle ':completion:*:*:zcompile:*'                 ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
# zstyle ':completion:correct:'                       prompt 'correct to: %e'             #
zstyle ':completion::(^approximate*):*:functions'   ignored-patterns '_*'    # Ignore completion functions for commands you don't have:


# complete manual by their section
# zstyle ':completion:*:manuals'                      separate-sections true
# zstyle ':completion:*:manuals.*'                    insert-sections   true
# zstyle ':completion:*:man:*'                        menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'