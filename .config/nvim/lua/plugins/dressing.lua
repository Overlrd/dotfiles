return {
	"stevearc/dressing.nvim",
	dependencies = {
		"rcarriga/nvim-notify",
	},
	opts = {},

	config = function()
		require("notify").setup({})
		vim.notify = require("notify")
	end,
}
