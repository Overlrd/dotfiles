-- Neovim 0.12+. Mason installs missing language tools on startup.
-- Editor options.
do
	vim.loader.enable()

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.g.have_nerd_font = false

	vim.o.number = true

	vim.o.mouse = "a"

	vim.o.showmode = false

	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)

	vim.o.breakindent = true

	vim.o.undofile = true

	vim.o.ignorecase = true
	vim.o.smartcase = true

	vim.o.signcolumn = "yes"

	vim.o.updatetime = 250

	vim.o.timeoutlen = 300

	vim.o.splitright = true
	vim.o.splitbelow = true

	vim.o.list = true

	vim.o.inccommand = "split"

	vim.o.cursorline = true

	vim.o.scrolloff = 10

	vim.o.confirm = true
end

-- Basic mappings and diagnostics.
do
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	vim.diagnostic.config({
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },

		virtual_text = true, -- Text shows up at the end of the line
		virtual_lines = false, -- Text shows up underneath the line, with virtual lines

		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})

	vim.keymap.set(
		"n",
		"<leader>q",
		vim.diagnostic.setloclist,
		{ desc = "Open diagnostic [Q]uickfix list" }
	)

	vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.hl.on_yank()
		end,
	})
end

-- Build optional native extensions after installation or updates.
do
	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ""
			local stdout = result.stdout or ""
			local output = stderr ~= "" and stderr or stdout
			if output == "" then
				output = "No output from build command."
			end
			vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
		end
	end

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
				run_build(name, { "make" }, ev.data.path)
				return
			end

			if name == "LuaSnip" then
				if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
					run_build(name, { "make", "install_jsregexp" }, ev.data.path)
				end
				return
			end

			if name == "nvim-treesitter" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
				return
			end
		end,
	})
end

local function gh(repo)
	return "https://github.com/" .. repo
end

-- UI, Git signs and editing helpers.
do
	vim.pack.add({ gh("NMAC427/guess-indent.nvim") })
	require("guess-indent").setup({})

	vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
	local gitsigns = require("gitsigns")
	gitsigns.setup({
		signs = {
			add = { text = "+" }, ---@diagnostic disable-line: missing-fields
			change = { text = "~" }, ---@diagnostic disable-line: missing-fields
			delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
			topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
			changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
		},
		on_attach = function(bufnr)
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange", buf = bufnr })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange", buf = bufnr })

			vim.keymap.set("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git [s]tage hunk", buf = bufnr })
			vim.keymap.set("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git [r]eset hunk", buf = bufnr })
			vim.keymap.set(
				"n",
				"<leader>hs",
				gitsigns.stage_hunk,
				{ desc = "git [s]tage hunk", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>hr",
				gitsigns.reset_hunk,
				{ desc = "git [r]eset hunk", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>hS",
				gitsigns.stage_buffer,
				{ desc = "git [S]tage buffer", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>hR",
				gitsigns.reset_buffer,
				{ desc = "git [R]eset buffer", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>hp",
				gitsigns.preview_hunk,
				{ desc = "git [p]review hunk", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>hi",
				gitsigns.preview_hunk_inline,
				{ desc = "git preview hunk [i]nline", buf = bufnr }
			)
			vim.keymap.set("n", "<leader>hb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "git [b]lame line", buf = bufnr })
			vim.keymap.set(
				"n",
				"<leader>hd",
				gitsigns.diffthis,
				{ desc = "git [d]iff against index", buf = bufnr }
			)
			vim.keymap.set("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, { desc = "git [D]iff against last commit", buf = bufnr })
			vim.keymap.set("n", "<leader>hQ", function()
				gitsigns.setqflist("all")
			end, { desc = "git hunk [Q]uickfix list (all files in repo)", buf = bufnr })
			vim.keymap.set(
				"n",
				"<leader>hq",
				gitsigns.setqflist,
				{ desc = "git hunk [q]uickfix list (all changes in this file)", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>tb",
				gitsigns.toggle_current_line_blame,
				{ desc = "[T]oggle git show [b]lame line", buf = bufnr }
			)
			vim.keymap.set(
				"n",
				"<leader>tw",
				gitsigns.toggle_word_diff,
				{ desc = "[T]oggle git intra-line [w]ord diff", buf = bufnr }
			)
			vim.keymap.set(
				{ "o", "x" },
				"ih",
				gitsigns.select_hunk,
				{ desc = "text object [i]nside [h]unk", buf = bufnr }
			)
		end,
	})

	vim.pack.add({ gh("folke/which-key.nvim") })
	require("which-key").setup({
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } }, -- Enable gitsigns recommended keymaps first
			{ "gr", group = "LSP Actions", mode = { "n" } },
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "Diagnostics" },
		},
	})

	vim.o.background = "dark"
	vim.cmd.colorscheme("default")

	vim.pack.add({ gh("folke/todo-comments.nvim") })
	require("todo-comments").setup({ signs = false })

	vim.pack.add({ gh("nvim-mini/mini.nvim") })

	if vim.g.have_nerd_font then
		require("mini.icons").setup()
		MiniIcons.mock_nvim_web_devicons()
	end

	require("mini.ai").setup({
		mappings = {
			around_next = "aa",
			inside_next = "ii",
		},
		n_lines = 500,
	})

	require("mini.surround").setup()

	local statusline = require("mini.statusline")
	statusline.setup({ use_icons = vim.g.have_nerd_font })

	statusline.section_location = function()
		return "%2l:%-2v"
	end
end

-- Telescope search and navigation.
do
	local telescope_plugins = {
		gh("nvim-lua/plenary.nvim"),
		gh("nvim-telescope/telescope.nvim"),
		gh("nvim-telescope/telescope-ui-select.nvim"),
	}
	if vim.fn.executable("make") == 1 then
		table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
	end

	vim.pack.add(telescope_plugins)

	require("telescope").setup({
		extensions = {
			["ui-select"] = { require("telescope.themes").get_dropdown() },
		},
	})

	pcall(require("telescope").load_extension, "fzf")
	pcall(require("telescope").load_extension, "ui-select")

	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	vim.keymap.set(
		{ "n", "v" },
		"<leader>sw",
		builtin.grep_string,
		{ desc = "[S]earch current [W]ord" }
	)
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	vim.keymap.set(
		"n",
		"<leader>s.",
		builtin.oldfiles,
		{ desc = '[S]earch Recent Files ("." for repeat)' }
	)
	vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
		callback = function(event)
			local buf = event.buf

			vim.keymap.set(
				"n",
				"grr",
				builtin.lsp_references,
				{ buffer = buf, desc = "[G]oto [R]eferences" }
			)

			vim.keymap.set(
				"n",
				"gri",
				builtin.lsp_implementations,
				{ buffer = buf, desc = "[G]oto [I]mplementation" }
			)

			vim.keymap.set(
				"n",
				"grd",
				builtin.lsp_definitions,
				{ buffer = buf, desc = "[G]oto [D]efinition" }
			)

			vim.keymap.set(
				"n",
				"gO",
				builtin.lsp_document_symbols,
				{ buffer = buf, desc = "Open Document Symbols" }
			)

			vim.keymap.set(
				"n",
				"gW",
				builtin.lsp_dynamic_workspace_symbols,
				{ buffer = buf, desc = "Open Workspace Symbols" }
			)

			vim.keymap.set(
				"n",
				"grt",
				builtin.lsp_type_definitions,
				{ buffer = buf, desc = "[G]oto [T]ype Definition" }
			)
		end,
	})

	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config"), follow = true })
	end, { desc = "[S]earch [N]eovim files" })
