local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not treesitter_ok then
  return
end

local config = {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'vimdoc',
    'c',
    'cpp',
    'go',
    'lua',
    'python',
    'yaml',
    'rust',
    'typescript',
    'javascript',
    'tsx',
    'help',
    'vim',
    'markdown',
    'markdown_inline',
    'dockerfile',
    'sql',
    'java',
  },
  -- Autoinstall languages that are not installed
  auto_install = false,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --  If you are experiencing weird indenting issues, add the language to
    --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
  ignore_install = { 'help' },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']b'] = '@block.outer',
        [']p'] = '@parameter.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
        [']B'] = '@block.outer',
        [']P'] = '@parameter.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[b'] = '@block.outer',
        ['[p'] = '@parameter.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
        ['[B'] = '@block.outer',
        ['[P'] = '@parameter.outer',
      },
    },
  },
}

treesitter.setup(config)

-- Disable treesitter for large files
local large_file = require('utils.large-file-check')

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufRead' }, {
  group = vim.api.nvim_create_augroup('DisableTreesitterForLargeFiles', { clear = true }),
  callback = function(args)
    local filepath = vim.api.nvim_buf_get_name(args.buf)
    if filepath == '' then
      return
    end

    local is_large, size = large_file.is_large_file(filepath)
    if is_large then
      -- Disable vim's built-in syntax highlighting
      vim.bo[args.buf].syntax = 'off'
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false

      -- Disable treesitter
      vim.schedule(function()
        pcall(vim.cmd, 'TSBufDisable highlight')
        pcall(vim.cmd, 'TSBufDisable indent')
        pcall(vim.cmd, 'TSBufDisable incremental_selection')
      end)
    end
  end,
})
