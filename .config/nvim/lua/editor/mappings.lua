local map = vim.keymap.set

map('i', '<C-b>', '<ESC>^i', { desc = 'move beginning of line' })
map('i', '<C-e>', '<End>', { desc = 'move end of line' })
map('i', '<C-h>', '<Left>', { desc = 'move left' })
map('i', '<C-l>', '<Right>', { desc = 'move right' })
map('i', '<C-j>', '<Down>', { desc = 'move down' })
map('i', '<C-k>', '<Up>', { desc = 'move up' })

map('n', '<C-h>', '<C-w>h', { desc = 'switch window left' })
map('n', '<C-l>', '<C-w>l', { desc = 'switch window right' })
map('n', '<C-j>', '<C-w>j', { desc = 'switch window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'switch window up' })

map('n', '<Esc>', '<cmd>noh<CR>', { desc = 'general clear highlights' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'general save file' })

map('n', '<leader>fm', function() end, { desc = 'general format file' })

-- global lsp mappings
map('n', '<leader>ds', vim.diagnostic.setloclist, { desc = 'LSP diagnostic loclist' })

-- tabufline
map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'buffer new' })

map('n', '<tab>', ':bnext<CR>', { desc = 'buffer goto next' })

map('n', '<S-tab>', ':bprev<CR>', { desc = 'buffer goto prev' })

map('n', '<leader>x', ':bd<CR>', { desc = 'buffer close' })

-- Comment
map('n', '<leader>/', 'gcc', { desc = 'toggle comment', remap = true })
map('v', '<leader>/', 'gc', { desc = 'toggle comment', remap = true })

-- nvimtree
map('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'nvimtree toggle window' })
map('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'nvimtree focus window' })

-- format
map('n', '<leader>fm', function()
  require('conform').format { lsp_fallback = true }
end, { desc = 'general format file' })

-- Telescope
map('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = '[Search] [T]odos' })
map('n', '<leader>th', '<cmd>Telescope colorscheme<CR>', { desc = 'Builtin Colorscheme' })
map('n', '<leader>sh', '<cmd>Telescope help_tags<CR>', { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', '<cmd>Telescope keymaps<CR>', { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', '<cmd>Telescope find_files<CR>', { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', '<cmd>Telescope builtin<CR>', { desc = '[S]earch [S]elect Telescope' })
map('n', '<leader>sw', '<cmd>Telescope grep_string<CR>', { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', '<cmd>Telescope live_grep<CR>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', '<cmd>Telescope diagnostics<CR>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', '<cmd>Telescope resume<CR>', { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', '<cmd>Telescope oldfiles<CR>', { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader><leader>', '<cmd>Telescope buffers<CR>', { desc = '[ ] Find existing buffers' })

-- Slightly advanced example of overriding default behavior and theme
map('n', '<leader>/', function()
  -- Safe call in case Telescope is not available
  local success, _ = pcall(function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end)
  if not success then
    print 'Telescope is not installed.'
  end
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
map('n', '<leader>s/', function()
  local success, _ = pcall(function()
    require('telescope.builtin').live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end)
  if not success then
    print 'Telescope is not installed.'
  end
end, { desc = '[S]earch [/] in Open Files' })

-- Shortcut for searching your Neovim configuration files
map('n', '<leader>sn', function()
  local success, _ = pcall(function()
    require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
  end)
  if not success then
    print 'Telescope is not installed.'
  end
end, { desc = '[S]earch [N]eovim files' })
