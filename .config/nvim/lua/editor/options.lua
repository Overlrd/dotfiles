-- Declare variables for vim options and global variables
local g = vim.g
local opt = vim.opt
local o = vim.o

-- Global variables
g.have_nerd_font = true

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- General settings
opt.cursorline = true
-- opt.guicursor = "n-v-c-i:block"
opt.number = true
opt.wrap = false
opt.clipboard = "unnamedplus"

-- Tab and indentation settings
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- File and undo settings
opt.swapfile = false
opt.undodir = os.getenv("HOME") .. "/.cache/vim/undodir"
opt.undofile = true

-- Search settings
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

-- UI settings
opt.showmode = false
opt.splitright = true
opt.splitbelow = true
opt.inccommand = "split"
opt.signcolumn = "yes"
opt.termguicolors = true
