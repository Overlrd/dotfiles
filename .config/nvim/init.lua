require 'editor.options'
require 'editor.lazy'
require 'editor.mappings'

-- TODO: Move this function elsewhere
function ColorMyPencils(color)
  color = color or 'retrobox'

  vim.cmd.colorscheme(color)

  vim.cmd [[set termguicolors]]
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.cmd 'hi Normal guibg=NONE ctermbg=NONE'
  vim.cmd 'hi CursorColumn cterm=NONE ctermbg=NONE ctermfg=NONE'
  vim.cmd 'hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE'
  vim.cmd 'hi CursorLineNr cterm=NONE ctermbg=NONE ctermbg=NONE'
  vim.cmd 'hi clear LineNr'
  vim.cmd 'hi clear SignColumn'
  vim.cmd 'hi clear StatusLine'
  vim.cmd 'hi clear StatusLineNC' -- Non-focused status line
  vim.cmd 'hi clear TabLine'
  vim.cmd 'hi clear TabLineFill'
  vim.cmd 'hi clear TabLineSel'
  vim.cmd 'hi clear VertSplit' -- Transparent vertical split line
  vim.cmd 'hi clear Pmenu' -- Transparent popup menu

  -- Set Bufferline transparency
  vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineSeparator', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineSeparatorVisible', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineSeparatorInactive', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineBuffer', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineBufferSelected', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineModified', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineModifiedSelected', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineBackground', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineBackgroundSelected', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineCloseButton', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineCloseButtonVisible', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineCloseButtonSelected', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineIndicatorSelected', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'BufferLineIndicator', { bg = 'none' })
end

ColorMyPencils()
