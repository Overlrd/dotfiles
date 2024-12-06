vim.g.undodir = os.getenv("HOME") .. "/.cache/vim/undodir/"
vim.g.have_nerd_font = true

vim.g.formatters = { "stylua", "shfmt" }

-- Core settings
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.clipboard = "unnamedplus" -- System clipboard integration
vim.opt.tabstop = 4 -- Tab size
vim.opt.shiftwidth = 4 -- Indent size
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.wrap = false -- Disable line wrapping
vim.opt.scrolloff = 8 -- Keep context around cursor
vim.opt.termguicolors = true -- Enable true color
vim.opt.ignorecase = true -- Ignore case in search...
vim.opt.smartcase = true -- ...unless uppercase is used
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.swapfile = false -- No Swapfile
vim.opt.undodir = vim.g.undodir -- Undodir
vim.opt.undofile = true
vim.opt.updatetime = 250 -- Faster UI updates
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c-i:block"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic keymaps
vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit file" })

-- Disable arrow keys
for _, mode in ipairs({ "n", "i", "v" }) do
	vim.keymap.set(mode, "<Up>", "<Nop>")
	vim.keymap.set(mode, "<Down>", "<Nop>")
	vim.keymap.set(mode, "<Left>", "<Nop>")
	vim.keymap.set(mode, "<Right>", "<Nop>")
