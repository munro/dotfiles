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
