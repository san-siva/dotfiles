local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter')
if not treesitter_ok then
  return
end

-- Parsers to install. Needs the tree-sitter CLI on PATH (`brew install tree-sitter-cli`).
treesitter.install {
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
  'vim',
  'markdown',
  'markdown_inline',
  'dockerfile',
  'sql',
  'java',
}

local large_file = require('utils.large-file-check')

-- On the `main` branch highlighting and indent are no longer toggled through a setup table;
-- start them per buffer instead, and skip large files so they stay fast.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('StartTreesitter', { clear = true }),
  callback = function(args)
    local filepath = vim.api.nvim_buf_get_name(args.buf)
    if vim.b[args.buf].large_file or (filepath ~= '' and (large_file.is_large_file(filepath))) then
      return
    end

    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang or not pcall(vim.treesitter.start, args.buf, lang) then
      return
    end

    if args.match == 'ruby' then
      -- Ruby relies on vim's regex highlighting for indent rules
      vim.bo[args.buf].syntax = 'ruby'
    else
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Textobject motions (the select/swap/lsp_interop modules are not used)
local textobjects_ok = pcall(function()
  require('nvim-treesitter-textobjects').setup {
    move = { set_jumps = true }, -- whether to set jumps in the jumplist
  }
end)

if textobjects_ok then
  local move = require('nvim-treesitter-textobjects.move')

  local motions = {
    { goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']b'] = '@block.outer', [']p'] = '@parameter.outer' } },
    { goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']B'] = '@block.outer', [']P'] = '@parameter.outer' } },
    { goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[b'] = '@block.outer', ['[p'] = '@parameter.outer' } },
    { goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[B'] = '@block.outer', ['[P'] = '@parameter.outer' } },
  }

  for _, group in ipairs(motions) do
    for action, keymaps in pairs(group) do
      for lhs, query in pairs(keymaps) do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move[action](query, 'textobjects')
        end, { desc = action .. ' ' .. query })
      end
    end
  end
end
