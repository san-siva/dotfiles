local module = {}

function module.setup()
  local config_files = {
    'prettier.config.js',
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.js',
  }

  local cwd = vim.fn.getcwd()
  local config_path

  for _, filename in ipairs(config_files) do
    local path = cwd .. '/' .. filename
    if vim.fn.filereadable(path) == 1 then
      config_path = path
      break
    end
  end

  local tabwidth

  if config_path then
    local lines = vim.fn.readfile(config_path)
    for _, line in ipairs(lines) do
      line = vim.trim(line)
      local value = line:match [["tabWidth"%s*:%s*(%d+)]] or line:match [[tabWidth%s*:%s*(%d+)]]
      if value then
        tabwidth = tonumber(value)
        break
      end
    end
  end

  if tabwidth == 4 then
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end
end

return module