end

-- Completion is configured before servers advertise their capabilities.
do
	vim.pack.add({
		{ src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") },
		{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
	})
	require("luasnip").setup()
	require("blink.cmp").setup({
		keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
		completion = {
			list = { selection = { preselect = false, auto_insert = false } },
			documentation = { auto_show = true },
		},
		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	})
end

-- Language servers and tool installation.
do
	vim.pack.add({
		gh("neovim/nvim-lspconfig"),
		gh("mason-org/mason.nvim"),
		gh("mason-org/mason-lspconfig.nvim"),
		gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
		gh("j-hui/fidget.nvim"),
	})
	require("mason").setup()
	require("mason-lspconfig").setup({ automatic_enable = false })
	require("fidget").setup()
	vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

	local servers = {
		pyright = {
			settings = {
				pyright = { disableOrganizeImports = true },
				python = { analysis = { typeCheckingMode = "basic" } },
			},
			before_init = function(_, config)
				-- Explicit project settings win over our virtual-environment convenience.
				if config.root_dir and vim.uv.fs_stat(config.root_dir .. "/pyrightconfig.json") then
					return
				end
				local env = vim.env.VIRTUAL_ENV or (config.root_dir and config.root_dir .. "/.venv")
				if env then
					local python = vim.fs.joinpath(
						env,
						vim.fn.has("win32") == 1 and "Scripts/python.exe" or "bin/python"
					)
					if vim.fn.executable(python) == 1 then
						config.settings.python.pythonPath = python
					end
				end
			end,
		},
		ruff = {},
		gopls = {},
		bashls = {},
		dockerls = {},
		docker_compose_language_service = {},
		yamlls = { filetypes = { "yaml", "yaml.gitlab", "yaml.helm-values" } },
		jsonls = {},
		taplo = {},
		lua_ls = {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false },
					format = { enable = false },
				},
			},
		},
	}
	vim.filetype.add({
		filename = {
			["compose.yaml"] = "yaml.docker-compose",
			["compose.yml"] = "yaml.docker-compose",
			["docker-compose.yaml"] = "yaml.docker-compose",
			["docker-compose.yml"] = "yaml.docker-compose",
		},
		pattern = {
			[".*/compose%.[^/]+%.ya?ml"] = "yaml.docker-compose",
			[".*/docker%-compose%.[^/]+%.ya?ml"] = "yaml.docker-compose",
		},
	})
	local tools = vim.tbl_keys(servers)
	vim.list_extend(tools, { "stylua", "goimports", "shfmt", "shellcheck", "prettier" })
	require("mason-tool-installer").setup({ ensure_installed = tools })
	for name, config in pairs(servers) do
		vim.lsp.config(name, config)
		vim.lsp.enable(name)
	end

	local highlights = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end
			if client.name == "ruff" then
				client.server_capabilities.hoverProvider = false
			end
			local function map(key, action, desc)
				vim.keymap.set("n", key, action, { buffer = event.buf, desc = desc })
			end
			map("grD", vim.lsp.buf.declaration, "Go to declaration")
			map("<leader>ci", function()
				vim.lsp.buf.code_action({
					context = { only = { "source.organizeImports" }, diagnostics = {} },
					apply = true,
				})
			end, "Organize imports")
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(
					not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
					{ bufnr = event.buf }
				)
			end, "Toggle inlay hints")
			if client:supports_method("textDocument/documentHighlight", event.buf) then
				-- Multiple servers can attach to the same buffer: register these only once.
				vim.api.nvim_clear_autocmds({ group = highlights, buffer = event.buf })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = highlights,
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = highlights,
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})
	vim.api.nvim_create_autocmd("LspDetach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
		callback = function(event)
			-- Keep highlighting if another capable server remains attached.
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = event.buf })) do
				if
					client.id ~= event.data.client_id
					and client:supports_method("textDocument/documentHighlight", event.buf)
				then
					return
				end
			end
			vim.api.nvim_buf_call(event.buf, vim.lsp.buf.clear_references)
			vim.api.nvim_clear_autocmds({ group = highlights, buffer = event.buf })
		end,
	})
