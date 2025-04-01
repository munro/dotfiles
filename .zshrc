# hyperfine "zsh -i -c 'lsd --color=always'"
# 35ms or less isn't even noticible :O
# 50-82 ms isn't terrible

if [[ -v ZSH_PROF ]]; then
    zmodload zsh/zprof
fi

fpath+=~/.zfunc

export UV_COMPILE_BYTECODE=1

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
setopt no_nomatch
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
    alias ls="lsd -tr"
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
# autoload -Uz select-word-style
# select-word-style bash

# autoload -U select-word-style
# select-word-style bash

autoload -U select-word-style
select-word-style shell

# function smart-backward-kill-word() {
#   local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<> '
#   zle backward-kill-word
# }
# zle -N smart-backward-kill-word

# # Now rebind Control + W to use the new word style behavior

# bindkey '^W' smart-backward-kill-word
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


# bindkey "${terminfo[khome]}" beginning-of-line    # Home
# bindkey "${terminfo[kend]}" end-of-line           # End
# bindkey "${terminfo[kpp]}" beginning-of-history   # PageUp
# bindkey "${terminfo[knp]}" end-of-history         # PageDown
# bindkey "${terminfo[kich1]}" quoted-insert        # Insert
# bindkey "${terminfo[kdch1]}" delete-char          # Delete
# bindkey "${terminfo[kcub1]}" backward-word        # Ctrl + Left Arrow
# bindkey "${terminfo[kcuf1]}" forward-word         # Ctrl + Right Arrow
# bindkey "^[[Z" reverse-menu-complete              # Shift + Tab

# # Compatibility for various terminals
# bindkey "${terminfo[khome]}" beginning-of-line    # Home for rxvt
# bindkey "${terminfo[kend]}" end-of-line           # End for rxvt
# bindkey "${terminfo[khome]}" beginning-of-line    # Home for non-RH/Debian xterm
# bindkey "${terminfo[kend]}" end-of-line           # End for non-RH/Debian xterm
# bindkey "${terminfo[khome]}" beginning-of-line    # Home for freebsd console
# bindkey "${terminfo[kend]}" end-of-line           # End for freebsd console
# bindkey "^[[1;5D" backward-word                   # Ctrl + Left Arrow (alternative)
# bindkey "^[[1;5C" forward-word                    # Ctrl + Right Arrow (alternative)
# bindkey -s "${terminfo[kf10]}" ''                 # Disable F10 key
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



### BONUS


# options
# Globbing
setopt   ExtendedGlob
# Misc
setopt   RcQuotes RecExact LongListJobs TransientRprompt MenuComplete MagicEqualSubst InteractiveComments CompleteInWord PromptSubst
# History
setopt   ExtendedHistory IncAppendHistory${${${+options[incappendhistorytime]}/1/Time}/0} HistIgnoreDups
# pushd settings
setopt   AutoPushd PushdMinus AutoCd PushdToHome PushdSilent PushdIgnoreDups
# Stuff we don't want
unsetopt BgNice AutoParamSlash Hup Correct CorrectAll Beep

HISTFILE=~/.zsh_history
[[ -f ~/.config/.zsh_history ]] && HISTFILE=~/.config/.zsh_history
HISTSIZE=15000
SAVEHIST=15000
MAILCHECK=1
mailpath+=( /var/spool/mail/${USER}(/N) ~/MailDir(/N) )
[[ $ZSH_VERSION == *-dev* ]] && manpath=( ~/.local/share/man(/N) )
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

### MAS


format_style() {
  if (( ${term_colors:=$(tput colors)} == 8 )); then
    print -r -- "$@"
  else
    print -r -- "%K{183}%B%F{60} $1 %K{60}%F{183} $argv[2,-1] %f%k"
  fi
}
zstyle ':prompt:arx:'               users             llua root
zstyle ':prompt:arx:'               primary-color     60  # 24  39 199
zstyle ':prompt:arx:'               secondary-color   111 # 45 105 210
zstyle ':prompt:arx:'               delimiter-color   133
zstyle ':prompt:arx:'               primary-color-8colors \
                                                      6
