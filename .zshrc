# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="munro"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want disable red dots displayed while waiting for completion
# DISABLE_COMPLETION_WAITING_DOTS="true"


# Setup variables
export PATH="$HOME/local/bin:/usr/local/bin:$PATH"
export EDITOR="vim"

# Git variables
export GIT_AUTHOR_NAME="Munro"
export GIT_AUTHOR_EMAIL="munro.github@gmail.com"
export GIT_COMMITTER_NAME="Munro"
export GIT_COMMITTER_EMAIL="munro.github@gmail.com"

# Hg varialbes
export HGUSER="Munro"
export EMAIL="munro.github@gmail.com"

# Keyring client
export SSH_AUTH_SOCK="$GNOME_KEYRING_CONTROL/ssh"

# Things not quite ready for the year 3000:
# * Node.js
if [ -f "`which python2`" ]; then
    export PYTHON="python2"
fi

if [ -f "$HOME/.nvm/nvm.sh" ]; then
    source ~/.nvm/nvm.sh
fi

if [ -f "$HOME/.localrc" ]; then
    source ~/.localrc
fi


# Change font size
setfontsize () {
    printf '\e]710;%s%s\007' "xft:Ubuntu Mono-" $1
}

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git django deb node npm pip redis-cli nyan mercurial)
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
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
