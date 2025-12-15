-- NOTE: ESC / C-c
vim.keymap.set('n', '<C-c>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('v', '<C-c>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('', '<Esc>', '<C-c>', { noremap = true, silent = true })

-- NOTE: Increment Decrement
vim.keymap.set('n', '<C-u>', '<C-a>', { noremap = true, silent = true })
vim.keymap.set('v', '<C-u>', '<C-a>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-c>', '<C-]><Esc>', { noremap = true, silent = true })

-- NOTE: Search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: Tabs
vim.keymap.set('n', '<leader>tl', ':tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>th', ':tabprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tL', ':tabnew<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tH', ':tabclose<CR>', { noremap = true, silent = true })

-- NOTE: Buffers
vim.keymap.set('n', '<leader>bb', ':b#<CR>', { noremap = true, silent = true })

-- NOTE: Relative Numbers
vim.keymap.set('n', '<leader>N', ':set relativenumber<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', ':set norelativenumber<CR>', { noremap = true, silent = true })

-- NOTE: Sourcing config
vim.keymap.set('n', '<leader>S', ':source $MYVIMRC<CR>', { noremap = true, silent = false })

-- NOTE: Marks
vim.keymap.set('n', '<leader>M', ':delm! | delm A-Z0-9<CR>', { noremap = true, silent = false, desc = 'Delete all marks' })

-- NOTE: File name
local function copy_current_file_path(is_absolute)
  local path = is_absolute and vim.fn.expand '%:p' or vim.fn.expand '%:.'
  vim.fn.setreg('+', path)

  if is_absolute then
    vim.notify('Copied ' .. path)
    return
  end

  local line_number = vim.fn.line '.'
  path = path .. ':' .. line_number

  vim.fn.setreg('+', path)
  vim.notify('Copied ' .. path)
end

vim.keymap.set('n', '<leader>p', copy_current_file_path, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>P', function()
  copy_current_file_path(true)
end, { noremap = true, silent = true })

-- Copy line number
vim.keymap.set('n', '<leader>l', function()
  local line_number = vim.fn.line '.'
  vim.fn.setreg('+', line_number)
end, { noremap = true, silent = true })

-- NOTE: Diagnostic keymaps
vim.keymap.set('n', '[e', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', ']e', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float(0, {
    format = function(diagnostic)
      -- Show the source (e.g. tsserver, eslint) before the message
      return string.format('[%s] %s', diagnostic.source or '?', diagnostic.message)
    end,
  })
end, { desc = 'Show diagnostic [E]rror messages with source' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- NOTE: Tab navigation by number
local function intialise_tab_keybindings()
  for tab_number = 1, 9 do
    vim.keymap.set('n', '<leader>' .. tab_number, tab_number .. 'gt', { noremap = true, silent = true })
  end
end

intialise_tab_keybindings()
