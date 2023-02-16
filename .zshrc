if [[ -v ZSH_PROF ]]; then
	zmodload zsh/zprof
fi

# ZSH
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="../../.oh-my-theme/munro_v2"
export DISABLE_AUTO_UPDATE="true"
export ZSH_DISABLE_COMPFIX=true
export DISABLE_UPDATE_PROMPT=true
plugins=(git direnv)
source $ZSH/oh-my-zsh.sh

# Homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
export PATH="$HOMEBREW_REPOSITORY/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

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

# Source tools
if command -v fnm &>/dev/null; then
	eval "$(fnm env)"
fi
if [ -d "$/Library/TeX/texbin" ]; then
	export PATH="$PATH:/Library/TeX/texbin"
fi
if [ -d "$HOME/.juliaup/bin" ]; then
	export PATH="/Users/toothpaste/.juliaup/bin:$PATH"
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

# Alias
alias nvm=fnm
alias awk='gawk'
alias sed='gsed'
alias tar='gtar'
alias sort='gtar'
alias xargs='gxargs'
alias tee='gtee'
alias ls='gls --color=auto'
alias find='gfind'
alias grep='ggrep'
alias head='ghead'
alias tail='gtail'
alias uniq='guniq'
alias ln='gln'
alias poerty="poetry"
alias rgrep="ggrep -R --exclude-dir=external --exclude-dir=node_modules --exclude-dir=.git '--exclude-dir=.*' \
'--exclude=*.ipynb' '--exclude=*.pyc' '--exclude=*.parquet*' '--exclude=*.sqlite*' \
'--exclude=*.gz' '--exclude=*.zip' '--exclude=*.bz2' \
'--exclude=*.png' '--exclude=*.jpg' '--exclude=*.jpeg' '--exclude=*.gif' '--exclude=*.ico'"

# Cool functions
function setup_brew_dependencies() {
	echo brew install \
		`# apps` \
		karabiner-elements protonmail-bridge protonvpn youtube-dl spotify \
		mattermost vlc qbittorrent anki discord figma wireshark mactex \
		`# shell` \
		zsh coreutils curl findutils gawk gettext gnu-getopt gnu-indent \
		rsync telnet vim wget grep gnu-sed gnu-tar graphviz jq autossh \
		iperf \
		`# dev tools` \
		git direnv gnutls openssl@1.1 python tmate tmux poetry nvim \
		chromedriver miniconda fnm nodejs rustup geckodriver \
		`# misc` \
		cowsay lolcat nyancat \
		homebrew/cask-drivers/logitech-camera-settings
}
function poetryrun() {
	project_dir=$1
	shift
	(cd $project_dir && PYTHONPATH=${project_dir} poetry run -C ${project_dir} $@)
}
function woozy() {
	git commit -m "🥴"
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

# Cool ls colors
source ~/.ls_colors.sh

# Local settings
if [ -f "$HOME/.localrc" ]; then
	source ~/.localrc
fi

# Auto complete
zstyle ':completion:*' accept-exact '*(N)'

# beep boop
if [[ -v ZSH_PROF ]]; then
	zprof
fi
