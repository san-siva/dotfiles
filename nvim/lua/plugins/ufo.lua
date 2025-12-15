local ufo_ok, ufo = pcall(require, 'ufo')
if not ufo_ok then
  vim.notify 'Problems with ufo'
  return
end

-- ufo requires a special setup
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

ufo.setup()

vim.keymap.set('n', '<leader>cJ', ufo.openAllFolds)
vim.keymap.set('n', '<leader>cK', ufo.closeAllFolds)

vim.keymap.set('n', '<leader>cj', 'zo', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ck', 'zc', { noremap = true, silent = true })