end

-- Format manually with Space f; toggle save formatting with Space tf.
do
	vim.pack.add({ gh("stevearc/conform.nvim") })
	require("conform").setup({
		formatters_by_ft = {
			python = { "ruff_format" },
			go = { "goimports" },
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			yaml = { "prettier" },
			["yaml.docker-compose"] = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			toml = { "taplo" },
		},
		default_format_opts = { lsp_format = "fallback", timeout_ms = 2000 },
		format_on_save = function(buf)
			local enabled = vim.b[buf].format_on_save
			if enabled == nil then
				enabled = vim.tbl_contains({ "python", "go", "lua" }, vim.bo[buf].filetype)
			end
			if enabled then
				return { timeout_ms = 2000 }
			end
		end,
	})
	vim.keymap.set({ "n", "x" }, "<leader>f", function()
		require("conform").format({ async = true })
	end, { desc = "Format buffer or selection" })
	vim.keymap.set("n", "<leader>tf", function()
		local enabled = vim.b.format_on_save
		if enabled == nil then
			enabled = vim.tbl_contains({ "python", "go", "lua" }, vim.bo.filetype)
		end
		vim.b.format_on_save = not enabled
		vim.notify("Format on save: " .. tostring(not enabled))
	end, { desc = "Toggle format on save" })
end

-- Syntax highlighting and indentation.
do
	vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })

	local parsers = {
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"query",
		"vim",
		"vimdoc",
		"python",
		"go",
		"gomod",
		"gosum",
		"dockerfile",
		"yaml",
		"json",
		"toml",
	}
	require("nvim-treesitter").install(parsers)

	local function treesitter_try_attach(buf, language)
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		if not vim.treesitter.language.add(language) then
			return
		end

		vim.treesitter.start(buf, language)

		local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

		if has_indent_query then
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end

	local available_parsers = require("nvim-treesitter").get_available()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf, filetype = args.buf, args.match

			local language = vim.treesitter.language.get_lang(filetype)
			if not language then
				return
			end

			local installed_parsers = require("nvim-treesitter").get_installed("parsers")

			if vim.tbl_contains(installed_parsers, language) then
				treesitter_try_attach(buf, language)
			elseif vim.tbl_contains(available_parsers, language) then
				require("nvim-treesitter").install(language):await(function()
					treesitter_try_attach(buf, language)
				end)
			else
				treesitter_try_attach(buf, language)
			end
		end,
	})
end

-- Letter-based alternatives are easier to reach on AZERTY.
vim.keymap.set("n", "<leader>dn", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Diagnostic details" })
vim.keymap.set("n", "<leader>hj", function()
	require("gitsigns").nav_hunk("next")
end, { desc = "Next Git hunk" })
vim.keymap.set("n", "<leader>hk", function()
	require("gitsigns").nav_hunk("prev")
end, { desc = "Previous Git hunk" })
