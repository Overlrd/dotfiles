return {
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
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			filesystem = {
				window = {
					width = 30,
					mappings = {
						["."] = "set_root",
					},
				},
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

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
}
