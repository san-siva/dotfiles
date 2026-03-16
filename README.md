# dotfiles

Personal macOS development environment — Neovim, terminal, shell, and tooling configuration.

![Terminal Setup](assets/terminal-setup.png)

**📖 Full documentation: [dotfiles.santhoshsiva.dev](https://dotfiles.santhoshsiva.dev)**

---

## Quick Start

```bash
# Clone directly to ~/.config
git clone https://github.com/san-siva/dotfiles ~/.config
```

```bash
# Copy config templates and fill in your details
cp configs/.gitconfig.example configs/.gitconfig
cp configs/.gitconfig__wrk.example configs/.gitconfig__wrk
cp configs/ssh_config.example configs/ssh_config
```

```bash
# Full environment bootstrap (installs all tools + symlinks dotfiles)
~/.config/bin/dev/setup/setup-environment

# Or run individually:
~/.config/bin/dev/setup/install-global-deps  # global npm/brew/pip packages
~/.config/bin/dev/setup/link-dotfiles        # symlink configs to ~/
```

## What's Included

| Directory | Contents |
|---|---|
| `nvim/` | Full Neovim IDE config — LSP, treesitter, conform, telescope, supermaven |
| `kitty/` | Kitty terminal — Catppuccin Frappé theme, JetBrainsMono NF |
| `configs/` | Dotfiles: zsh, git, tmux, prettier, eslint, tsconfig, ssh |
| `bin/` | Shell scripts — ADB utils, dev tools, setup scripts |
| `git/` | Global gitconfig and gitignore |
| `assets/` | Screenshot, patched fonts, Catppuccin zsh theme files |

## License

MIT — see [LICENSE](LICENSE)

## Author

Santhosh Siva · [github.com/san-siva](https://github.com/san-siva)
