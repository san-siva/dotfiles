local minuet_ok, minuet = pcall(require, 'minuet')
if not minuet_ok then
  vim.notify('Problem with minuet: ' .. minuet)
  return
end

minuet.setup {
  -- Local model served by Ollama via its OpenAI-compatible FIM endpoint.
  provider = 'openai_fim_compatible',
  -- >1 so <C-t> has alternatives to cycle through (one Ollama request each).
  n_completions = 3,
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
    -- Show minuet's ghost text even when nvim-cmp's popup menu is open;
    -- otherwise it's suppressed almost all the time while typing.
    show_on_completion_menu = true,
    keymap = {
      accept = '<C-o>',
      accept_line = '<C-u>',
      next = '<C-t>',
      dismiss = '<C-r>',
    },
  },
}

-- minuet has no built-in accept_word, so insert the next word of the visible
-- suggestion ourselves. minuet trims a suggestion when the typed text matches
-- its prefix, so the rest of the ghost text stays on screen.
local virtualtext = require 'minuet.virtualtext'

local function current_suggestion_line()
  local mark = vim.api.nvim_buf_get_extmark_by_id(0, virtualtext.ns_id, 1, { details = true })
  local details = mark[3]
  if not (details and details.virt_text) then
    return nil, false
  end
  local line = details.virt_text[1][1]
  local multiline = details.virt_lines ~= nil and #details.virt_lines > 0
  if not multiline then
    -- Drop the "(1/3)" choice annotation appended to single-line suggestions.
    line = line:gsub(' %(%d+/%d+%)$', '')
  end
  return line, multiline
end

local function accept_word()
  local line, multiline = current_suggestion_line()
  if not line then
    return
  end
  -- Suggestion starts with a newline: nothing to take from this line.
  if line == '' then
    if multiline then
      virtualtext.action.accept_line()
    end
    return
  end

  local word = line:match '^%s*[%w_]+' or line:match '^%s*[^%w_%s]+' or line

  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-e>', true, true, true), 'n', true)
  end

  vim.schedule(function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { word })
    vim.api.nvim_win_set_cursor(0, { row, col + #word })
  end)
end

vim.keymap.set('i', '<C-y>', accept_word, { desc = '[minuet.virtualtext] accept suggestion (word)' })
