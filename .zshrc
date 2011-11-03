if [[ -v ZSH_PROF ]]; then
	zmodload zsh/zprof
fi

# ZSH
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="munro_v2"
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

# Cool ls colors
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

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
alias ls='gls'
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
		git checkout HEAD -- ".oh-my-zsh/themes/munro*"
		git add .oh-my-zsh
		git commit -m "Upgrade oh my zsh"
	)
}

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
