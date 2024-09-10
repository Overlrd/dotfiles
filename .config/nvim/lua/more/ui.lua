return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		"stevearc/dressing.nvim",
		dependencies = {
			"rcarriga/nvim-notify",
		},
		opts = {},

		config = function()
			require("notify").setup({})
			vim.notify = require("notify")
		end,
	},
}
