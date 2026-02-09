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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- Skip LSP for large files (> 1MB)
    local fname = vim.api.nvim_buf_get_name(event.buf)
    local stat = vim.loop.fs_stat(fname)
    if stat and stat.size > 1024 * 1024 then
      vim.schedule(function()
        vim.lsp.buf_detach_client(event.buf, event.data.client_id)
        vim.notify('LSP disabled for large file: ' .. vim.fn.fnamemodify(fname, ':t'), vim.log.levels.WARN)
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
    -- Smart root_dir for monorepos: prefer package-level tsconfig
    root_dir = function(fname)
      -- First, try to find a package-specific tsconfig (closest to the file)
      local package_tsconfig = lspconfig_util.root_pattern(
        'tsconfig.src.json',
        'tsconfig.json',
        'jsconfig.json'
      )(fname)

      if package_tsconfig then
        return package_tsconfig
      end

      -- Fallback to finding by package.json or git root
      return lspconfig_util.root_pattern('package.json', '.git')(fname)
    end,
    single_file_support = false,
    -- Filter out moduleResolution errors (TS2307 for packages with exports)
    handlers = {
      ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        if result.diagnostics then
          -- Filter out Cannot find module errors for packages with proper exports
          result.diagnostics = vim.tbl_filter(function(diagnostic)
            if diagnostic.code == 2307 then
              local message = diagnostic.message or ''
              -- Ignore if it mentions "but this result could not be resolved under your current 'moduleResolution' setting"
              if message:match('moduleResolution.*setting') then
                return false
              end
            end
            return true
          end, result.diagnostics)
        end
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
      end,
    },
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

mason_lspconfig.setup {
  ensure_installed = { 'gopls', 'basedpyright', 'eslint', 'ts_ls', 'lua_ls', 'bashls', 'tailwindcss' },
  automatic_installation = true,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      lspconfig[server_name].setup(server)
    end,
  },
}
