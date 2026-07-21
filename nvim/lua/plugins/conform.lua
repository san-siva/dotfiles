local status, conform = pcall(require, 'conform')
if not status then
  vim.notify 'Problems with conform'
  return
end

-- Search every build.gradle up to the git root, since the spotless config usually
-- lives in the top-level build.gradle rather than a subproject's own file.
local function uses_non_aosp_spotless_format(dirname)
  -- stop is exclusive of the directory it names, so stop one level above the
  -- git root to make sure the root's own build.gradle still gets searched.
  local git_dir = vim.fs.find('.git', { path = dirname, upward = true })[1]
  local stop_dir = git_dir and vim.fs.dirname(vim.fs.dirname(git_dir))

  local gradle_files = vim.fs.find({ 'build.gradle', 'build.gradle.kts' }, {
    path = dirname,
    upward = true,
    limit = math.huge,
    stop = stop_dir,
  })
  for _, gradle_file in ipairs(gradle_files) do
    local content = table.concat(vim.fn.readfile(gradle_file), '\n')
    if content:match 'googleJavaFormat' and not content:match 'googleJavaFormat%(.*aosp' then
      return true
    end
  end
  return false
end

conform.formatters['google-java-format'] = {
  prepend_args = function(self, ctx)
    if uses_non_aosp_spotless_format(ctx.dirname) then
      return {}
    end
    return { '--aosp' }
  end,
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
    c = { 'clang-format' },
    cpp = { 'clang-format' },
  },
}
