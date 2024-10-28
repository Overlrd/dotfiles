-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>e", ":Neotree toggle<CR>", desc = "NeoTree reveal", silent = true },
	},
	opts = {
		filesystem = {
			window = {
				width = 30,
				mappings = {
					["<leader>e"] = "close_window",
					["ga"] = "git_add_file",
					["gc"] = "git_commit",
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["gr"] = "git_revert_file",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
				},
			},
		},
	},
}