zstyle ':prompt:arx:'               secondary-color-8colors \
                                                      6
zstyle ':prompt:arx:'               delimiter-color-8colors \
                                                      5
zstyle ':prompt:arx:vcs_info:'      hosts             {netslum,sakubo,corbenik,caerleon-medb}{,.mac-anu.org}
# separate man page completion by section.
zstyle -e ':completion:*:manuals.*' insert-sections   'if [[ $OSTYPE = solaris* ]]; then reply=(false); else reply=(true); fi'
zstyle ':completion:*:manuals'      separate-sections true
# per-match descriptions (if available)
zstyle ':completion:*'              verbose           true
# descriptions of commands (if available)
zstyle ':completion:*'              extra-verbose     true
# default seperator between option -- description, update list-colors if changed.
zstyle ':completion:*'              list-separator    '::'
zstyle ':completion:*'              completer         _expand _complete _correct _approximate
# message telling you what you are completing
zstyle ':completion:*'              format            "$(format_style Completing: %d)"
zstyle ':completion:*'              select-prompt     "$(format_style Menu-selection: current selection at %p)"
# this style is used by `_arguments --'
zstyle ':completion:*'              auto-description  "specify: %d"
# group completions by type
zstyle ':completion:*'              group-name        ''
# if there are atleast 0 matches, use menu selection
zstyle ':completion:*'              menu              select
# COLOUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUURSSSSSSSSSSSS
zstyle ':completion:*:default'      list-colors       'ma=38;5;183;48;5;60' 'tc=01;36' "${(s.:.)ZLS_COLORS}"
zstyle ':completion:*:(options|flags)' \
                                    list-colors       '=(#s)(#b)[[:space:]]#*[[:space:]]#[[:space:]]#(::)[[:space:]]#(*)(#B)(#e)=0=38;5;111=38;5;60'
zstyle ':completion::complete:vim:option-u-1:*' \
                                    fake              NONE
zstyle ':completion:*:(scp|ssh|rsync|sftp|qemu-system-*):*' \
                                    tag-order         'users:-normal:local\ user users hosts:-normal:hashed\ host hosts'
# username completion
zstyle ':completion:*:users'        ignored-patterns  '*'
zstyle ':completion:*:users'        fake-always       ${(A)reply::={llua,arx,root}}
zstyle ':completion:*:users-normal' ignored-patterns  $reply
# hostname completion
zstyle ':completion:*:hosts'        ignored-patterns  '*'
zstyle ':completion:*:hosts'        fake-always       ${(A)reply::={umbra,ansuz,corbenik,netslum,nypumi,caerleon-medb,al-fadel,sakubo,tarvos,aurora,fidchell,login1,login2}}
zstyle ':completion:*:hosts-normal' ignored-patterns  $reply
# completion of pids
zstyle ':completion:*:processes'    format            "$(format_style Completing: %d "(pid user lstart %%%cpu %%%mem rss args)")"
zstyle ':completion:*:processes'    command           'ps -o pid,user,lstart,pcpu,pmem,rss,args -A'
zstyle ':completion:*:nsenter:*:processes' \
                                    format            "$(format_style Completing: %d "(pid command systemd-machined-id utsns netns mntns pidns ipcns userns)")"
zstyle ':completion:*:nsenter:*:processes' \
                                    command           'ps -o pid,comm,machine,utsns,netns,mntns,pidns,ipcns,userns -A'
# completion of process names
zstyle ':completion:*:killall:*'    command           'ps -o comm -A'
# grouping stuff menu selection mostly
zstyle ':completion::complete:-subscript-::' \
                                    tag-order         'indexes association-keys'
zstyle ':completion:*:*:configure:*' \
                                    tag-order         'options:-enable:enable\ feature options:-other options:-disable:disable\ feature'
zstyle ':completion:*:configure:*:options-enable' \
                                    ignored-patterns  '^--enable-*'
