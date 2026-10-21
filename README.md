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

| Path       | Description                                                                                               |
| ---------- | --------------------------------------------------------------------------------------------------------- |
| `nvim/`    | Neovim configuration (init.lua + Lua modules)                                                             |
| `kitty/`   | Kitty terminal — fonts, theme, window settings                                                            |
| `fish/`    | Fish shell — minimal PATH additions                                                                       |
| `configs/` | Home-dir dotfiles, grouped by tool (`zsh/`, `git/`, `ssh/`, `tmux/`, `vim/`, `node/`, `java/`, `agents/`) |
| `bin/`     | Shell utility scripts (`android/`, `setup/`, `tools/`, `common/`, `utils.sh`)                             |
| `git/`     | Global git config and gitignore                                                                           |
| `assets/`  | Screenshots, patched fonts, theme files                                                                   |

> [!TIP]
>
> **XDG compliant:** Cloning to `~/.config` means tools like Neovim, Kitty, Fish, and gh pick up their configs automatically without any manual linking.

## Requirements

| Tool                      | Purpose                                                             |
| ------------------------- | ------------------------------------------------------------------- |
| `neovim 0.10+`            | Editor (required for all nvim features)                             |
| `node 18+ / nvm`          | JavaScript tooling, LSP servers                                     |
| `git`                     | Version control                                                     |
| `kitty`                   | Terminal emulator                                                   |
| `zsh`                     | Primary shell                                                       |
| `brew`                    | macOS package manager — installed by `setup-environment` if missing |
| `JetBrainsMono Nerd Font` | Font (all terminals + Neovim)                                       |

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

The environment bootstrap is split into one script per tool in `bin/setup/`. Run `setup-environment` to run them all in order, or run any script on its own. All of them are safe to re-run.

### setup-environment

The top-level bootstrapper. Runs `setup-homebrew` first (and stops if it fails, since everything else needs brew), then every script below in groups: core (`homebrew`, `bash`, `lua`), languages, terminal tools, editors, agents, personal tools and configs. `main` calls one function per group, so reordering or skipping a group is a one-line change.

```bash
~/.config/bin/setup/setup-environment
```

| Script              | Installs                                                                                                                                                                                                   |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `setup-homebrew`    | Homebrew, `ca-certificates`                                                                                                                                                                                |
| `setup-bash`        | `bash` 5                                                                                                                                                                                                   |
| `setup-lua`         | `lua`, `luarocks`                                                                                                                                                                                          |
| `setup-python`      | `python3`, `sqlfluff`                                                                                                                                                                                      |
| `setup-node`        | `node` (via nvm), `yarn`, Corepack, global npm tools (`jest`, `typescript`, ...), ESLint + configs, Prettier + config                                                                                      |
| `setup-ruby`        | `ruby`                                                                                                                                                                                                     |
| `setup-rust`        | `rust`                                                                                                                                                                                                     |
| `setup-go`          | `go`, `dlv`                                                                                                                                                                                                |
| `setup-java`        | `openjdk`, `openjdk@21`, `ant`, `maven`                                                                                                                                                                    |
| `setup-tmux`        | `tmux` + TPM                                                                                                                                                                                               |
| `setup-kitty`       | `kitty`                                                                                                                                                                                                    |
| `setup-shell`       | `oh-my-zsh`, `powerlevel10k`, `zsh-history-substring-search`, `fish`, `fzf`, `zoxide`, `moreutils`, `tree`, `fastfetch`, `figlet`, `lolcat`, `cmatrix`, `deno`, `mkcert`, `jq`, `yq`, `gh`, `wget`, `calc` |
| `setup-kubectl`     | `kubectl`, `flux`                                                                                                                                                                                          |
| `setup-neovim`      | `neovim`, `ripgrep`, `fd`, `tree-sitter-cli`, formatters, `jdtls`, language providers, `ollama`                                                                                                            |
| `setup-claude`      | Claude Code, `chrome-devtools-mcp`, agent skills                                                                                                                                                           |
| `setup-antigravity` | Antigravity CLI skills and keybindings                                                                                                                                                                     |
| `setup-gitsy`       | `gitsy` (Git workflow utilities)                                                                                                                                                                           |
| `setup-blogkit`     | `blogkit-md` CLI                                                                                                                                                                                           |
| `setup-git`         | git config                                                                                                                                                                                                 |
| `setup-ssh`         | ssh config, and the SSH agent that `.zshrc` sources on startup                                                                                                                                             |

Shared helpers (`brew_install`, `npm_install`, `load_brew`, `load_nvm`) live in `bin/common/` (`brew.sh`, `node.sh`, `fs.sh`, ...).

### Dotfile symlinks

Each setup script links its own config from `~/.config/configs/` using `ln -sfn` (the `link` helper in `bin/common/fs.sh`), so re-running is safe: existing files and symlinks at each target are replaced in place. `setup-git`, `setup-ssh` and `setup-antigravity` only link configs.

