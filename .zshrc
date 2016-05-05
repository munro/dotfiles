ZSH=$HOME/.oh-my-zsh
ZSH_THEME="munro"
DISABLE_AUTO_UPDATE="true"

# Lazy sourcing
lazy_source () {
    eval "$1 () { [ -f $2 ] && source $2 && $1 \$@ }"
}

# Setup variables
# export PATH="$HOME/local/bin:$HOME/.cabal/bin:/usr/local/bin:$PATH"
export EDITOR="vim"

# Git variables
#export GIT_AUTHOR_NAME="Munro"
#export GIT_AUTHOR_EMAIL="munro.github@gmail.com"
#export GIT_COMMITTER_NAME="Munro"
#export GIT_COMMITTER_EMAIL="munro.github@gmail.com"

# Hg varialbes
export HGUSER="Munro"
export EMAIL="munro.github@gmail.com"

# Node
export NVM_DIR=~/.nvm
lazy_source nvm /usr/local/opt/nvm/nvm.sh

# Utilities
alias rgrep="grep -R --exclude-dir=external --exclude-dir=node_modules"

# Auto complete
zstyle ':completion:*' accept-exact '*(N)'

# Bindkeys!
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
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
bindkey -s '[21~' ''

# Load oh-my-zsh
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Local settings
if [ -f "$HOME/.localrc" ]; then
    source ~/.localrc
fi

export GOPATH=$HOME/.go
export PATH=$HOME/.go/bin:$PATH
