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