| Script              | Source                                                            | Symlinked to                                 |
| ------------------- | ----------------------------------------------------------------- | -------------------------------------------- |
| `setup-tmux`        | `configs/tmux/.tmux.conf`                                         | `~/.tmux.conf`                               |
| `setup-shell`       | `configs/zsh/.p10k.zsh`                                           | `~/.p10k.zsh`                                |
| `setup-neovim`      | `configs/vim/.vimrc`                                              | `~/.vimrc`                                   |
| `setup-node`        | `configs/node/.eslintrc.json`                                     | `~/.eslintrc.json`                           |
| `setup-node`        | `configs/node/.prettierrc.json`                                   | `~/.prettierrc.json`                         |
| `setup-git`         | `configs/git/.gitconfig`, `.gitconfig__wrk`, `.gitignore__global` | `~/`                                         |
| `setup-ssh`         | `configs/ssh/ssh_config`                                          | `~/.ssh/config`                              |
| `setup-java`        | `configs/java/eclipse-java-google-style.xml`, `lombok.jar`        | `~/.local/share/eclipse/`                    |
| `setup-claude`      | `configs/agents/agent-skills`                                     | `~/.claude/skills`                           |
| `setup-claude`      | `$WORK_AGENT_SKILLS_DIR/*`                                        | `configs/agents/agent-skills/<skill>`        |
| `setup-antigravity` | `configs/agents/agent-skills`                                     | `~/.gemini/antigravity-cli/skills`           |
| `setup-antigravity` | `configs/agents/antigravity-keybindings.json`                     | `~/.gemini/antigravity-cli/keybindings.json` |

> [!WARNING]
>
> Existing files and symlinks at the target paths are replaced. A real directory at a target is moved aside to `<target>.bak-<timestamp>` rather than deleted — review and remove these backups once you have checked their contents.

### Create the local zshrc

