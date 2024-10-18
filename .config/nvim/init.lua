require("config.options")
require("config.keymaps")
require("config.lazy")

require("lazy").setup({
	spec = {
		 { import = "plugins" },
	},
	install = { colorscheme = { "retrobox" } },
	checker = { enabled = false },
})
