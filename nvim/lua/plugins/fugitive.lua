local keymap = vim.keymap

keymap.set('n', '<leader>gh', ':diffget //2<CR>', { noremap = true, silent = false })
keymap.set('n', '<leader>gl', ':diffget //3<CR>', { noremap = true, silent = false })
keymap.set('n', '<leader>gs', ':G<CR>', { noremap = true, silent = false })
keymap.set('n', '<leader>gc', ':Git commit<CR>', { noremap = true, silent = false })

local fugitive_status, fugitive = pcall(require, 'fugitive')
if not fugitive_status then
  return
end

fugitive.setup()
