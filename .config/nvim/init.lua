-- init.lua
local opt = vim.opt
local g = vim.g
local map = vim.keymap.set
g.mapleader = vim.keycode("<space>")

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.background = "dark"

-- Indentation
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undodir"
opt.autowrite = true

-- Behavior
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.timeoutlen = 300
opt.updatetime = 250
opt.clipboard = "unnamedplus"

-- Colorscheme
vim.cmd('colorscheme retrobox')
vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]]

--[[ Key Mappings ]]
-- File operations
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search and center" })
map("n", "N", "Nzzzv", { desc = "Previous search and center" })

-- Buffers
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", ":bd<CR>", { desc = "Close buffer" })

-- Windows
map("n", "<leader>v", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>s", "<C-w>s", { desc = "Split horizontal" })
map("n", "<C-h>", "<C-w>h", { desc = "Move left" })
map("n", "<C-j>", "<C-w>j", { desc = "Move down" })
map("n", "<C-k>", "<C-w>k", { desc = "Move up" })
map("n", "<C-l>", "<C-w>l", { desc = "Move right" })

-- Quick fixes
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear highlights" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Visual mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

--[[ Autocommands ]]
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "txt" },
  command = "setlocal spell spelllang=en_us,fr",
})
