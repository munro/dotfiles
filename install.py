# /// script
# requires-python = ">=3"
# ///

# =============================================================================
# IMPORTS
# =============================================================================

import os.path
import pathlib
import shutil
import subprocess
import sys
from pathlib import Path

# =============================================================================
# PATHS & CONSTANTS
# =============================================================================

CURRENT_FILE = pathlib.Path(__file__)
DOTFILES = pathlib.Path(__file__).parent
HOME = pathlib.Path.home()
DONT_COPY_FILES = [
    DOTFILES / "README.md",
    DOTFILES / ".gitignore",
    DOTFILES / "setup.sh",
    CURRENT_FILE,
]

CHANGES = 0


# =============================================================================
# ENTRYPOINT
# =============================================================================


def main(argv: list[str]) -> None:
    apply_changes = len(argv) >= 2 and argv[1] == "apply"
    dry_run = not apply_changes
    git_files = git_tracked_and_unignored(DOTFILES)

    root_files = {x for x in git_files if len(x.parts) == 1}
    config_files = {
        Path(*x.parts[:2])
        for x in git_files
        if len(x.parts) >= 2 and x.parts[0] == ".config"
    }

    apply_dotfiles(root_files, dry_run=dry_run)
    apply_dotfiles(config_files, dry_run=dry_run)
    apply_overwrite_files(dry_run=dry_run)
    apply_delete_files(dry_run=dry_run)
    if CHANGES == 0:
        print(f"\n{GREEN}{BOLD}✅ NO CHANGES TO APPLY.{RESET}")
    elif dry_run:
        print(
            f"\n{YELLOW}{BOLD}🚧 DRY RUN.{RESET}"
            f"\n{YELLOW}RUN WITH {GREEN}{BOLD}apply{RESET}{YELLOW} TO APPLY {CHANGES} CHANGES.{RESET}",
            f"\n\n{GREEN}{BOLD}python3 {collapse_home(CURRENT_FILE)} apply{RESET}\n",
        )
    else:
        print(f"\n{GREEN}{BOLD}✅ {CHANGES} CHANGES APPLIED.{RESET}")


# =============================================================================
# DOTFILE APPLICATION
# =============================================================================


def apply_dotfiles(root_files: set[Path] | list[Path], dry_run: bool = True):
    global CHANGES

    root_files = list(sorted(root_files))
    for relative_file in root_files:
        file = DOTFILES / relative_file
        home_file = HOME / file.relative_to(DOTFILES)

        if file in DONT_COPY_FILES:
            continue

        if file.name.endswith(".delete"):
            continue

        if home_file.exists():
            assert home_file.is_dir() is file.is_dir()

        if not os.path.lexists(file):
            continue

        home_file = HOME / file.relative_to(DOTFILES)

        if home_file.is_symlink() and home_file.readlink() == file:
            print_perfect(file=file, home_file=home_file)
            continue

        if home_file.is_symlink() and not home_file.exists():
            print_remove_broken_symlink(file=file, home_file=home_file)
            if not dry_run:
                home_file.unlink()
                CHANGES += 1
            else:
                continue  # Cannot dry run anymore            # DONT STOP, LATER LOGIC WILL REPLACE THIS

        if file.is_fifo() or file.is_socket() or file.is_fifo():
            raise NotImplementedError(f"TODO {relative_file=} [{file.stat().st_mode=}]")
        elif file.is_dir():
            apply_dir(file=file, dry_run=dry_run)
        else:
            apply_file(file=file, dry_run=dry_run)


# =============================================================================
# FILE APPLICATION
# =============================================================================


def apply_file(*, file: Path, dry_run: bool = True):
    home_file = HOME / file.relative_to(DOTFILES)

    assert not file.is_dir()

    if file.is_symlink():
        if not os.path.lexists(home_file):
            print_touch_reverse_symlink_file(file=file, home_file=home_file)
            if not dry_run:
                home_file.touch()
            return

        print_reverse_symlink(file=file, home_file=home_file)
        return

    if not home_file.exists():
        if not dry_run:
            home_file.symlink_to(file)
        print_create_symlink(file=file, home_file=home_file)
        return

    assert not home_file.is_dir()

    if not dry_run:
        file.write_bytes(home_file.read_bytes())
        home_file.unlink()
        home_file.symlink_to(file)
    print_copied_and_linked(file=file, home_file=home_file)


