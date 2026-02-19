-- ============================================================================
-- LSP Configuration
-- ============================================================================

-- Load required modules
local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
  vim.notify 'Problem with mason'
  return
end

local status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok then
  vim.notify 'Problem with mason-lspconfig'
  return
end

local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status_ok then
  vim.notify 'Problems with lspconfig'
  return
end

local lspconfig_util_ok, lspconfig_util = pcall(require, 'lspconfig.util')
if not lspconfig_util_ok then
  vim.notify 'Problems with lspconfig.util'
  return
end

local large_file = require 'utils.large-file-check'

-- ============================================================================
-- Helper Functions
-- ============================================================================

--- Convert buffer number to file path if needed
---@param fname string|number File path or buffer number
---@return string|nil File path or nil if invalid
local function normalize_filename(fname)
  if type(fname) == 'number' then
    fname = vim.api.nvim_buf_get_name(fname)
  end

  if not fname or fname == '' then
    return nil
  end

  return fname
end

--- Find monorepo root by walking up directory tree
--- Looks for topmost directory with both tsconfig.json and node_modules
---@param fname string File path
---@return string|nil Monorepo root path or nil
local function find_monorepo_root(fname)
  local current = lspconfig_util.path.dirname(fname)
  local found_root = nil
  local max_depth = 50
  local depth = 0

  while current and current ~= '/' and depth < max_depth do
    local tsconfig_path = current .. '/tsconfig.json'
    local node_modules_path = current .. '/node_modules'

    local has_tsconfig = vim.loop.fs_stat(tsconfig_path)
    local has_node_modules = vim.loop.fs_stat(node_modules_path)

    -- If we find both, save it and keep going up to find the topmost one
    if has_tsconfig and has_node_modules then
      found_root = current
    end

    current = lspconfig_util.path.dirname(current)
    depth = depth + 1
  end

  return found_root
end

--- Create a root_dir function for ts_ls that finds monorepo root
---@return function root_dir function
local function create_ts_ls_root_dir()
  return function(fname)
    fname = normalize_filename(fname)
    if not fname then
      return nil
    end

    -- Try to find monorepo root first
    local monorepo_root = find_monorepo_root(fname)
    if monorepo_root then
      return monorepo_root
    end

    -- Fall back to standard pattern
    return lspconfig_util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(fname)
  end
end

--- Wrap a root_dir function to check for large files
---@param original_root_dir function|nil Original root_dir function
---@param server_name string Server name for fallback
---@return function Wrapped root_dir function
local function wrap_root_dir_for_large_files(original_root_dir, server_name)
  return function(fname, ...)
    fname = normalize_filename(fname)
    if not fname then
      return nil
    end

    -- Check if file is large
    local is_large = large_file.is_large_file(fname)
    if is_large then
      return nil
    end

    -- Use original root_dir if provided
    if original_root_dir then
      return original_root_dir(fname, ...)
    end

    -- Fallback to lspconfig default
    local default_config = lspconfig[server_name].document_config.default_config
    if default_config and default_config.root_dir then
      return default_config.root_dir(fname, ...)
    end

    return nil
  end
end

--- Wrap an on_attach function to check for large files
---@param original_on_attach function|nil Original on_attach function
---@return function Wrapped on_attach function
local function wrap_on_attach_for_large_files(original_on_attach)
  return function(client, bufnr)
    -- Check if buffer is marked as large file
    if vim.b[bufnr].large_file then
      -- Detach immediately
      vim.schedule(function()
        vim.lsp.buf_detach_client(bufnr, client.id)
      end)
      return false
    end

    -- Call original on_attach if it exists
    if original_on_attach then
      original_on_attach(client, bufnr)
    end
  end
end

-- ============================================================================
-- Autocommands for Large Files
-- ============================================================================

-- Mark large files early to prevent LSP from attaching
vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileType' }, {
  group = vim.api.nvim_create_augroup('DisableLspForLargeFiles', { clear = true }),
  callback = function(args)
    local filepath = vim.api.nvim_buf_get_name(args.buf)
    if filepath == '' then
      return
    end

    local is_large, size = large_file.is_large_file(filepath)
    if is_large then
      vim.b[args.buf].large_file = true
    end
  end,
})

-- Detach LSP from large files and setup keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- Skip LSP for large files
    if vim.b[event.buf].large_file then
      vim.schedule(function()
        vim.lsp.buf_detach_client(event.buf, event.data.client_id)
      end)
      return
    end

    -- Setup LSP keymaps
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('<leader>fr', vim.lsp.buf.references, '[G]oto [R]eferences')
    map('<leader>fi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Setup document highlighting
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

-- ============================================================================
-- Diagnostic Configuration
-- ============================================================================

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
    },
  },
  virtual_text = {
    prefix = '●',
    spacing = 4,
  },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = true,
  },
}

