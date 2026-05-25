# AGENTS.md

This file provides guidance to AI coding agents working in this homeshick dotfiles repository.

## Repository Structure

This is a [homeshick](https://github.com/andsens/homeshick) castle (dotfiles repository). Configuration files live under `home/` and are symlinked into the user's home directory.

### Modules

| Prefix | Path | Description |
|--------|------|-------------|
| `[bash]` | `home/.bashrc`, `home/.aliases` | Bash shell configuration |
| `[git]` | `home/.gitconfig`, `home/.gitignore` | Git configuration |
| `[tmux]` | `home/.tmux.conf`, `home/.tmux/`, `home/.config/tmux/` | Tmux configuration and themes |
| `[nvim]` | `home/.config/nvim/` | Neovim configuration (Lua-based) |
| `[ghostty]` | `home/.config/ghostty/` | Ghostty terminal emulator config |
| `[mc]` | `home/.config/mc/` | Midnight Commander configuration |
| `[zathura]` | `home/.config/zathura/` | Zathura PDF viewer configuration |
| `[gdb]` | `home/.gdbinit` | GDB debugger configuration |
| `[latex]` | `home/.latexmkrc` | Latexmk configuration |
| `[ripgrep]` | `home/.ripgreprc` | Ripgrep configuration |

## Commit Message Conventions

All commit titles **must** be prefixed with a module tag in square brackets indicating which area is being changed:

```
[module] Brief description of the change
```

### Examples

```
[nvim] Add keybinding for buffer navigation
[bash] Update alias for package management
[tmux] Adjust status bar colour scheme
[git] Add new ignore pattern for build artefacts
[ghostty] Configure font size and family
```

### Rules

- Use the correct prefix from the table above
- Separate the prefix from the description with a single space
- Use the imperative mood (e.g., "Add", "Fix", "Update", "Remove")
- Keep the title under 72 characters
- Use Canadian spelling (e.g., `colour`, `centre`, `organize`, `favour`, `behaviour`)
- Add a longer description in the commit body if the change is non-obvious

## Language and Spelling

This project uses **Canadian English** spelling conventions:

- `-our` not `-or` (colour, behaviour, favour)
- `-re` not `-er` (centre, metre, theatre)
- `-ize` (organize, realize, prioritize)
- `-ll-` in inflected forms (travelled, cancelling)
- `-ogue` not `-og` (catalogue, dialogue)

Apply this to commit messages, comments, and any documentation.