# =============================================================================
# DIRECTORY APPLICATION
# =============================================================================


def apply_dir(*, file: Path, dry_run: bool = True):
    assert file.is_dir()

    home_file = HOME / file.relative_to(DOTFILES)

    if not home_file.exists():
        if not dry_run:
            home_file.symlink_to(file, target_is_directory=True)
        print_create_symlink(file=file, home_file=home_file)
        return

    if home_file.is_symlink():
        raise NotImplementedError("TODO make sure copying with symlinks works")

    assert home_file.is_dir()

    # Check we can copy correctly
    for inner_home_file in home_file.rglob("**/*"):
        if inner_home_file.is_symlink():
            raise NotImplementedError(
                f"TODO make sure copying with symlinks works: {inner_home_file=} for {home_file=}"
            )
        if not (inner_home_file.is_dir() or inner_home_file.is_file()):
            raise NotImplementedError(
                f"TODO {inner_home_file=} [{inner_home_file.stat().st_mode=}]"
            )

    # Copy the directory
    if not dry_run:
        shutil.rmtree(file, ignore_errors=True)
        shutil.copytree(home_file, file, dirs_exist_ok=True)
        shutil.rmtree(home_file, ignore_errors=True)
        home_file.symlink_to(file, target_is_directory=True)
    print_copied_and_linked(file=file, home_file=home_file)


# =============================================================================
# OVERWRITE FILE APPLICATION
# =============================================================================


def apply_overwrite_files(dry_run: bool = True):
    global CHANGES

    for overwrite_file in sorted(DOTFILES.glob("**/*.overwrite")):
        relative = overwrite_file.relative_to(DOTFILES)
        target_relative = Path(str(relative).removesuffix(".overwrite"))
        target_file = HOME / target_relative

        if target_file.exists() and target_file.read_bytes() == overwrite_file.read_bytes():
            print_overwrite_perfect(overwrite_file=overwrite_file, target_file=target_file)
            continue

        if not dry_run:
            target_file.parent.mkdir(parents=True, exist_ok=True)
            if target_file.exists():
                target_file.unlink()
            shutil.copy2(overwrite_file, target_file)
        print_overwrite_copied(overwrite_file=overwrite_file, target_file=target_file)
        CHANGES += 1


# =============================================================================
# DELETE FILE APPLICATION
# =============================================================================


def apply_delete_files(dry_run: bool = True):
    global CHANGES

    for delete_file in sorted(DOTFILES.glob("**/*.delete")):
        relative = delete_file.relative_to(DOTFILES)
        target_relative = Path(str(relative).removesuffix(".delete"))
        target_path = HOME / target_relative

        if not os.path.lexists(target_path):
            print_delete_already_gone(delete_file=delete_file, target_path=target_path)
            continue

        if not dry_run:
            if target_path.is_symlink() or target_path.is_file():
                target_path.unlink()
            elif target_path.is_dir():
                shutil.rmtree(target_path)
        print_delete_removed(delete_file=delete_file, target_path=target_path)
        CHANGES += 1


# =============================================================================
# PATH HELPERS
# =============================================================================


def collapse_home(path: Path) -> Path:
    return Path("~") / path.relative_to(HOME) if path.is_relative_to(HOME) else path


def git_tracked_and_unignored(root: Path) -> list[Path]:
    out = subprocess.check_output(
        ["git", "-C", str(root), "ls-files", "-co", "--exclude-standard"],
        text=True,
    )
    return [Path(line) for line in out.splitlines() if line]


# =============================================================================
# NOTICE HELPERS
# =============================================================================


def print_perfect(*, file: Path, home_file: Path) -> None:
    print_notice(
        RIGHT_ARROW,
        dimmed_file(home_file.readlink()),
        icon="⭐",
        home_file=home_file,
    )


