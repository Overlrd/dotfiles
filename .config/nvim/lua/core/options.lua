-- lua/core/options.lua
local opt = vim.opt
local g = vim.g

-- Global Options
g.undodir = os.getenv("HOME") .. "/.cache/vim/undodir/"
g.have_nerd_font = true
g.mapleader = " "
g.maplocalleader = " "

-- General
opt.background = "dark"
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.termguicolors = true

-- UI Elements
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.laststatus = 3
vim.opt.laststatus = 3  -- Global status line
vim.opt.winbar = '%=%m %f'  -- Show buffer name in window bar

-- Editing
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.swapfile = false
opt.undofile = true
opt.undodir = g.undodir
opt.updatetime = 250
