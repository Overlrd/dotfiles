return {
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'hrsh7th/cmp-nvim-lsp' },
        config = function()
            -- Setup key mappings when LSP attaches to a buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(event)
                    local opts = { buffer = event.buf }
                    
                    -- Core LSP navigation mappings
                    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
                    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    
                    -- Code actions and modifications
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    
                    -- Symbol navigation
                    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, opts)
                    
                    -- Reference highlighting
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method('textDocument/documentHighlight') then
                        local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = true })
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            group = group,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            group = group,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP server configurations
            local capabilities = vim.tbl_deep_extend(
                'force',
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- Server specific settings
            local servers = {
                ruff = {
                    init_options = {
                        settings = { logLevel = 'debug' }
                    }
                },
                basedpyright = {
                    settings = {
                        basedpyright = {
                            disableOrganizeImports = true,
                            typeCheckingMode = "basic"
                        }
                    }
                }
            }

            -- Setup servers
            for server, config in pairs(servers) do
                require('lspconfig')[server].setup(vim.tbl_deep_extend(
                    'force',
                    { capabilities = capabilities },
                    config
                ))
            end
        end
    }
}
