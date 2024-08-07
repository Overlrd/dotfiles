-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lines and mouse
vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c-i:block"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"

-- indenting and formatting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- swap, backup and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- editor ui

-- vim.cmd("colorscheme retrobox")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
-- vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true
