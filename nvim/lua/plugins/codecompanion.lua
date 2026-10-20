local ok, codecompanion = pcall(require, 'codecompanion')
if not ok then
  vim.notify('Problem with codecompanion: ' .. codecompanion)
  return
end

-- Chat/agent only. Inline completion stays with minuet (qwen2.5-coder:1.5b).
codecompanion.setup {
  adapters = {
    http = {
      ollama_qwen = function()
        return require('codecompanion.adapters').extend('ollama', {
          name = 'ollama_qwen',
          schema = {
            model = { default = 'qwen2.5-coder:32b' },
            num_ctx = { default = 16384 },
          },
        })
      end,
    },
  },
  strategies = {
    chat = { adapter = 'ollama_qwen' },
    inline = { adapter = 'ollama_qwen' },
    cmd = { adapter = 'ollama_qwen' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>CodeCompanionActions<CR>', { desc = '[A]I [A]ctions' })
vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>CodeCompanionChat Toggle<CR>', { desc = '[A]I [C]hat toggle' })
vim.keymap.set('v', '<leader>ag', '<cmd>CodeCompanionChat Add<CR>', { desc = '[A]I [G]ive selection to chat' })
