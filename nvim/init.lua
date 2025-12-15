-- NOTE: Global settings
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.g.have_nerd_font = true
vim.g.omni_sql_default_compl_type = 'syntax'
vim.g.omni_sql_no_default_maps = 1

vim.opt.timeoutlen = 4000
vim.opt.shortmess = 'I'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- NOTE: Clipboard settings
vim.opt.clipboard = 'unnamedplus'

-- NOTE: Tab settings
vim.opt.tabstop = 2 -- width of tab character
vim.opt.softtabstop = 2 -- finetunes the number of space characters inserted for indentation
vim.opt.shiftwidth = 2 -- whitespace in normal mode, should be equal to tabstop
vim.opt.expandtab = false -- tab is replaced by space
vim.opt.smarttab = false -- width of a tab character
vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- NOTE: Wrapping
vim.opt.wrap = true
vim.opt.linebreak = true

-- NOTE: Save undo history
-- In your init.lua
local function setup_undo_with_hash()
  local undo_dir = vim.fn.expand '~/.nvim-undo'

  -- Create directory if it doesn't exist
  if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, 'p', '0700')
  end

  vim.opt.undodir = undo_dir
  vim.opt.undofile = true

  -- Override undo file creation for long paths using hash
  vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    callback = function()
      local filepath = vim.fn.expand '%:p'

      -- Create a hash of the full path for very long paths
      if string.len(filepath) > 100 then
        local hash = vim.fn.sha256(filepath):sub(1, 16)
        local filename = vim.fn.fnamemodify(filepath, ':t')
        local custom_name = filename .. '_' .. hash
        vim.opt_local.undofile = true
        vim.opt_local.undodir = undo_dir
        -- Set custom undo filename
        local undo_file = undo_dir .. '/' .. custom_name .. '.undo'
        vim.b.undofile_name = undo_file
      end
    end,
  })
end

setup_undo_with_hash()

-- NOTE: Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- NOTE: Leaving extra vertical space for signcolumn
vim.opt.signcolumn = 'yes'

-- NOTE: Timeouts
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Displays which-key popup sooner, Decrease mapped sequence wait time

-- NOTE: Window settings
vim.opt.splitright = true
vim.opt.splitbelow = true

-- NOTE: shell settigns
vim.opt.shell = 'zsh'

-- NOTE: list chars
vim.opt.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- NOTE: Search and substitute
vim.opt.inccommand = 'split'
vim.opt.hlsearch = true

-- NOTE: Cursor
vim.opt.cursorline = false
vim.opt.scrolloff = 10

-- NOTE: Filetype specific settings
vim.opt.spell = true
vim.opt.spelllang = 'en_us'
vim.opt.spellsuggest = 'best,20'
vim.opt.spellcapcheck = ''
vim.opt.spellfile = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'
vim.opt.shortmess:append 'F'

vim.opt.termguicolors = true

local wildignore = require 'utils.wildignores'
vim.opt.wildignore:append(wildignore)

vim.opt.list = true
vim.opt.listchars = {
  tab = '│ ',
  leadmultispace = '│   ',
}

require 'bindings'

if vim.env.NVIM_NPM then
  vim.notify('Plugins disabled', 'warn', { title = 'nvim' })
  return
end

require 'plugins'
