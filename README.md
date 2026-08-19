---
title: dotfiles
description: Personal macOS development environment — Neovim, terminal, shell, and tooling configuration.
---

A comprehensive macOS development environment managed as a git repository cloned directly to `~/.config`. Because all XDG-compliant tools look in `~/.config` by default, every config file is automatically in the right place with no extra symlinking needed.

The setup includes a full Neovim IDE configuration, Kitty terminal, Zsh shell config, global Git settings, ESLint / Prettier / TypeScript configs, and a collection of utility shell scripts for daily development.

> [!NOTE]
>
> **Theme:** The entire environment uses the **Catppuccin Frappé** color palette — Neovim, Kitty, and all terminal tools are configured to match.

## Directory Structure

All configuration lives under `~/.config`:

| Path       | Description                                                    |
| ---------- | -------------------------------------------------------------- |
| `nvim/`    | Neovim configuration (init.lua + Lua modules)                  |
| `kitty/`   | Kitty terminal — fonts, theme, window settings                 |
| `fish/`    | Fish shell — minimal PATH additions                            |
| `configs/` | Home-dir dotfiles (`.zshrc`, `.gitconfig`, `.tmux.conf`, etc.) |
| `bin/`     | Shell utility scripts (`android/`, `dev/`, `utils.sh`)         |
| `git/`     | Global git config and gitignore                                |
| `assets/`  | Screenshots, patched fonts, theme files                        |

> [!TIP]
>
> **XDG compliant:** Cloning to `~/.config` means tools like Neovim, Kitty, Fish, and gh pick up their configs automatically without any manual linking.

## Requirements

| Tool                      | Purpose                                 |
| ------------------------- | --------------------------------------- |
| `neovim 0.10+`            | Editor (required for all nvim features) |
| `node 18+ / nvm`          | JavaScript tooling, LSP servers         |
| `git`                     | Version control                         |
| `kitty`                   | Terminal emulator                       |
| `zsh`                     | Primary shell                           |
| `brew`                    | macOS package manager                   |
| `JetBrainsMono Nerd Font` | Font (all terminals + Neovim)           |

## Installation

Clone the repository directly to `~/.config`:

```bash
# Clone directly to ~/.config (XDG base dir)
git clone https://github.com/san-siva/dotfiles ~/.config

# If ~/.config already exists
cd ~/.config
git init
git remote add origin https://github.com/san-siva/dotfiles
git pull origin main
```

Three setup scripts handle the full environment bootstrap. Run them in order, or use `setup-environment` to run all three at once.

### setup-environment

The top-level bootstrapper. Installs all system tools via Homebrew, then delegates to `install-global-deps` and `link-dotfiles`.

```bash
~/.config/bin/dev/setup/setup-environment
```

| Category          | Installs                                                                                        |
| ----------------- | ----------------------------------------------------------------------------------------------- |
| Languages         | `python3`, `node` (via nvm), `ruby`, `go`, `lua`, `rust`                                        |
| Java              | `openjdk`, `openjdk@21`, `ant`, `maven`, `jdtls`, `google-java-format`                          |
| Editor / Terminal | `neovim`, `kitty`, `tmux` + TPM                                                                 |
| Shell             | `oh-my-zsh`, `powerlevel10k`, `zsh-history-substring-search`                                    |
| CLI tools         | `ripgrep`, `fzf`, `fd`, `zoxide`, `jq`, `yq`, `gh`, `fish`, `deno`, `wget`, `tree`, `fastfetch` |
| Formatters        | `black` (Python), `sqlfluff`, `shfmt` (via Go), `stylua` (via Cargo)                            |

### install-global-deps

Installs all global npm packages, symlinks ESLint configs, and enables Corepack. Safe to re-run.

```bash
~/.config/bin/dev/setup/install-global-deps
```