def print_reverse_symlink(*, file: Path, home_file: Path) -> None:
    print_notice(
        f"{MAGENTA}<-",
        dimmed_file(file),
        f"{MAGENTA}{BOLD}(PRIVATE LINK)",
        icon="⭐",
        home_file=home_file,
    )


def print_touch_reverse_symlink_file(*, file: Path, home_file: Path) -> None:
    global CHANGES
    CHANGES += 1
    print_notice(
        f"{MAGENTA}<-",
        dimmed_file(file),
        f"{MAGENTA}{BOLD}(TOUCHED REVERSE SYMLINK FILE)",
        icon="⭐",
        home_file=home_file,
    )


def print_remove_broken_symlink(*, file: Path, home_file: Path) -> None:
    global CHANGES
    CHANGES += 1
    print_notice(
        f"{RED}{BOLD}(BROKEN SYMLINK)",
        f"{YELLOW}->",
        dimmed_file(file),
        f"{YELLOW}(REMOVED, THEN LINKED)",
        icon="⚠️",
        home_file=home_file,
    )


def print_create_symlink(*, file: Path, home_file: Path) -> None:
    global CHANGES
    CHANGES += 1
    print_notice(
        RIGHT_ARROW,
        dimmed_file(file),
        f"{GREEN}{BOLD}(SETUP SYMLINK)",
        icon="✅",
        home_file=home_file,
    )


def print_copied_and_linked(*, file: Path, home_file: Path) -> None:
    global CHANGES
    CHANGES += 1
    print_notice(
        f"{GREEN}<->",
        dimmed_file(file),
        f"{GREEN}{BOLD}(COPIED AND LINKED)",
        icon="⚠️",
        home_file=home_file,
    )


def print_overwrite_perfect(*, overwrite_file: Path, target_file: Path) -> None:
    print_notice(
        f"{DIM}<-",
        dimmed_file(overwrite_file),
        icon="⭐",
        home_file=target_file,
    )


def print_overwrite_copied(*, overwrite_file: Path, target_file: Path) -> None:
    print_notice(
        f"{CYAN}<-",
        dimmed_file(overwrite_file),
        f"{CYAN}{BOLD}(OVERWRITE COPIED)",
        icon="📋",
        home_file=target_file,
    )


def print_delete_already_gone(*, delete_file: Path, target_path: Path) -> None:
    print_notice(
        f"{DIM}<-",
        dimmed_file(delete_file),
        f"{DIM}(ALREADY GONE)",
        icon="⭐",
        home_file=target_path,
    )


def print_delete_removed(*, delete_file: Path, target_path: Path) -> None:
    print_notice(
        f"{RED}<-",
        dimmed_file(delete_file),
        f"{RED}{BOLD}(DELETED)",
        icon="🗑️",
        home_file=target_path,
    )


# =============================================================================
# RENDERING HELPERS
# =============================================================================


def print_notice(*parts: str, icon: str, home_file: Path) -> None:
    subject = collapse_home(home_file)
    line = f"{icon} {BOLD}{subject}{RESET}"
    if parts:
        tail = " ".join(f"{part}{RESET}" for part in parts)
        line = f"{line} {tail}"
    print(f"{line}{RESET}")


# =============================================================================
# TERMINAL FORMATTING
# =============================================================================


def dimmed_file(path: Path) -> str:
    return f"{BLUE}{collapse_home(path)}"


# =============================================================================
# ANSI COLORS & SYMBOLS
# =============================================================================

RESET = "\x1b[0m"
BOLD = "\x1b[1m"
DIM = "\x1b[2m"
UNDERLINE = "\x1b[4m"
YELLOW = "\x1b[33m"
RED = "\x1b[31m"
GREEN = "\x1b[32m"
BLUE = "\x1b[34m"
PURPLE = "\x1b[35m"
CYAN = "\x1b[36m"
MAGENTA = "\x1b[35m"
WHITE = "\x1b[37m"

RIGHT_ARROW = f"{DIM}{BOLD}->"


# =============================================================================
# SCRIPT ENTRY
# =============================================================================

if __name__ == "__main__":
    main(sys.argv)
