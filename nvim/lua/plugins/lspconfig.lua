
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

-- Prevent LSP from attaching to large files
local large_file = require 'utils.large-file-check'

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

    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

    -- Find references for the word under your cursor.
    map('<leader>fr', vim.lsp.buf.references, '[G]oto [R]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map('<leader>fi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
  severity_sort = true,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local servers = {
  -- clangd = {},
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
  -- rust_analyzer = {},
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
        useFlatConfig = false, -- For ESLint >= 8.57.0
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
    -- For monorepos: prioritize root with both tsconfig.json AND node_modules
    root_dir = function(fname)
      -- Handle new vim.lsp.config API which might pass bufnr as first arg
      if type(fname) == 'number' then
        fname = vim.api.nvim_buf_get_name(fname)
      end


      if not fname or fname == '' then
        return nil
      end

      -- Walk up from the file to find a directory with both tsconfig.json and node_modules
      -- This works for any monorepo structure (packages/, apps/, modules/, etc.)
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
          -- Don't break - keep going up to find the topmost directory with both files
        end

        current = lspconfig_util.path.dirname(current)
        depth = depth + 1
      end

      -- Return the monorepo root if found, otherwise fall back to standard pattern
      return found_root or lspconfig_util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(fname)
    end,
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

mason.setup()


-- Check what servers are already installed
local installed = mason_lspconfig.get_installed_servers()

mason_lspconfig.setup {
  ensure_installed = { 'gopls', 'basedpyright', 'eslint', 'ts_ls', 'lua_ls', 'bashls', 'tailwindcss' },
  automatic_installation = true,
  handlers = {
    function(server_name)

      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

      -- Add on_attach wrapper to prevent LSP on large files
      local original_on_attach = server.on_attach
      server.on_attach = function(client, bufnr)
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

      -- Wrap root_dir to return nil for large files (prevents LSP from starting)
      local original_root_dir = server.root_dir
      server.root_dir = function(fname, ...)
        -- Check if file is large
        local is_large = large_file.is_large_file(fname)
        if is_large then
          return nil
        end

        -- Use original root_dir if provided, otherwise use lspconfig default
        if original_root_dir then
          return original_root_dir(fname, ...)
        else
          local default_config = lspconfig[server_name].document_config.default_config
          if default_config and default_config.root_dir then
            return default_config.root_dir(fname, ...)
          end
        end
      end

      lspconfig[server_name].setup(server)
    end,
  },
}

-- Configure ts_ls directly (handlers only run during installation)
local ts_ls_config = servers['ts_ls'] or {}
ts_ls_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, ts_ls_config.capabilities or {})

-- Wrap root_dir for large files
local original_ts_ls_root_dir = ts_ls_config.root_dir
ts_ls_config.root_dir = function(fname, ...)

  -- Check if file is large
  local is_large = large_file.is_large_file(fname)
  if is_large then
    return nil
  end

  -- Use custom root_dir
  if original_ts_ls_root_dir then
    return original_ts_ls_root_dir(fname, ...)
  else
    return lspconfig_util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')(fname)
  end
end

-- Use new vim.lsp.config API (nvim 0.11+) to avoid deprecation warning
if vim.lsp.config then
  vim.lsp.config('ts_ls', ts_ls_config)
else
  -- Fallback to old API for older Neovim versions
  lspconfig.ts_ls.setup(ts_ls_config)
end
