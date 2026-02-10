-- Large file handling - runs before any plugins load
local Module = {}

local large_file = require 'utils.large-file-check'

-- Mark large files early to prevent plugins from attaching
vim.api.nvim_create_autocmd('BufReadPre', {
  group = vim.api.nvim_create_augroup('LargeFileDetection', { clear = true }),
  callback = function(args)
    local filepath = vim.api.nvim_buf_get_name(args.buf)
    if filepath == '' then
      return
    end

    local is_large, size = large_file.is_large_file(filepath)
    if is_large then
      -- Mark buffer as large file (used by LSP/plugins to skip attachment)
      vim.b[args.buf].large_file = true
      vim.b[args.buf].large_file_size = size
    end
  end,
})

-- Disable features AFTER file is loaded into buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('LargeFileSettings', { clear = true }),
  callback = function(args)
    if vim.b[args.buf].large_file then
      local bufnr = args.buf
      local size = vim.b[args.buf].large_file_size

      -- Disable all heavy features
      vim.bo[bufnr].swapfile = false
      vim.bo[bufnr].undofile = false
      vim.bo[bufnr].undolevels = -1

      -- Aggressively disable syntax
      vim.bo[bufnr].syntax = 'off'
      vim.cmd 'syntax off'
      vim.cmd 'syntax clear'

      -- Limit syntax highlighting column
      vim.bo[bufnr].synmaxcol = 0

      -- Disable treesitter immediately
      vim.schedule(function()
        pcall(vim.cmd, 'TSBufDisable highlight')
        pcall(vim.cmd, 'TSBufDisable indent')
        pcall(vim.cmd, 'TSBufDisable incremental_selection')
      end)

      -- Disable matchparen (bracket matching)
      vim.g.loaded_matchparen = 1

      vim.notify(string.format('Large file (%s). Features disabled for performance.', large_file.format_size(size)), vim.log.levels.WARN)
    end
  end,
})

-- Set window options for large files when buffer enters a window
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('LargeFileWindowSettings', { clear = true }),
  callback = function(args)
    if vim.b[args.buf].large_file then
      -- Disable folding
      vim.wo.foldenable = false
      vim.wo.foldmethod = 'manual'

      -- Enable wrapping for long lines (minified files)
      vim.wo.wrap = true
      vim.wo.linebreak = true

      -- Disable search highlighting
      vim.wo.cursorline = false
      vim.wo.cursorcolumn = false

      -- Disable spell checking
      vim.wo.spell = false
    end
  end,
})

-- Prevent treesitter from loading
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('LargeFileTreesitter', { clear = true }),
  callback = function(args)
    if vim.b[args.buf].large_file then
      vim.schedule(function()
        pcall(vim.cmd, 'TSBufDisable highlight')
        pcall(vim.cmd, 'TSBufDisable indent')
        pcall(vim.cmd, 'TSBufDisable incremental_selection')
      end)
    end
  end,
})

return Module