-- Toggle virtual text on/off
vim.keymap.set('n', '<leader>dv', function()
  local config = vim.diagnostic.config()
  if config.virtual_text then
    vim.diagnostic.config { virtual_text = false }
    vim.notify('Virtual text disabled', vim.log.levels.INFO)
  else
    vim.diagnostic.config { virtual_text = { prefix = '●', spacing = 4 } }
    vim.notify('Virtual text enabled', vim.log.levels.INFO)
  end
end, { desc = '[D]iagnostic [V]irtual text toggle' })

-- ============================================================================
-- LSP Capabilities
-- ============================================================================

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- ============================================================================
-- Server Configurations
-- ============================================================================

local servers = {
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          assign = true,
          atomic = true,
          bools = true,
          composites = true,
          copylocks = true,
          deepequalerrors = true,
          embed = true,
          errorsas = true,
          fieldalignment = true,
          httpresponse = true,
          ifaceassert = true,
          loopclosure = true,
          lostcancel = true,
          nilfunc = true,
          nilness = true,
          nonewvars = true,
          printf = true,
          shadow = true,
          shift = true,
          simplifycompositelit = true,
          simplifyrange = true,
          simplifyslice = true,
          sortslice = true,
          stdmethods = true,
          stringintconv = true,
          structtag = true,
          testinggoroutine = true,
          tests = true,
          timeformat = true,
          unmarshal = true,
          unreachable = true,
          unsafeptr = true,
          unusedresult = true,
          unusedvariable = true,
          unusedwrite = true,
          useany = true,
          staticcheck = true,
        },
      },
    },
  },

  basedpyright = {},

  eslint = {
    command = { 'eslint', '--stdin' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.jsx',
    },
    settings = {
      nodePath = '',
      args = { '--max-warnings=0', '--fix' },
      useFlatConfig = true,
      experimental = {
        useFlatConfig = false,
      },
      workingDirectory = { mode = 'auto' },
    },
    root_dir = lspconfig_util.root_pattern(
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      'eslint.config.ts',
      '.eslintrc.js',
      '.eslintrc.json',
      'package.json',
      '.git'
    ),
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
    end,
  },

  ts_ls = {
    root_dir = create_ts_ls_root_dir(),
    single_file_support = false,
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      tsserver = {
        experimental = {
          enableProjectDiagnostics = true,
        },
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
          importModuleSpecifierPreference = 'non-relative',
        },
      },
    },
  },

  lua_ls = {},
  bashls = {},

  tailwindcss = {
    filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'typescript', 'javascript' },
  },
}

-- ============================================================================
-- Mason Setup
-- ============================================================================

mason.setup()

mason_lspconfig.setup {
  ensure_installed = { 'gopls', 'basedpyright', 'eslint', 'ts_ls', 'lua_ls', 'bashls', 'tailwindcss' },
  automatic_installation = true,
  handlers = {
    -- Default handler for all servers
    function(server_name)
      local server = servers[server_name] or {}

      -- Add capabilities
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

      -- Wrap on_attach to handle large files
      server.on_attach = wrap_on_attach_for_large_files(server.on_attach)

      -- Wrap root_dir to handle large files
      server.root_dir = wrap_root_dir_for_large_files(server.root_dir, server_name)

      -- Setup the server
      lspconfig[server_name].setup(server)
    end,
  },
}

-- ============================================================================
-- ts_ls Special Configuration
-- ============================================================================
-- ts_ls needs to be configured separately because mason_lspconfig handlers
-- only run during server installation, not on every startup

local function setup_ts_ls()
  local config = servers['ts_ls'] or {}

  -- Add capabilities
  config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

  -- Wrap root_dir to handle large files
  -- Note: config.root_dir already contains the monorepo logic from create_ts_ls_root_dir()
  local original_root_dir = config.root_dir
  config.root_dir = function(fname, ...)
    fname = normalize_filename(fname)
    if not fname then
      return nil
    end

    -- Check if file is large
    local is_large = large_file.is_large_file(fname)
    if is_large then
      return nil
    end

    -- Call the monorepo root_dir function
    if original_root_dir then
      return original_root_dir(fname, ...)
    end

    return lspconfig_util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(fname)
  end

  -- Suppress deprecation warning - lspconfig.setup() works correctly with
  -- custom root_dir functions; the new vim.lsp.config API does not
  local orig_warn = vim.deprecate
  vim.deprecate = function() end
  lspconfig.ts_ls.setup(config)
  vim.deprecate = orig_warn
end

setup_ts_ls()