| Category       | Packages                                                                                                             |
| -------------- | -------------------------------------------------------------------------------------------------------------------- |
| ESLint core    | `eslint`, `eslint_d`, `jiti`, `@eslint/js`, `@eslint/eslintrc`, `@eslint/compat`                                     |
| ESLint plugins | `eslint-plugin-react`, `-react-hooks`, `-jest`, `-import`, `-redux-saga`, `-unicorn`, `simple-import-sort`, and more |
| TypeScript     | `typescript`, `typescript-eslint`, `@typescript-eslint/eslint-plugin`, `@typescript-eslint/parser`                   |
| Prettier       | `prettier`, `eslint-config-prettier`                                                                                 |
| Testing        | `jest`, `markdownlint-cli2`                                                                                          |
| Tools          | `@san-siva/gitsy`, `@anthropic-ai/claude-code`, `local-ssl-proxy`, `neovim` (npm provider)                           |
| ESLint configs | Symlinks `eslint.config.ts` and `eslint-utilities.ts` into the npm global prefix                                     |

### link-dotfiles

Creates symlinks from `~/.config/configs/` into the home directory. Removes any existing file or broken symlink at each target before linking.

```bash
~/.config/bin/dev/setup/link-dotfiles
```

| Source                                     | Symlinked to              |
| ------------------------------------------ | ------------------------- |
| `configs/.tmux.conf`                       | `~/.tmux.conf`            |
| `configs/.prettierrc.json`                 | `~/.prettierrc.json`      |
| `configs/.eslintrc.json`                   | `~/.eslintrc.json`        |
| `configs/.p10k.zsh`                        | `~/.p10k.zsh`             |
| `configs/.gitconfig`                       | `~/.gitconfig`            |
| `configs/.gitconfig__wrk`                  | `~/.gitconfig__wrk`       |
| `configs/ssh_config`                       | `~/.ssh/config`           |
| `configs/eclipse-java-google-style.xml`    | `~/.local/share/eclipse/` |
| `configs/lombok.jar`                       | `~/.local/share/eclipse/` |
| `configs/agent-skills`                     | `~/.claude/skills`        |
| `configs/agent-skills`                     | `~/.gemini/skills`        |
| `configs/antigravity-keybindings.json`     | `~/.gemini/antigravity-cli/keybindings.json` |

> [!WARNING]
>
> Existing files at the target paths will be removed before linking. Back up any local changes first.

## Neovim

