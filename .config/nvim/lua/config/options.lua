-- OPTIONS
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- General settings
vim.opt.cursorline = true
vim.opt.guicursor = 'n-v-c-i:block'
vim.opt.number = true
vim.opt.wrap = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.spell = true

-- Tab and indentation settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- File and undo settings
vim.opt.swapfile = false
vim.opt.undodir = os.getenv 'HOME' .. '/.cache/vim/undodir'
vim.opt.undofile = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- UI settings
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.cmd [[ colorscheme retrobox ]]

vim.g.have_nerd_font = true
