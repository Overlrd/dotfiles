-- init.lua
-- Initialize configuration
local opt = vim.opt
local g = vim.g
local map = vim.keymap.set

--[[ Core Settings ]]
-- Leader keys
g.mapleader = " "
g.maplocalleader = " "

-- Global settings
g.have_nerd_font = true
g.undodir = os.getenv("HOME") .. "/.cache/vim/undodir/"

-- Editor UI
opt.background = "dark"
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.laststatus = 3 -- Global status line
opt.showmode = false -- Mode is shown in statusline
opt.pumheight = 10 -- Limit popup menu height
opt.conceallevel = 2 -- Hide markdown formatting

-- Editor behavior
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.wrap = false
opt.timeoutlen = 300 -- Faster key sequence completion
opt.updatetime = 250 -- Faster CursorHold events

-- Slight typing delay settings
opt.ttimeoutlen = 10 -- Very short time to wait for key code sequences
opt.timeout = true
opt.ttyfast = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- File handling
opt.swapfile = false
opt.backup = false -- Modern systems don't need this
opt.writebackup = false
opt.undofile = true
opt.undodir = g.undodir
opt.autowrite = true -- Auto save before commands like :next and :make

-- Better buffer management
opt.hidden = true -- Allow hidden buffers
opt.splitright = true -- Split windows right/below by default
opt.splitbelow = true

--[[ Keymaps ]]
-- File operations
map("n", "<Leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<Leader>q", ":q<CR>", { desc = "Quit file" })

-- Navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })

map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Window management
map("n", "<leader>v", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>h", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Quick fixes
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current buffer" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

--[[ Autocommands ]]
local function create_autocmd(event, opts)
	vim.api.nvim_create_autocmd(event, opts)
end

-- Highlight on yank
create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Spell checking for specific files
create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

-- Return to last edit position
create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto-resize splits when Vim is resized
create_autocmd("VimResized", {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

--[[ Plugin Management ]]
-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Initialize plugins
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "lsp" },
	},
	install = { colorscheme = { "default" } },
	checker = { enabled = false },
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
