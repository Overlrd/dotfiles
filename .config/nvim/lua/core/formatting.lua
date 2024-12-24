-- lua/core/formatting.lua
local M = {}

-- Enhanced buffer formatting with better cursor position handling
local function format_buffer()
    -- Store the view state
    local view = vim.fn.winsaveview()
    local cursor = vim.api.nvim_win_get_cursor(0)

    -- Format the entire buffer while preserving indent
    vim.api.nvim_command('normal! ggVG')
    vim.api.nvim_command('normal! ==')

    -- Restore the view state
    vim.fn.winrestview(view)
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
end

-- More granular formatting function
local function format_current_buffer()
    local filetype = vim.bo.filetype

    -- Check if we have LSP formatting capability
    local has_lsp = false
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if client.server_capabilities.documentFormattingProvider then
            has_lsp = true
            break
        end
    end

    if has_lsp then
        vim.lsp.buf.format({ async = false })
    else
        -- Apply format based on filetype
        if filetype == 'lua' then
            format_buffer()
        else
            -- Default formatting for other filetypes
            format_buffer()
        end
    end
end

function M.setup()
    local format_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        callback = format_current_buffer
    })

    -- Add keymapping for manual formatting
    vim.keymap.set('n', '<leader>fm', format_current_buffer, { desc = 'Format current buffer' })
end

return M
