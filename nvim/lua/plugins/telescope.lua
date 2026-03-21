local status, telescope = pcall(require, 'telescope')
if not status then
  vim.notify 'Problems with telescope'
  return
end

local builtin_ok, builtin = pcall(require, 'telescope.builtin')
if not builtin_ok then
  vim.notify 'Problems with telescope'
  return
end

pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'file_browser')
pcall(telescope.load_extension, 'ui-select')

local wildignore = require 'utils.wildignores'

telescope.setup {
  defaults = {
    layout_strategies = 'vertical',
    file_ignore_patterns = wildignore,
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'vertical',
    layout_config = {},
    file_sorter = require('telescope.sorters').get_fuzzy_file,
    use_highlighter = false,
    mappings = {
      i = {
        ['<C-k>'] = 'move_selection_previous',
        ['<C-j>'] = 'move_selection_next',
        ['<C-h>'] = 'preview_scrolling_up',
        ['<C-l>'] = 'preview_scrolling_down',
      },
      n = {},
    },
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display = { 'truncate' },
    winblend = 0,
    border = true,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
    },
  },
  extensions_list = { 'themes', 'terms' },
  pickers = {
    buffers = {
      sort_lastused = true,
    },
  },
}

-- NOTE: Buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[B]uffers' })
vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

-- NOTE: Files
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files {
    no_ignore = false,
    hidden = true,
  }
end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>hff', function()
  builtin.find_files {
    minimum_grep_characters = 3,
    file_ignore_patterns = {},
    no_ignore = true,
    hidden = true,
  }
end, { desc = '[S]earch [A]ll [F]iles' })

-- NOTE: Grep
vim.keymap.set('n', '<leader>fg', function()
  builtin.live_grep {
    minimum_grep_characters = 3,
    no_ignore = true,
    hidden = true,
  }
end, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>hfg', function()
  builtin.live_grep {
    minimum_grep_characters = 3,
    file_ignore_patterns = {},
    no_ignore = true,
    hidden = true,
  }
end, { desc = '[S]earch [A]ll by [G]rep' })

-- NOTE: Diagnostics
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- NOTE: All
vim.keymap.set('n', '<leader>F', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

-- NOTE: Marks
vim.keymap.set('n', '<leader>fm', ':marks<CR>', { desc = '[S]earch [M]arks' })