A full IDE experience built in Lua using [lazy.nvim](https://github.com/folke/lazy.nvim). Entry point is `nvim/init.lua`; leader key is `,`.

```bash
nvim/
├── init.lua                   Entry point — options, loads bindings & plugins
├── lua/
│   ├── bindings/
│   │   ├── mappings.lua       Key mappings
│   │   └── autocmd.lua        Autocommands
│   ├── core/
│   │   └── large-files.lua    Large file detection & feature toggling
│   ├── plugins/
│   │   ├── init.lua           Plugin list (lazy.nvim)
│   │   ├── lspconfig.lua      LSP server configs
│   │   ├── conform.lua        Format-on-save setup
│   │   └── ...
│   ├── shared_ftplugins/
│   │   └── javascript.lua     Shared JS/TS ftplugin (reads prettier tabWidth)
│   └── utils/
│       ├── large-file-check.lua
│       └── wildignores.lua
└── ftplugin/
    ├── typescript.lua
    ├── javascript.lua
    ├── typescriptreact.lua
    ├── javascriptreact.lua
    ├── md.lua
    ├── python.lua
    └── java.lua
```

> [!NOTE]
>
> Set `NVIM_NPM=1` to open Neovim with all plugins disabled — useful when invoked inside Node.js scripts or tooling where startup time matters.

### Key Bindings

| Binding                     | Action                           |
| --------------------------- | -------------------------------- |
| `<C-c>`                     | Escape / cancel                  |
| `<Esc>`                     | Clear search highlight           |
| `<leader>tl` / `<leader>th` | Next / prev tab                  |
| `<leader>tL` / `<leader>tH` | New / close tab                  |
| `<leader>1`–9               | Jump to tab by number            |
| `<leader>bb`                | Alternate buffer                 |
| `<leader>p`                 | Copy relative path + line number |
| `<leader>P`                 | Copy absolute path               |
| `<leader>l`                 | Copy line number                 |
| `<leader>e` / `<leader>E`   | Float diagnostic / loclist       |
| `[e` / `]e`                 | Next / prev diagnostic           |
| `<leader>N` / `<leader>n`   | Toggle relative numbers          |
| `<leader>S`                 | Reload vimrc                     |
| `<leader>M`                 | Delete all marks                 |
| `<leader>ff`                | Telescope: find files            |
| `<leader>fg`                | Telescope: live grep             |
| `<leader>fb`                | Telescope: open buffers          |
| `<leader>fd`                | Telescope: diagnostics           |
| `<leader>tt`                | Toggle file tree                 |
| `<leader>gs`                | Git status                       |
| `<leader>gc`                | Git commit                       |
| `<leader>gh` / `<leader>gl` | Diffget ours / theirs            |
| `<leader>cJ` / `<leader>cK` | Open / close all folds           |
| `<C-o>`                     | Supermaven: accept suggestion    |
| `<C-y>`                     | Supermaven: accept word          |
| `<C-r>`                     | Supermaven: dismiss              |

### Autocommands

| Event                       | Action                                                                       |
| --------------------------- | ---------------------------------------------------------------------------- |
| `TextYankPost`              | Flash-highlight yanked text                                                  |
| `BufReadPre`                | Detect large files; set hash-based undo path for long file paths             |
| `BufReadPost`               | Disable swapfile, undofile, syntax, synmaxcol, treesitter for large files    |
| `BufWinEnter`               | Disable folding, cursorline, spell for large files                           |
| `BufReadPre` / `BufNewFile` | Read prettier tabWidth from config and set local indentation for JS/TS files |

### Plugins

| Plugin                     | Purpose                                          |
| -------------------------- | ------------------------------------------------ |
| `catppuccin/nvim`          | Colorscheme — Frappé flavor                      |
| `nvim-treesitter`          | Syntax highlighting + text objects               |
| `nvim-lspconfig` + `mason` | LSP server management                            |
| `conform.nvim`             | Format on save                                   |
| `nvim-cmp` + `luasnip`     | Completion — LSP, snippets, path, dictionary     |
| `telescope.nvim`           | Fuzzy finder — files, grep, buffers, diagnostics |
| `nvim-tree.lua`            | File explorer sidebar                            |
| `gitsigns.nvim`            | Git diff signs in gutter                         |
| `vim-fugitive`             | Git commands inside Neovim                       |
| `supermaven-nvim`          | AI inline completion                             |
| `nvim-ufo`                 | Code folding via LSP / treesitter                |
| `lualine.nvim`             | Status line + buffer tabline                     |
| `indent-blankline.nvim`    | Indent guides                                    |
| `nvim-colorizer.lua`       | Hex/CSS color preview                            |
| `markdown-preview.nvim`    | Live browser preview with Mermaid                |
| `nvim-jdtls`               | Java LSP (Eclipse JDT)                           |
| `todo-comments.nvim`       | TODO / FIXME highlighting                        |
| `Comment.nvim`             | Comment toggling                                 |
| `fidget.nvim`              | LSP progress spinner                             |

### Language Support

| Language                            | LSP            | Formatter             |
| ----------------------------------- | -------------- | --------------------- |
| TypeScript / JavaScript             | `ts_ls`        | `prettier`            |
| ESLint diagnostics                  | `eslint`       | —                     |
| Go                                  | `gopls`        | `goimports` + `gofmt` |
| Python                              | `basedpyright` | `isort` + `black`     |
| Lua                                 | `lua_ls`       | `stylua`              |
| Bash                                | `bashls`       | `shfmt`               |
| TailwindCSS                         | `tailwindcss`  | —                     |
| Java                                | `nvim-jdtls`   | `google-java-format`  |
| CSS / SCSS / HTML / JSON / Markdown | —              | `prettier`            |
| SQL                                 | —              | `sqlfmt`              |
| XML                                 | —              | `xmllint`             |
| YAML                                | —              | `yamllint`            |

> [!NOTE]
>
> **Monorepo TypeScript:** `ts_ls` walks up the directory tree to find the topmost directory containing both `tsconfig.json` and `node_modules` — works correctly in monorepos without per-project config.

## Terminal

### Kitty

Config at `kitty/kitty.conf`. Kitty is the primary terminal — configured for a clean, distraction-free experience with the full Catppuccin Frappé color scheme.

| Setting     | Value                                    |
| ----------- | ---------------------------------------- |
| Font        | `JetBrainsMono Nerd Font Mono`, 13pt     |
| Theme       | Catppuccin Frappé (`themes/frappe.conf`) |
| Window size | `150c × 50c`                             |
| Cursor      | `block`                                  |
| Option key  | `macos_option_as_alt yes`                |

> [!TIP]
>
> **Switching themes:** All four Catppuccin flavors are in `kitty/themes/` — change the `include` line to `latte.conf`, `macchiato.conf`, or `mocha.conf` to switch.

### Tmux

Config at `configs/.tmux.conf` (symlinked to `~/.tmux.conf`). Uses [TPM](https://github.com/tmux-plugins/tpm) for plugin management with Catppuccin-matching status bar colors.

| Setting           | Value                                           |
| ----------------- | ----------------------------------------------- |
| Prefix            | `C-a`                                           |
| Mouse             | Enabled                                         |
| History limit     | `10000`                                         |
| Pane navigation   | `prefix + h/j/k/l` (vim-style)                  |
| Window navigation | `prefix + i/u` (next/prev), `prefix + p` (last) |

| Plugin           | Purpose                                   |
| ---------------- | ----------------------------------------- |
| `tmux-resurrect` | Save and restore sessions across restarts |
| `tmux-yank`      | Copy to system clipboard from tmux        |

## Git

| Topic               | Description                                                                                                                                                                                          |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Multi Account Setup | Personal and work profiles with separate SSH keys using `includeIf` and SSH host aliases — [blog post](https://santhoshsiva.dev/blog/the-ultimate-guide-to-managing-multiple-git-accounts-ssh-keys/) |
| Gitsy               | Terminal UI for Git — log, diff, branch, and stash views — [gitsy.santhoshsiva.dev](https://gitsy.santhoshsiva.dev/?section=overview)                                                                |

## Utility Scripts

All scripts in `bin/` are on PATH and share a common utility library at `bin/utils.sh`.

| Script                    | Category | Description                                    |
| ------------------------- | -------- | ---------------------------------------------- |
| `wireless-adb <ip>`       | Android  | Connect to a device over WiFi                  |
| `adb-install <apk>`       | Android  | Install APK to connected device                |
| `adb-reverse <port>`      | Android  | Reverse a port (e.g. Metro bundler)            |
| `adb-uninstall <package>` | Android  | Uninstall a package by name                    |
| `kill-port <port>`        | Dev      | Kill the process listening on a given port     |
| `setup-ssh-agent`         | Dev      | Load SSH key into the running agent            |
| `pwdc`                    | Dev      | Print current working directory (clean output) |
| `reinstall-claude`        | Dev      | Reinstall Claude Code CLI tool                 |
| `reinstall-gitsy`         | Dev      | Reinstall the gitsy CLI tool                   |

## Assets

The `assets/` directory contains static resources:

| Asset                      | Description                                     |
| -------------------------- | ----------------------------------------------- |
| `screenshot.png`           | Environment screenshot for README               |
| `catppuccin/`              | Catppuccin syntax highlight theme files for Zsh |
| `JetBrainsMonoPatched.zip` | Patched JetBrainsMono with Nerd Font glyphs     |

## License

This project is licensed under the MIT License.

## About

**Author:** [Santhosh Siva](https://santhoshsiva.dev)
**GitHub:** [github.com/san-siva](https://github.com/san-siva)
