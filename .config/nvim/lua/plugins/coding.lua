return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-fugitive', -- Git wrapper

  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      {
        'garymjr/nvim-snippets',
        opts = {
          friendly_snippets = true,
        },
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
    },
    opts = function()
      local cmp = require 'cmp'
      local auto_select = true
      return {
        auto_brackets = { 'lua', 'python' }, -- configure any filetype to auto add brackets
        completion = {
          completeopt = 'menu,menuone,noinsert' .. (auto_select and '' or ',noselect'),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<Tab>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ['<S-Tab>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },

          ['<CR>'] = cmp.mapping.confirm { select = true },

          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
        }, {
          { name = 'buffer' },
          { name = 'snippets' },
        }),
      }
    end,
  },
}