zstyle ':completion:*:configure:*:options-other' \
                                    ignored-patterns  '--(dis|en)able-*'
zstyle ':completion:*:configure:*:options-disable' \
                                    ignored-patterns  '^--disable-*'
zstyle ':completion::complete:pacman:argument-rest:' \
                                    group-order       repo_packages packages
zstyle -e ':completion:*:*:systemctl-(((re|)en|dis)able|status|(*re|)start|reload*):*' \
                                    tag-order         'local type; for type in service template target timer socket mount slice device busname
                                                         reply+=( systemd-units:-${type}:${type} )
                                                         reply=( "$reply systemd-units:-misc:misc" )'
zstyle ':completion:*:systemd-units-service' \
                                    ignored-patterns  '^*.service'
zstyle ':completion:*:systemd-units-template' \
                                    ignored-patterns  '^*@'
zstyle ':completion:*:systemd-units-target' \
                                    ignored-patterns  '^*.target'
zstyle ':completion:*:systemd-units-timer' \
                                    ignored-patterns  '^*.timer'
zstyle ':completion:*:systemd-units-socket' \
                                    ignored-patterns  '^*.socket'
zstyle ':completion:*:systemd-units-mount' \
                                    ignored-patterns  '^*.mount'
zstyle ':completion:*:systemd-units-slice' \
                                    ignored-patterns  '^*.slice'
zstyle ':completion:*:systemd-units-device' \
                                    ignored-patterns  '^*.device'
zstyle ':completion:*:systemd-units-busname' \
                                    ignored-patterns  '^*.busname'
zstyle ':completion:*:systemd-units-misc' \
                                    ignored-patterns  '*(@|.(service|target|timer|socket|mount|slice|device|busname))'
zstyle ':completion:*:*:machinectl*:*' \
                                    tag-order         'systemd-machines:-qemu:qemu\ virtual\ machine systemd-machines:-container:container systemd-machines:-misc:machine'
zstyle ':completion:*:systemd-machines-misc' \
                                    ignored-patterns  '(lxc|qemu)-*'
zstyle ':completion:*:systemd-machines-container' \
                                    ignored-patterns  '^lxc-*'
zstyle ':completion:*:systemd-machines-qemu' \
                                    ignored-patterns  '^qemu-*'
# misc stuff
zstyle ':completion:*'              special-dirs      ..
zstyle :completion::complete:-command-::commands \
                                    ignored-patterns  restart reboot vendor_perl
zstyle :completion::complete:-tilde-:: \
                                    group-order       named-directories users
zstyle -e ':completion::complete:pkg-install:*:*' \
                                    tag-order         'if [[ $IPREFIX$PREFIX$SUFFIX$ISUFFIX = */* ]]; then reply=("!packages" -); fi'
zstyle ':completion:*:*:(lua|lua5[12]|lua-#5.[12]):*:*' \
                                    file-patterns     '*(-/):directories:directories *.(#i)lua(-.):globbed-files:lua\ scripts ^*.(#i)lua(-.):other-files:other\ files'
# avoiding _perl's restrictive _files glob
zstyle ':completion:*:*:perl:*:*'   file-patterns     '*(-/):directories:directories *.(p[ml]|PL|t)(-.):globbed-files:perl\ scripts *~*.(p[ml]|PL|t)(^/):other-files:other\ files'
zstyle ':completion::complete:perl:option-M-1:' \
                                    use-cache         true
zstyle ':completion::complete:salt(|-cp|-call):minions:' \
                                    cache-ttl         60 days
zstyle ':completion::complete:journalctl:option-b-1:' \
                                    sort              false
zstyle ':completion::complete:reautoload:argument-rest:' \
                                    tag-order         'functions:-nounderscore functions:-underscore'
zstyle ':completion:*:functions-nounderscore'         ignored-patterns '_*'
zstyle ':completion:*:functions-underscore'           ignored-patterns '^_*'
# complete jails from /usr/jail when -c is used
zstyle -e ':completion::complete:jail:argument-rest:jails' \
                                                      fake '[[ -v opt_args[(i)-c] ]] && reply=(/usr/jail/^freebsd*(:t))'
