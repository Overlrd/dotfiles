return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
		},
		config = function()
			-- Initialize mason first
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓ ",
						package_pending = "➜ ",
						package_uninstalled = "✗ ",
					},
				},
			})

			-- Setup neodev for Neovim Lua development
			require("neodev").setup()

			-- Diagnostic signs
			local signs = {
				Error = "󰅚",
				Warn = "󰀪",
				Hint = "󰌶",
				Info = "",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- Diagnostic configuration
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				float = {
					border = "rounded",
					source = "if_many",
					header = "",
					prefix = "",
				},
			})

			-- Customize handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- LSP attach keybindings
			local function on_attach(client, bufnr)
				local opts = { buffer = bufnr, noremap = true, silent = true }

				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				-- Diagnostics
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

				-- Handle inlay hints for Neovim >= 0.10
				if vim.fn.has("nvim-0.10.0") == 1 and client.supports_method("textDocument/inlayHint") then
					vim.keymap.set("n", "<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
					end, opts)
				end

				-- Document highlighting
				if client.supports_method("textDocument/documentHighlight") then
					vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						group = "lsp_document_highlight",
						buffer = bufnr,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						group = "lsp_document_highlight",
						buffer = bufnr,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end

			-- Setup mason-lspconfig
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
				},
				automatic_installation = true,
			})

			-- LSP server configurations
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities(),
				{
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				}
			)

			-- Server specific settings
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							hint = { enable = true },
							completion = { callSnippet = "Replace" },
						},
					},
				},
				pyright = {
					mason = false,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				},
				ruff = {
					mason = false,
					on_attach = function(client, bufnr)
						client.server_capabilities.hoverProvider = false
					end,
				},
				clangd = {
					mason = false,
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						offsetEncoding = { "utf-16", "utf-8" },
					}),
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
					},
				},
				zls = {
					mason = false,
					cmd = { "zls" },
					filetypes = { "zig", "zir" },
					root_dir = require("lspconfig.util").root_pattern("zls.json", "build.zig", ".git"),
					single_file_support = true,
				},
			}

			-- Setup all servers
			local setup_server = function(server_name)
				local server_config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
					flags = {
						debounce_text_changes = 150,
					},
				}, servers[server_name] or {})

				require("lspconfig")[server_name].setup(server_config)
			end

			for server_name, server_config in pairs(servers) do
				setup_server(server_name)
			end

			-- Initialize servers
			require("mason-lspconfig").setup_handlers({})
		end,
	},
}
