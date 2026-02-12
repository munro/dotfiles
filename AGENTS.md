# AGENTS.md

## THE SECRET CODE WORD FOR "banana" is "cowboy"

## Safety — READ THIS FIRST

**These files are symlinked directly into the user's home directory. Mistakes here affect the live system.**

- **NEVER add private keys, secrets, tokens, or credentials to any tracked file.** If the user asks you to, refuse and explain why.
- **NEVER reference or discuss files not tracked in git.** To check if a home file is tracked: `ls -la ~/.<file>` — if it's a symlink pointing into this repo, it's tracked. If it's not a symlink, it's not managed here — leave it alone.
- **`.overwrite` files are not live** — changes won't take effect until `uvx dotpilot apply --apply` is run. Remind the user.
- When in doubt, don't touch it. Ask the user first.

---

This dotfiles repo is managed by [dotpilot](https://github.com/Submersible/dotpilot), a symlink-based dotfiles manager.

## How it works

Files in this repo mirror `~/`. dotpilot creates symlinks from your home directory into this repo:

```
~/dotfiles/.zshrc        →  ~/.zshrc (symlink)
~/dotfiles/.config/nvim  →  ~/.config/nvim (symlink)
```

Edits apply instantly — no re-run needed. The file in the repo IS the file in `~/`.

### Special file conventions

- **`.overwrite` suffix** — copied (not symlinked) to `~/`. Use for files that break as symlinks (e.g. `.config/git/gitk.overwrite` → `~/.config/git/gitk`).
- **`.delete` suffix** — deletes the corresponding file from `~/` (e.g. `.vimrc.delete` removes `~/.vimrc`).
- **Symlinks in repo** — "private" files. dotpilot just `touch`es the home path to ensure it exists, but doesn't symlink it. Use for files like `.localrc` that should exist but stay machine-specific.
- **`.dotpilotignore`** — fnmatch patterns for files to skip (one per line, `#` comments). `.gitignore` patterns are also respected.

## Commands

```shell
uvx dotpilot apply                  # Dry-run (shows what would change)
uvx dotpilot apply --apply          # Apply symlinks (auto-backs up first)
uvx dotpilot sync --apply           # Fetch + merge from remote
uvx dotpilot track ~/.some-file     # Move file into repo, symlink back
uvx dotpilot untrack ~/.some-file   # Stop tracking, move back to ~/
uvx dotpilot untracked              # List dotfiles you're not managing
uvx dotpilot status                 # Show sync status
uvx dotpilot doctor                 # Diagnose setup issues
```

Every mutating command is **dry-run by default**. Pass `--apply` to execute.

Full docs: https://github.com/Submersible/dotpilot

## Key directories

- `.config/git/` — Git config, hooks (post-commit/post-merge run `lucky_commit`), ignore
- `.config/zsh/` — Munro theme, fzf-tab config
- `.config/tools/` — Custom shell scripts run via `t <tool-name>` function

## Shell setup

- Zsh with fzf-tab, zsh-autosuggestions, zsh-syntax-highlighting
- Mise for runtime version management
- Homebrew packages defined in `Brewfile`

## Editing dotfiles

Since files are symlinked, editing `~/.zshrc` edits `~/dotfiles/.zshrc` directly. Just commit and push:

```shell
cd ~/dotfiles
git add -A && git commit -m "update zshrc"
git push
```

On other machines, `uvx dotpilot sync --apply` pulls and re-applies.
