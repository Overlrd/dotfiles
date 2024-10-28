-- Enable line numbers and cursorline
vim.opt.number = true
vim.opt.cursorline = true

-- Set cursor style
vim.opt.guicursor = "n-v-c-i:block"

-- Disable line wrapping
vim.opt.wrap = false

-- System clipboard access
vim.opt.clipboard = "unnamedplus"

-- Tabs and indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Keep 10 lines below the cursor
vim.opt.scrolloff = 10

-- Disable swap file and enable persistent undo
vim.opt.swapfile = false
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undodir"
vim.opt.undofile = true

-- Case-insensitive search unless uppercase is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enhanced search options
vim.opt.incsearch = true
vim.opt.hlsearch = false -- Disables highlight by default
vim.cmd([[ autocmd CmdlineLeave /,\? :set nohlsearch ]]) -- Remove highlight after search is complete
vim.opt.inccommand = "split"

-- Window splitting preferences
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Background transparency
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.cmd([[ highlight SignColumn guibg=NONE ]])

-- Colorscheme
vim.cmd("colorscheme habamax")
