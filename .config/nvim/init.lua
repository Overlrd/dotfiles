-- init.lua
require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.formatting').setup()
require('ayu_dark').setup()

-- [[ Setup 'lazy.nvim' plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "core.plugins"},
    },
    install = { colorscheme = { "default" } },
    checker = { enabled = false },
})

require('core.lsp')
