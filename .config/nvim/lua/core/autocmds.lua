-- lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    group = highlight_group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Enable spelling for specific file types
autocmd("FileType", {
    pattern = { "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})
