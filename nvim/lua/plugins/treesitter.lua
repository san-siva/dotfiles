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
    select = {
      enable = false,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        -- ['aa'] = '@parameter.outer',
        -- ['ia'] = '@parameter.inner',
        -- ['cl'] = '@function.outer',
        -- ['ci'] = '@function.inner',
        -- ['ac'] = '@class.outer',
        -- ['ic'] = '@class.inner',
      },
    },
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
    swap = {
      enable = false,
      -- swap_next = {
      --   ['<leader>a'] = '@parameter.inner',
      -- },
      -- swap_previous = {
      --   ['<leader>A'] = '@parameter.inner',
      -- },
    },
  },
}

treesitter.setup(config)
