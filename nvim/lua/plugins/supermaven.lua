local supermaven_ok, supermaven = pcall(require, 'supermaven-nvim')
if not supermaven_ok then
  vim.notify('Problem with supermaven: ' .. supermaven)
  return
end

supermaven.setup {
	keymaps = {
		accept_suggestion = '<C-o>',
		clear_suggestion = '<C-r>',
		accept_word = '<C-y>',
	},
	ignore_filetypes = { text = false },
	color = {
		suggestion_color = '#838ba8',
		cterm = 244,
	},
	log_level = 'info', -- set to "off" to disable logging completely
	disable_inline_completion = false, -- disables inline completion for use with cmp
	disable_keymaps = false, -- disables built in keymaps for more manual control
	disable_auto_start = false, -- enable auto-start
}

vim.keymap.set('n', '<leader>ss', ':SupermavenStop<CR>', { desc = '[S]upermaven [S]top' })
vim.keymap.set('n', '<leader>si', ':SupermavenStart<CR>', { desc = '[S]upermaven [S]tart' })

vim.api.nvim_create_user_command('SupermavenRestart', function()
  vim.cmd 'SupermavenStop'
  vim.defer_fn(function()
    vim.cmd 'SupermavenStart'
    vim.print 'Supermaven restarted'
  end, 1000) -- 1 second delay
end, {})

vim.keymap.set('n', '<leader>sr', ':SupermavenRestart<CR>', { desc = '[S]upermaven [R]estart' })
