# .dotfiles

## Install these dotfiles

```shell
curl -fsSL https://raw.githubusercontent.com/munro/dotfiles/refs/heads/main/setup.sh | sh
```

One-line install, which will:

1. Clones this repo to `~/dotfiles`
2. Runs `python3 install.py` **(dry run)**

### To apply changes

```shell
python3 install.py apply
```

> [!WARNING]
> This copies any conflicting dotfiles from your home directory into `~/dotfiles` (so they can be tracked)
>
> Then **replaces** the originals with symlinks pointing to them at `~/dotfiles`
>
> There should be no data loss, but no guarantees. :)

### Auto-sync (optional)

Keep dotfiles up to date with a cron job that fetches and fast-forward merges every 30 minutes:

```shell
./install_update_cron.sh           # Install/update the cron job
./install_update_cron.sh --remove  # Remove it
```

> [!WARNING]
> The cron job runs with `--auto-apply`, which automatically applies dotfile symlinks after merging.
> **Run a dry run first** to make sure nothing will be overwritten unexpectedly:
>
> ```shell
> python3 install.py        # Dry run — shows what would change
> python3 install.py apply  # Apply once you're happy
> ```

Status is written to `~/.local/state/dotfiles-sync` and shown in the shell prompt when something needs attention:

- **DOTFILES DIRTY** — uncommitted changes, sync skipped
- **DOTFILES UNPUSHED** — local commits not pushed to remote
- **DOTFILES SYNC FAILED** — fast-forward merge failed (diverged history)
- **DOTFILES FETCH FAILED** — couldn't reach remote (network issue)
