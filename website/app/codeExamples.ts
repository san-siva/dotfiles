// Installation
const cloneRepo = `# Clone directly to ~/.config (XDG base dir)
git clone https://github.com/san-siva/dotfiles ~/.config

# If ~/.config already exists
cd ~/.config
git init
git remote add origin https://github.com/san-siva/dotfiles
git pull origin main`;

const linkDotfiles = `# Symlink dotfiles to your home directory
~/.config/bin/dev/setup/link-dotfiles

# Install global npm/yarn dependencies
~/.config/bin/dev/setup/install-global-deps

# Set up the full environment (runs all setup scripts)
~/.config/bin/dev/setup/setup-environment`;

// Neovim
const nvimFolderStructure = `nvim/
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
    └── java.lua`;

const nvimCoreOptions = `-- Leader key
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation (real tabs, 2-wide)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false  -- use real tabs, not spaces

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- UI
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 10
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true

-- Shell
vim.opt.shell = 'zsh'

-- Spell check
vim.opt.spell = true
vim.opt.spelllang = 'en_us'`;

const nvimKeyBindings = `-- Leader: ','

-- Escape / cancel
vim.keymap.set('n', '<C-c>', '<Esc>')
vim.keymap.set('i', '<C-c>', '<C-]><Esc>')

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Tab management
vim.keymap.set('n', '<leader>tl', ':tabnext<CR>')       -- next tab
vim.keymap.set('n', '<leader>th', ':tabprevious<CR>')   -- prev tab
vim.keymap.set('n', '<leader>tL', ':tabnew<CR>')        -- new tab
vim.keymap.set('n', '<leader>tH', ':tabclose<CR>')      -- close tab
vim.keymap.set('n', '<leader>1', '1gt')                 -- jump to tab 1-9
-- ... <leader>2 through <leader>9

-- Buffers
vim.keymap.set('n', '<leader>bb', ':b#<CR>')            -- alternate buffer

-- File paths (copy to clipboard)
vim.keymap.set('n', '<leader>p', copy_current_file_path)         -- relative path + line
vim.keymap.set('n', '<leader>P', copy_current_file_path_abs)     -- absolute path
vim.keymap.set('n', '<leader>l', copy_line_number)               -- line number

-- Numbers toggle
vim.keymap.set('n', '<leader>N', ':set relativenumber<CR>')
vim.keymap.set('n', '<leader>n', ':set norelativenumber<CR>')

-- Config reload
vim.keymap.set('n', '<leader>S', ':source $MYVIMRC<CR>')

-- Marks
vim.keymap.set('n', '<leader>M', ':delm! | delm A-Z0-9<CR>')

-- Diagnostics
vim.keymap.set('n', '[e', vim.diagnostic.goto_next)
vim.keymap.set('n', ']e', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)      -- float with source
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist)`;

const telescopeBindings = `-- File search
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')

-- Live grep (respects wildignore patterns)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')

-- Open buffers
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>')

-- Diagnostics
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<CR>')`;

const nvimTreeBindings = `-- Toggle file tree
vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>')`;

const gitBindings = `-- Git (via vim-fugitive)
vim.keymap.set('n', '<leader>gs', ':Git status<CR>')
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>')
vim.keymap.set('n', '<leader>gh', ':diffget //2<CR>')   -- keep ours
vim.keymap.set('n', '<leader>gl', ':diffget //3<CR>')   -- keep theirs`;

const supermavenConfig = `require('supermaven-nvim').setup({
  keymaps = {
    accept_suggestion = '<C-o>',   -- accept full suggestion
    accept_word       = '<C-y>',   -- accept single word
    clear_suggestion  = '<C-r>',   -- dismiss suggestion
  },
  ignore_filetypes = { 'bigfile', 'snacks_input', 'snacks_notif' },
  color = {
    suggestion_color = '#ffffff',
    cterm = 244,
  },
})`;

const foldingBindings = `-- Code folding (nvim-ufo)
vim.keymap.set('n', '<leader>cJ', '<cmd>lua require("ufo").openAllFolds()<CR>')   -- open all folds
vim.keymap.set('n', '<leader>cK', '<cmd>lua require("ufo").closeAllFolds()<CR>')  -- close all folds`;

const lspConfig = `-- LSP servers managed by mason.nvim:
-- ts_ls       TypeScript / JavaScript
-- eslint      ESLint diagnostics
-- gopls       Go
-- basedpyright  Python
-- lua_ls      Lua
-- bashls      Bash / Shell
-- tailwindcss TailwindCSS

-- Monorepo-aware root dir for ts_ls
-- Walks up the directory tree to find the topmost
-- directory containing both tsconfig.json and node_modules

-- TypeScript inlay hints (all enabled)
settings = {
  typescript = {
    inlayHints = {
      includeInlayParameterNameHints = 'all',
      includeInlayVariableTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
    },
  },
}`;

const conformConfig = `-- Format on save via conform.nvim
-- Language → formatter mapping:
--
-- JavaScript / TypeScript / JSX / TSX  →  prettier
-- CSS / SCSS / HTML / JSON / Markdown  →  prettier
-- Lua                                  →  stylua
-- Python                               →  isort + black
-- Go                                   →  goimports + gofmt
-- Java                                 →  google-java-format (AOSP style)
-- Shell / Bash                         →  shfmt
-- SQL                                  →  sqlfmt
-- XML                                  →  xmllint
-- YAML                                 →  yamllint

require('conform').setup({
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  -- Format on save is automatically disabled for large files
})`;

const largeFileConfig = `-- Large file threshold: 1MB
-- Force-large patterns: package-lock.json, yarn.lock, *.min.js, *.min.css

-- On BufReadPre: marks file as large (vim.b.large_file = true)
-- On BufReadPost: disables swapfile, undofile, syntax, synmaxcol, treesitter
-- On BufWinEnter: disables folding, cursorline, spell

-- LSP, conform, and telescope all skip large files automatically`;

export const CODE_EXAMPLES = {
	cloneRepo,
	linkDotfiles,
	nvimFolderStructure,
};
