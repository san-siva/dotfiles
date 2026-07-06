local minuet_ok, minuet = pcall(require, 'minuet')
if not minuet_ok then
  vim.notify('Problem with minuet: ' .. minuet)
  return
end

minuet.setup {
  -- Local model served by Ollama via its OpenAI-compatible FIM endpoint.
  provider = 'openai_fim_compatible',
  n_completions = 1,
  context_window = 512,
  provider_options = {
    openai_fim_compatible = {
      -- Ollama needs no key; point at any always-present env var to satisfy the check.
      api_key = 'TERM',
      name = 'Ollama',
      end_point = 'http://localhost:11434/v1/completions',
      model = 'qwen2.5-coder:1.5b',
      optional = {
        max_tokens = 256,
        top_p = 0.9,
      },
    },
  },
  -- Inline suggestions, mirroring copilot's keymap so accept stays <C-o>.
  virtualtext = {
    auto_trigger_ft = { '*' },
    keymap = {
      accept = '<C-o>',
      accept_line = '<C-u>',
      next = '<C-t>',
      dismiss = '<C-r>',
    },
  },
}
