-- KEY MAPS

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { desc = 'NeoTree reveal', silent = true })
-- vim.keymap.set('n', '<C-g>', ':Neotree float git_status<CR>', { desc = 'NeoTree float git_status ', silent = true })
vim.keymap.set('n', '<leader>fm', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer', silent = true })