end

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Escape search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
		-- Git Integration
		{ "tpope/vim-fugitive" }, -- Git commands

		{ -- Adds git related signs to the gutter, as well as utilities for managing changes
			"lewis6991/gitsigns.nvim",
			opts = {
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = { "c", "cpp", "lua", "python", "javascript" },
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		{
			"notken12/base46-colors",
			config = function()
				vim.cmd([[ colorscheme ayu_dark]])
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				options = { theme = "ayu_dark" },
			},
		},
		{ -- Autocompletion
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {
						-- `friendly-snippets` contains a variety of premade snippets.
						--    See the README about individual language/framework/plugin snippets:
						--    https://github.com/rafamadriz/friendly-snippets
						-- {
						--     'rafamadriz/friendly-snippets',
						--     config = function()
						--         require('luasnip.loaders.from_vscode').lazy_load()
						--     end,
						-- },
					},
				},
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
			},
			config = function()
				-- See `:help cmp`
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				luasnip.config.setup({})

				cmp.setup({
					completion = { completeopt = "menu,menuone,noinsert" },
					mapping = cmp.mapping.preset.insert({
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping.select_next_item(),
						["<S-Tab>"] = cmp.mapping.select_prev_item(),
						-- Manually trigger a completion from nvim-cmp.
						["<C-Space>"] = cmp.mapping.complete({}),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
						{ name = "buffer" },
					}),
				})
			end,
		},
		{

			"williamboman/mason.nvim",
			cmd = "Mason",
			build = ":MasonUpdate",
			opts_extend = { "ensure_installed" },
			opts = {
				ensure_installed = vim.g.formatters,
			},
			---@param opts MasonSettings | {ensure_installed: string[]}
			config = function(_, opts)
				require("mason").setup(opts)
				local mr = require("mason-registry")
				mr:on("package:install:success", function() end)

				mr.refresh(function()
					for _, tool in ipairs(opts.ensure_installed) do
						local p = mr.get_package(tool)
						if not p:is_installed() then
							p:install()
						end
					end
				end)
			end,
		},
		{
			"p00f/clangd_extensions.nvim",
			lazy = true,
			config = function() end,
			opts = {
				inlay_hints = {
					inline = true,
				},
				ast = {
					--These require codicons (https://github.com/microsoft/vscode-codicons)
					role_icons = {
						type = "",
						declaration = "",
						expression = "",
						specifier = "",
						statement = "",
						["template argument"] = "",
					},
					kind_icons = {
						Compound = "",
						Recovery = "",
						TranslationUnit = "",
						PackExpansion = "",
						TemplateTypeParm = "",
						TemplateTemplateParm = "",
						TemplateParamObject = "",
					},
				},
			},
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"mason.nvim",
				{ "williamboman/mason-lspconfig.nvim", config = function() end },
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "j-hui/fidget.nvim", opts = {} },
				"hrsh7th/cmp-nvim-lsp",
			},
			opts = function()
				local ret = {
					codelens = {
						enabled = false,
					},
					-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
					inlay_hints = {
						enabled = true,
					},
					-- Enable lsp cursor word highlighting
					document_highlight = {
						enabled = true,
					},
					-- add any global capabilities here
					capabilities = {
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					},
					servers = {
						clangd = {
							mason = false,
							keys = {
								{
									"<leader>ch",
									"<cmd>ClangdSwitchSourceHeader<cr>",
									desc = "Switch Source/Header (C/C++)",
								},
							},
							root_dir = function(fname)
								return require("lspconfig.util").root_pattern(
									"Makefile",
									"configure.ac",
									"configure.in",
									"config.h.in",
									"meson.build",
									"meson_options.txt",
									"build.ninja"
								)(fname) or require("lspconfig.util").root_pattern(
									"compile_commands.json",
									"compile_flags.txt"
								)(fname) or require("lspconfig.util").find_git_ancestor(fname)
							end,
							capabilities = {
								offsetEncoding = { "utf-16" },
							},
							cmd = {
								"clangd",
								"--background-index",
								"--clang-tidy",
								"--header-insertion=iwyu",
								"--completion-style=detailed",
								"--function-arg-placeholders",
								"--fallback-style=llvm",
							},
							init_options = {
								usePlaceholders = true,
								completeUnimported = true,
								clangdFileStatus = true,
							},
						},
						lua_ls = {
							-- ---@type LazyKeysSpec[]
							settings = {
								Lua = {
									runtime = {
										-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
										version = "LuaJIT",
									},
									diagnostics = {
										-- Get the language server to recognize the `vim` global
										globals = { "vim" },
									},
									workspace = {
										checkThirdParty = false,
									},
									codeLens = {
										enable = true,
									},
									completion = {
										callSnippet = "Replace",
									},
									doc = {
										privateName = { "^_" },
									},
									hint = {
										enable = true,
										setType = false,
										paramType = true,
										paramName = "Disable",
										semicolon = "Disable",
										arrayIndex = "Disable",
									},
								},
							},
						},
					},
					setup = {
						clangd = function(_, opts)
							local clangd_ext_opts = require("clangd_extensions").opts
							require("clangd_extensions").setup(
								vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
							)
							return false
						end,
					},
				}
				return ret
			end,
			config = function(_, opts)
				-- Change diagnostic symbols in the sign column (gutter)
				if vim.g.have_nerd_font then
					local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
					local diagnostic_signs = {}
					for type, icon in pairs(signs) do
						diagnostic_signs[vim.diagnostic.severity[type]] = icon
					end
					vim.diagnostic.config({ signs = { text = diagnostic_signs } })
				end

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities =
					vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

				require("mason").setup()

				local servers = opts.servers

				local function setup(server)
					local server_opts = vim.tbl_deep_extend("force", {
						capabilities = vim.deepcopy(capabilities),
					}, servers[server] or {})
					if server_opts.enabled == false then
						return
					end

					if opts.setup[server] then
						if opts.setup[server](server, server_opts) then
							return
						end
					elseif opts.setup["*"] then
						if opts.setup["*"](server, server_opts) then
							return
						end
					end
					require("lspconfig")[server].setup(server_opts)
				end

				local ensure_installed = {} ---@type string[]
				for server, server_opts in pairs(servers) do
					if server_opts then
						server_opts = server_opts == true and {} or server_opts
						if server_opts.enabled ~= false then
							-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
							if server_opts.mason == false then
								setup(server)
							else
								ensure_installed[#ensure_installed + 1] = server
							end
						end
					end
				end

				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					ensure_installed = vim.tbl_deep_extend("force", ensure_installed, {}),
					handlers = { setup },
				})
			end,
		},
		{ -- Autoformat
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
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
				},
			},
		},
	},
	install = { colorscheme = { "default" } },
	checker = { enabled = false },
})