The setup scripts don't create `~/.zshrc` — it's a machine-local file that holds secrets (see [Shell](#shell)). Create it once so new shells load the tracked config:

```bash
echo 'source ~/.config/configs/zsh/.zshrc' > ~/.zshrc
```

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

## Shell

The Zsh config is split into two layers so the tracked parts stay portable and secrets never touch the repo.

```mermaid
graph LR
  A["~/.zshrc<br/>untracked, machine-local"] -->|sources| B["configs/zsh/.zshrc<br/>tracked"]
  B --> C["main()<br/>prompt, oh-my-zsh, PATH, aliases"]
  A --> D["main_local()<br/>secrets + local setup"]
```

| File                 | Tracked | Responsibility                                                                        |
| -------------------- | ------- | ------------------------------------------------------------------------------------- |
| `~/.zshrc`           | No      | Entry point plus machine-local `setup_*` functions for secrets and tooling            |
| `configs/zsh/.zshrc` | Yes     | Prompt (Catppuccin, Powerlevel10k, oh-my-zsh), PATH, toolchains, keybindings, aliases |

### Machine-local entry point

`~/.zshrc` isn't symlinked. It's a plain file that sources the tracked config, then follows the same pattern — one `setup_*` function per concern and a `main_local()` that calls them — for anything that must stay off GitHub:

```bash
# ~/.zshrc
source ~/.config/configs/zsh/.zshrc

setup_env_vars() {
    # Secrets — not tracked in any repo
    export JIRA_API_TOKEN="..."
    export FIGMA_API_TOKEN="..."
}

setup_local_paths() {
    export PATH="$HOME/.local/some-tool/bin:$PATH"
}

setup_local_aliases() {
    alias work='cd ~/Work'
}

main_local() {
    setup_env_vars
    setup_local_paths
    setup_local_aliases
}

main_local
```

> [!TIP]
>
> **Avoid name clashes:** The tracked config already defines `main` and `setup_aliases`, so local functions use distinct names such as `main_local` and `setup_local_aliases`.

> [!IMPORTANT]
>
> **Keep secrets in `~/.zshrc` only.** Everything under `~/.config` is pushed to a public repository.

### One function per concern

Instead of one long script, `configs/zsh/.zshrc` groups each concern into its own `setup_*` function, and a single `main()` calls them in order. Reordering, disabling, or debugging a step is a one-line change:

```bash
# configs/zsh/.zshrc
main() {
    setup_prompt
    setup_instant_prompt
    setup_oh_my_zsh
    setup_environment_variables
    setup_homebrew_paths
    setup_go_environment
    setup_rust_environment
    setup_ruby_environment
    setup_python_environment
    setup_java_environment
    setup_custom_bins
    setup_node_environment
    setup_shell_integrations
    setup_keybindings
    setup_ssh_agent
    setup_aliases
}

main
```

| Function                      | Responsibility                                                                                    |
| ----------------------------- | ------------------------------------------------------------------------------------------------- |
| `setup_prompt`                | Catppuccin syntax highlighting, Powerlevel10k theme and `.p10k.zsh`                               |
| `setup_instant_prompt`        | Powerlevel10k instant prompt                                                                      |
| `setup_oh_my_zsh`             | oh-my-zsh with the `git` and `zsh-history-substring-search` plugins                               |
| `setup_environment_variables` | `TERM` (left to tmux inside tmux), `EDITOR`, `VISUAL`                                             |
| `setup_homebrew_paths`        | Homebrew `bin` / `sbin` and Rancher Desktop                                                       |
| `setup_go_environment`        | `GOPATH` and `~/go/bin`                                                                           |
| `setup_rust_environment`      | `~/.cargo/bin`                                                                                    |
| `setup_ruby_environment`      | Homebrew Ruby, compiler flags, user gem bin                                                       |
| `setup_python_environment`    | Python user-base `bin`                                                                            |
| `setup_java_environment`      | OpenJDK, Zulu 8, `JAVA_HOME`                                                                      |
| `setup_custom_bins`           | `~/.local/bin`, `~/bin`, and the `bin/` script folders in this repo (`android`, `setup`, `tools`) |
| `setup_node_environment`      | nvm, Yarn global bin, Zscaler CA for Node tooling                                                 |
| `setup_shell_integrations`    | zoxide — runs after PATH is complete                                                              |
| `setup_keybindings`           | `^n` / `^p` completion, `^j` / `^k` history substring search                                      |
| `setup_ssh_agent`             | Loads keys via `bin/setup/setup-ssh`                                                              |
| `setup_aliases`               | `sed` → `gsed`, navigation aliases                                                                |

### Safe PATH handling

PATH is built through two guarded helpers. A directory is only added if it exists, and `typeset -aU path` keeps entries unique, so re-sourcing the file never produces duplicates. The same config works on a machine that's missing some toolchains:

```bash
# configs/zsh/.zshrc
typeset -aU path

prepend_path() {
    if [ -d "$1" ]; then
        path=("$1" $path)
    fi
}

append_path() {
    if [ -d "$1" ]; then
        path=($path "$1")
    fi
}
```

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

Config at `configs/tmux/.tmux.conf` (symlinked to `~/.tmux.conf`). Uses [TPM](https://github.com/tmux-plugins/tpm) for plugin management with Catppuccin-matching status bar colors.

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

## Agent Skills

A shared set of AI agent skills lives in `configs/agents/agent-skills/`. `setup-claude` and `setup-antigravity` symlink the same directory into both Claude Code (`~/.claude/skills`) and Antigravity CLI (`~/.gemini/antigravity-cli/skills`), so one edit updates both agents.

```bash
configs/agents/agent-skills/
├── <skill-name>/
│   ├── SKILL.md       Frontmatter (name, description) + instructions
│   └── references/    Optional supporting docs loaded on demand
└── ...
```

| Skill               | Description                                                                      |
| ------------------- | -------------------------------------------------------------------------------- |
| `add-logs`          | Add log statements in the `SAN_SIVA` logging format                              |
| `bash-scripts`      | Write bash scripts in the gitsy style — sourced utils, `set_flags` parsing, etc. |
| `branch-name`       | Suggest a git branch name for a Jira ticket                                      |
| `commit-and-push`   | Suggest commit messages, pick one, then commit and push                          |
| `commit-message`    | Suggest a Conventional Commits message for the staged changes                    |
| `create-markdown`   | Write markdown following a consistent style guide, including blogkit-md rules    |
| `create-worktree`   | Create a git worktree using `g-wa`                                               |
| `document-progress` | Record task progress into `~/Work/TASKS`                                         |
| `gitsy`             | Perform Git operations through the gitsy CLI                                     |
| `mermaid-wizard`    | Produce syntactically correct Mermaid diagrams for code, architecture, and flows |

### Private skills

Work-specific skills live in a separate private repository, not here. `setup-claude` reads their location from `WORK_AGENT_SKILLS_DIR` — set in the untracked `~/.zshrc` — and symlinks each one into `configs/agents/agent-skills/`, which is gitignored. If the variable is unset, the step is skipped.

```bash
# ~/.zshrc
setup_env_vars() {
    export WORK_AGENT_SKILLS_DIR="$HOME/path/to/private/agent-skills"
}
```

> [!TIP]
>
> **Invoking skills:** User-invocable skills can be run directly as slash commands, e.g. `/commit-and-push`. Agents also pick them up automatically when a request matches the skill's description.

## Utility Scripts

All scripts in `bin/` are on PATH and share a common utility library in `bin/common/`, loaded by sourcing `bin/utils.sh`. The `setup-*` installers in `bin/setup/` are documented under [Installation](#installation).

| Script                              | Category | Description                                            |
| ----------------------------------- | -------- | ------------------------------------------------------ |
| `wireless-adb <ip>`                 | Android  | Connect to a device over WiFi                          |
| `adb-install <apk>`                 | Android  | Install APK to connected device                        |
| `adb-reverse <port>`                | Android  | Reverse a port (e.g. Metro bundler)                    |
| `adb-uninstall <package>`           | Android  | Uninstall a package by name                            |
| `kill-port <port>`                  | Tools    | Kill the process listening on a given port             |
| `pwdc`                              | Tools    | Print current working directory (clean output)         |
| `reinstall-npm-pkg <pkg> [version]` | Tools    |
| `zscalar-fix.sh`                    | Tools    | Trust the Zscaler CA for Node, Bun and OpenSSL tooling | Reinstall/upgrade any global npm package |

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