zstyle ':completion:*'              cache-path        ${ZDOTDIR:-$HOME/.config}/zcompcache
zstyle ':completion:*:(mpc|zypper|sysrc|ansible(|-doc)|salt(|-cp|-call|-run|-key)):*' \
                                    use-cache         true
zstyle ':completion:most-recent-file:*' \
                                    match-original    both
zstyle ':completion:most-recent-file:*' \
                                    file-sort         modification
zstyle ':completion:most-recent-file:*' \
                                    file-patterns     '*:all\ files'
zstyle ':completion:most-recent-file:*' \
                                    hidden            all
zstyle ':completion:most-recent-file:*' \
                                    completer         _files
zstyle ':completion:*:events'       range             50
zstyle ':completion:*'              insert-tab        false
zstyle ':completion:*'              list-dirs-first   true # may cause completers to fail, look into why.
zstyle ':completion:*'              accept-exact      false
zstyle ':completion:*'              accept-exact-dirs true
# see COMPLETION MATCHING CONTROL in zshcompwid for details.
# when completion is invoked and zsh compares the word you typed with possible choices, a type of pattern matching(not exactly like what is used on the cli)
# is used and by default it appends `*' to the current word and any choices that doesn't match the pattern is omitted.
# an example being typing ..u<TAB> with a possible choice of `comp.sources.unix', with the default behavior `..u*' would not match `comp.sources.unix' thus not be presented.
# the matcher/matcher-list style controls what the pattern ultimately results in. the entire completion system is ran for each entry, thus twice in my config.
# m:{[:lower:][:upper:]}={[:upper:][:lower:]} lets any lowercase character in the current word be completed to itself or its uppercase counterpart and the same with
# uppercase characters matching itself or their lowercase counterpart.
# you can think of it in filename generation terms as: (#i)..u
# l:|=* prepends * to the current-word/match-pattern for filtering possible choices.
# you can think of it in filename generation terms as: *(#i)..u
# r:|=* appends * to the current-word/match-pattern for filtering possible choices.
# you can think of it in filename generation terms as: *(#i)..u*
# r:|[._-]=** is checking the word for substrings matching empty string (the left side of the |) that has characters ., _ or - to the right of it.
# effectively matching anywhere those three characters appear and inserting a ** after the empty string. note this `**' is different than recursive globbing.
# `*' would match up to the anchor pattern of [._-] but `**' will match the anchor too.
# to illustrate the difference:
# _foo() { local expl; _wanted usenet-groups expl group compadd -M 'r:|[._-]=*' comp.sources.unix }; compdef _foo foo
# foo c.s.u<TAB> # will insert comp.sources.unix
# foo .u<TAB>    # will not
# you can think of it in filename generation terms as: *(#i)*.*.u*
# _foo() { local expl; _wanted usenet-groups expl group compadd -M 'r:|[._-]=**' comp.sources.unix }; compdef _foo foo
# foo c.s.u<TAB> # will insert comp.sources.unix
# foo .u<TAB>    # will also insert comp.sources.unix
# this is where the comparsion to filename generation kinda breaks down because its not like: *(#i)**.**.u* but kinda like *(#i)****u*
zstyle ':completion:*'              matcher-list      '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=* l:|=*'
zstyle ':completion:*'              use-compctl       false
zstyle ':completion:*'              rehash            true
autoload -Uz compinit
compinit


# Prompt stuff
autoload -Uz promptinit; promptinit
prompt arx >/dev/null 2>&1

zle -C most-recent-file menu-complete _generic
if [[ $OSTYPE == *linux* ]]; then
  if [[ -f /etc/arch-release ]]; then
    AUTOREMOVE() sudo pacman -R ${(of)"$(pacman -Qdtq)"}
    AUTOCLEAN() sudo pacman -Sc
  fi
fi

# unalias -m '*'
# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/toothpaste/.cache/lm-studio/bin"
