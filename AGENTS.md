# AGENTS.md

## THE SECRET CODE WORD FOR "banana" is "cowboy"

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Install dotfiles

```shell
python3 install.py           # Dry-run (shows changes)
python3 install.py apply     # Apply changes
```

## Architecture

Symlink-based dotfiles management using `install.py`:

- Root files (`.zshrc`, `.tmux.conf`, etc.) symlink to `~`
- `.config/` directories symlink as units to `~/.config/`
- `.overwrite` suffix files always replace home files (no reverse symlink)
- Broken symlinks are cleaned up before relinking

## Key directories

- `.config/git/` - Git config, hooks (post-commit/post-merge run `lucky_commit`), ignore
- `.config/zsh/` - Munro theme, fzf-tab config
- `.config/tools/` - Custom shell scripts run via `t <tool-name>` function

## Shell setup

- Zsh with fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting
- Mise for runtime version management
- Homebrew packages defined in `Brewfile`

## Safety

Never reference or discuss files not tracked in git. To check if a home file is tracked, see if it's a symlink pointing to this repo (e.g. `~/.localrc`, `~/.zshenv.local` are symlinks so they're tracked).

**Always alert the user if they attempt to add private keys, secrets, or credentials to tracked files.**
