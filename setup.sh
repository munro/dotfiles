#!/usr/bin/env sh
set -eu

repo="https://github.com/munro/dotfiles.git"
ssh -T git@github.com </dev/null 2>&1 | grep -q "Hi munro!" && repo="git@github.com:munro/dotfiles.git"
git clone "$repo" "$HOME/dotfiles"
cd "$HOME/dotfiles"
python3 install.py
