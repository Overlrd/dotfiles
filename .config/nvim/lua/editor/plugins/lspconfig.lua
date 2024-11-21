-- List of language servers to install
local servers = {
  -------- LUA ---------
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        diagnostics = {
          globals = {
            'vim',
          },
        },
      },
    },
  },
  stylua = {},

  ------ PYTHON ------
  pyright = {
    capabilities = (function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
      return capabilities
    end)(),
    settings = {
      pyright = {
        disableOrganizeImports = true, -- Using Ruff
      },
      python = {
        analysis = {
          ignore = { '*' }, -- Using Ruff
          -- typeCheckingMode = 'basic',
        },
      },
    },
  },
  ruff = {
    cmd_env = { RUFF_TRACE = 'messages' },
    init_options = {
      settings = {
        logLevel = 'error',
      },
    },

    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
    end,
  },
}

-- LSP Plugins Configuration
return {
  -- Main LSP Configuration (with Mason, LSP config and related tools)
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason Plugin for installing LSP servers
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- LSP status updates
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },
      -- nvim-cmp integration for LSP completion
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- LSP setup function that configures key mappings and highlights for LSP events
      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- Example key mappings
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Highlight references when cursor hovers
        if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Create a new capability for enhanced LSP features
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Ensure Mason installs the necessary tools (like LSP servers, formatters, etc.)
      require('mason').setup()
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      -- Set up LSP servers using mason-lspconfig
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- Merge capabilities and server-specific config
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(vim.tbl_extend('force', { on_attach = on_attach }, server))
          end,
        },
      }
    end,
  },
}
