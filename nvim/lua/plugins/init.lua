local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  'catgoose/nvim-colorizer.lua',
  { 'numToStr/Comment.nvim', opts = {} },
  'lewis6991/gitsigns.nvim',
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = 'master', -- 0.1.x calls the removed nvim-treesitter ft_to_lang API
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
    },
  },
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>cp',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'octaltree/cmp-look',
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  'tpope/vim-fugitive',
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
  'nvim-lualine/lualine.nvim',
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
      },
      scope = {
        enabled = false,
      },
      whitespace = {
        remove_blankline_trail = true,
      },
    },
  },
  'mfussenegger/nvim-jdtls',
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    -- `master` is archived and does not support Neovim 0.12; `main` needs the tree-sitter CLI
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
  },
  {
    'san-siva/blogkit-md.nvim',
  },
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

require 'plugins.treesitter'
require 'plugins.gitsigns'
require 'plugins.telescope'
require 'plugins.nvim-cmp'
require 'plugins.ufo'
require 'plugins.fidget'
require 'plugins.lspconfig'
require 'plugins.conform'
require 'plugins.tree'
-- require 'plugins.copilot'
require 'plugins.minuet'
require 'plugins.lualine'
require 'plugins.catppuccin'
require 'plugins.fugitive'
require 'plugins.colorizer'
