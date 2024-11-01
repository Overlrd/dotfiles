return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason.nvim",
			{ "williamboman/mason-lspconfig.nvim", opts = {}, config = function() end },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{
				"ibhagwan/fzf-lua",
				dependencies = { "nvim-tree/nvim-web-devicons" },
			},
			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = {
			-- Enable LSP cursor word highlighting
			document_highlight = {
				enabled = true,
			},
			-- Add any global capabilities here
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			servers = {
				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					-- Use this to add any additional keymaps
					-- for specific LSP servers
					-- ---@type LazyKeysSpec[]
					-- keys = {},
					settings = {
						Lua = {
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
							diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						},
					},
				},
			},
		},
		config = function(_, opts)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					map("gd", function()
						require("fzf-lua").lsp_definitions()
					end, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", function()
						require("fzf-lua").lsp_references()
					end, "[G]oto [R]eferences")

					-- Find symbols in the current workspace.
					map("<leader>gS", function()
						require("fzf-lua").lsp_workspace_symbols()
					end, "[G]oto [S]ymbols in [W]orkspace")

					-- Find symbols in the current document.
					map("<leader>gs", function()
						require("fzf-lua").lsp_document_symbols()
					end, "[G]oto [S]ymbols in [D]ocument")

					-- Jump to the implementation of the word under your cursor.
					map("gI", function()
						require("fzf-lua").lsp_implementations()
					end, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					map("<leader>D", function()
						require("fzf-lua").lsp_typedefs()
					end, "Type [D]efinition")

					-- Rename the variable under your cursor.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- Go to declaration
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Highlight references of the word under your cursor
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- Toggle inlay hints if supported
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = opts.servers
			local ensure_installed = {}

			for server_name, server_config in pairs(servers or {}) do
				-- Exclude servers with mason = false
				if server_config.mason ~= false then
					table.insert(ensure_installed, server_name)
				end
			end

			require("mason").setup()
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Setup each server
			for server, config in pairs(servers) do
				config.capabilities = capabilities
				lspconfig[server].setup(config)
			end
		end,
	},
}
