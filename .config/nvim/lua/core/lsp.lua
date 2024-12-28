local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Register key mappings for common LSP actions
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }

    -- Code Action
    buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- Go to Definition
    buf_set_keymap('n', '<Leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

    -- Go to References
    buf_set_keymap('n', '<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

    -- Rename
    buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    -- Hover (show information about symbol)
    buf_set_keymap('n', '<Leader>k', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

    -- Signature Help
    buf_set_keymap('n', '<Leader>s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- Go to Type Definition
    buf_set_keymap('n', '<Leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

    -- Formatting (ensure LSP client supports formatting)
    if client.server_capabilities.document_formatting then
        buf_set_keymap('n', '<Leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap('n', '<Leader>fm', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    end

end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = 'LSP: Disable hover capability from Ruff',
})


return {
    require('lspconfig').ruff.setup {
        on_attach = on_attach,
        trace = 'messages',
        init_options = {
            settings = {
                logLevel = 'debug',
            }
        }
    },
    require('lspconfig').pyright.setup {
        settings = {
            pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    -- Ignore all files for analysis to exclusively use Ruff for linting
                    ignore = { '*' },
                },
            },
        },
    }
}
