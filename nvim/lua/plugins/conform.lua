local status, conform = pcall(require, 'conform')
if not status then
  vim.notify 'Problems with conform'
  return
end

conform.formatters['google-java-format'] = {
  prepend_args = { '--aosp' },
}

local isYamlLintFileAvailable = vim.fn.filereadable '.yamllint.yaml' == 1

conform.formatters.yamllint = {
  command = 'yamllint',
  args = isYamlLintFileAvailable and {
    '--format',
    'parsable',
    '-c',
    '.yamllint.yaml',
  } or {
    '--format',
    'parsable',
  },
  stdin = true,
}

conform.setup {
  notify_on_error = true,
  formatters_on_save = false,
  -- Disable formatting for large files
  format_on_save = function(bufnr)
    local large_file = require('utils.large-file-check')
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    if filepath ~= '' then
      local is_large = large_file.is_large_file(filepath)
      if is_large then
        return nil
      end
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
  formatters_by_ft = {
    yaml = { 'yamllint' },
    sh = { 'shfmt' },
    lua = { 'stylua' },
    python = { 'isort', 'black' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    go = { 'goimports', 'gofmt' },
    markdown = { 'prettier' },
    html = { 'prettier' },
    java = {
      'google-java-format',
    },
    css = { 'prettier' },
    scss = { 'prettier' },
    sql = { 'sqlfmt' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    xml = { 'xmllint' },
  },
}
