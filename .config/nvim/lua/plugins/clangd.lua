return {
	-- Recommended file types and root detection
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = {
					mason = false,
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
			},
		},
	},

	-- Add C/C++ to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "cpp" } },
	},

	-- Clangd extensions for enhanced features
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
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

	-- nvim-cmp integration for completion
	-- {
	--     "nvim-cmp",
	--     opts = function(_, opts)
	--         table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
	--     end,
	-- },

	-- Debugger setup with nvim-dap
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			"williamboman/mason.nvim",
			opts = { ensure_installed = { "codelldb" } },
		},
		opts = function()
			local dap = require("dap")
			if not dap.adapters["codelldb"] then
				dap.adapters["codelldb"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "codelldb",
						args = { "--port", "${port}" },
					},
				}
			end
			for _, lang in ipairs({ "c", "cpp" }) do
				dap.configurations[lang] = {
					{
						type = "codelldb",
						request = "launch",
						name = "Launch file",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
					},
					{
						type = "codelldb",
						request = "attach",
						name = "Attach to process",
						pid = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end,
	},
}