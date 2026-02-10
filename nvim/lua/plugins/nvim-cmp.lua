local status, cmp = pcall(require, 'cmp')
if not status then
  vim.notify 'Problems with nvim-cmp'
  return
end

local luasnip_status, luasnip = pcall(require, 'luasnip')
if not luasnip_status then
  vim.notify 'Problems with luasnip'
  return
end

luasnip.config.setup {}

cmp.setup {
  enabled = function()
    -- Disable in Telescope prompt
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    if buftype == 'prompt' then
      return false
    end

    -- Disable in Telescope filetype
    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
    if filetype == 'TelescopePrompt' then
      return false
    end

    -- Disable completion in large files
    local large_file = require('utils.large-file-check')
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath ~= '' then
      local is_large = large_file.is_large_file(filepath)
      if is_large then
        return false
      end
    end
    return true
  end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = { completeopt = 'menu,menuone,noinsert' },
  mapping = cmp.mapping.preset.insert {
    ['<C-h>'] = cmp.mapping.close(),
    ['<C-l>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }
      else
        fallback()
      end
    end, { 'i' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i' }),
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i' }),
    ['<C-space>'] = cmp.mapping.complete(),
  },
  sources = {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    {
      name = 'look',
      keyword_length = 2,
      option = {
        convert_case = true,
        loud = true,
      },
    },
  },
}
