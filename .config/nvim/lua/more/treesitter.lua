return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          -- A list of parser names, or "all" (the listed parsers MUST always be installed)
          ensure_installed = { "c", "lua", "vim", "vimdoc", "go", "html" },
          
          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,
          
          -- Automatically install missing parsers when entering buffer
          -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
          auto_install = true,
          highlight = { enable = true },
          
          -- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature.
          indent = { enable = true },  
        })
    end
 }
