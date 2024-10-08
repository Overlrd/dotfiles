-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- OPTIONS
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c-i:block"
vim.opt.number = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/vim/undodir"
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.cmd("colorscheme retrobox")

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- KEYMAPS
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Map Ctrl + Page Up to switch to the previous buffer
vim.keymap.set("n", "<C-PageUp>", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-PageDown>", ":bnext<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-p>", ":Lexplore<CR>", { silent = true, desc = "Open file Tree" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("confg-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Map Enter to toggle fold under the cursor in normal mode
vim.api.nvim_set_keymap("n", "<CR>", "za", { noremap = true, silent = true })

-- PLUGINS
require("lazy").setup({
	spec = {
		-- Highlight todo, notes, etc in comments
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = { signs = false },
		},
		{
			"stevearc/dressing.nvim",
			opts = {},
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = true,
		},
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
		{
			"MagicDuck/grug-far.nvim",
			opts = { headerMaxWidth = 80 },
			cmd = "GrugFar",
			keys = {
				{
					"<leader>gf",
					function()
						local grug = require("grug-far")
						local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
						grug.open({
							transient = true,
							prefills = {
								filesFilter = ext and ext ~= "" and "*." .. ext or nil,
							},
						})
					end,
					mode = { "n", "v" },
					desc = "Search and Replace",
				},
			},
		},
		{
			"folke/trouble.nvim",
			cmd = { "Trouble" },
			opts = {
				modes = {
					lsp = {
						win = { position = "right" },
					},
				},
			},
			keys = {
				{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
				{ "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
				{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
				{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
				{
					"<C-PageUp>",
					function()
						if require("trouble").is_open() then
							require("trouble").prev({ skip_groups = true, jump = true })
						else
							local ok, err = pcall(vim.cmd.cprev)
							if not ok then
								vim.notify(err, vim.log.levels.ERROR)
							end
						end
					end,
					desc = "Previous Trouble/Quickfix Item",
				},
				{
					"<C-PageDown>",
					function()
						if require("trouble").is_open() then
							require("trouble").next({ skip_groups = true, jump = true })
						else
							local ok, err = pcall(vim.cmd.cnext)
							if not ok then
								vim.notify(err, vim.log.levels.ERROR)
							end
						end
					end,
					desc = "Next Trouble/Quickfix Item",
				},
			},
		},

		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = true,
			config = function()
				local fzf = require("fzf-lua")

				vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "Fzf Search Buffers" })
				vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Fzf Files" })
				vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "Fzf Search Resume" })
				vim.keymap.set("n", "<leader>sg", fzf.git_files, { desc = "Fzf git_files " })
				vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Fzf Grep word under cursor" })
				vim.keymap.set("n", "<leader>sl", fzf.live_grep, { desc = "Fzf live_grep" })
				vim.keymap.set("n", "<leader>sk", fzf.builtin, { desc = "Fzf builtin commands" })
				vim.keymap.set("n", "<leader>sn", function()
					fzf.files({ cwd = vim.fn.stdpath("config") })
				end, { desc = "[S]earch [N]eovim files" })
			end,
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local harpoon = require("harpoon")

				-- REQUIRED
				harpoon:setup()
				-- REQUIRED

				vim.keymap.set("n", "<leader>a", function()
					harpoon:list():add()
				end)
				vim.keymap.set("n", "<C-e>", function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end)

				vim.keymap.set("n", "<C-u>", function()
					harpoon:list():select(1)
				end)
				vim.keymap.set("n", "<C-i>", function()
					harpoon:list():select(2)
				end)
				vim.keymap.set("n", "<C-o>", function()
					harpoon:list():select(3)
				end)
				vim.keymap.set("n", "<C-p>", function()
					harpoon:list():select(4)
				end)

				-- Toggle previous & next buffers stored within Harpoon list
				vim.keymap.set("n", "<C-S-PageUp>", function()
					harpoon:list():prev()
				end)
				vim.keymap.set("n", "<C-S-PageDown>", function()
					harpoon:list():next()
				end)
			end,
		},
		{ -- Autocompletion
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						-- Build Step is needed for regex support in snippets.
						-- This step is not supported in many windows environments.
						-- Remove the below condition to re-enable on windows.
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {
						-- `friendly-snippets` contains a variety of premade snippets.
						--    See the README about individual language/framework/plugin snippets:
						--    https://github.com/rafamadriz/friendly-snippets
						{
							"rafamadriz/friendly-snippets",
							config = function()
								require("luasnip.loaders.from_vscode").lazy_load()
							end,
						},
					},
				},
				"saadparwaiz1/cmp_luasnip",

				-- Adds other completion capabilities.
				--  nvim-cmp does not ship with all sources by default. They are split
				--  into multiple repos for maintenance purposes.
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
			config = function()
				-- See `:help cmp`
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				luasnip.config.setup({})

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = { completeopt = "menu,menuone,noinsert" },

					-- For an understanding of why these mappings were
					-- chosen, you will need to read `:help ins-completion`
					--
					-- No, but seriously. Please read `:help ins-completion`, it is really good!
					mapping = cmp.mapping.preset.insert({
						-- Select the [n]ext item
						["<C-n>"] = cmp.mapping.select_next_item(),
						-- Select the [p]revious item
						["<C-p>"] = cmp.mapping.select_prev_item(),

						-- Scroll the documentation window [b]ack / [f]orward
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),

						--  This will auto-import if your LSP supports it.
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<S-Tab>"] = cmp.mapping.select_prev_item(),

						-- Manually trigger a completion from nvim-cmp.
						["<C-Space>"] = cmp.mapping.complete({}),

						-- Think of <c-l> as moving to the right of your snippet expansion.
						--  So if you have a snippet that's like:
						--  function $name($args)
						--    $body
						--  end
						--
						-- <c-l> will move you to the right of each of the expansion locations.
						-- <c-h> is similar, except moving you backwards.
						["<C-l>"] = cmp.mapping(function()
							if luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							end
						end, { "i", "s" }),
						["<C-h>"] = cmp.mapping(function()
							if luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							end
						end, { "i", "s" }),

						-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
						--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
					}),
					sources = {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
					},
				})
			end,
		},

		require("more.lsp"),
		{
			-- Autoformat
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt", "goimports" },
					c = { "clang-format" },
					cpp = { "clang-format" },
				},
			},
		},
		require("more.debug"),

		-- colorscheme that will be used when installing plugins.
		install = { colorscheme = { "retrobox" } },
		-- automatically check for plugin updates
		checker = { enabled = false },
		ui = {
			icons = vim.g.have_nerd_font and {} or {
				cmd = "⌘",
				config = "🛠",
				event = "📅",
				ft = "📂",
				init = "⚙",
				keys = "🗝",
				plugin = "🔌",
				runtime = "💻",
				require = "🌙",
				source = "📄",
				start = "🚀",
				task = "📌",
				lazy = "💤 ",
			},
		},
	},
})
