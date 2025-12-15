local copilot_ok, copilot = pcall(require, 'copilot')
if not copilot_ok then
  vim.notify('Problem with copilot: ' .. copilot)
  return
end

copilot.setup {
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 150,
    keymap = {
      accept = '<C-o>',
      accept_line = '<C-u>',
      accept_word = '<C-y>',
      next = '<C-t>',
      prev = false,
      dismiss = '<C-r>',
    },
  },
  filetypes = {
    text = false,
    ['*'] = true,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
}

vim.keymap.set('n', '<leader>cs', ':Copilot disable<CR>', { desc = '[C]ode [D]isable' })
vim.keymap.set('n', '<leader>ci', ':Copilot enable<CR>', { desc = '[C]ode [E]nable' })

vim.api.nvim_create_user_command('CopilotRestart', function()
  vim.cmd 'Copilot disable'
  vim.defer_fn(function()
    vim.cmd 'Copilot enable'
    vim.print 'Copilot restarted'
  end, 1000) -- 1 second delay
end, {})

vim.keymap.set('n', '<leader>cr', ':CopilotRestart<CR>', { desc = '[C]opilot [R]estart' })
