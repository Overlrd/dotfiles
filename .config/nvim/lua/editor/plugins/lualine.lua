local M = {}
M.theme = function()
  local colors = {
    darkgray = '#16161d',
    gray = '#727169',
    innerbg = nil,
    outerbg = '#16161D',
    normal = '#7e9cd8',
    insert = '#98bb6c',
    visual = '#ffa066',
    replace = '#e46876',
    command = '#e6c384',
  }
  return {
    inactive = {
      a = { fg = colors.gray, bg = colors.outerbg, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    visual = {
      a = { fg = colors.darkgray, bg = colors.visual, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    replace = {
      a = { fg = colors.darkgray, bg = colors.replace, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    normal = {
      a = { fg = colors.darkgray, bg = colors.normal, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    insert = {
      a = { fg = colors.darkgray, bg = colors.insert, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
    command = {
      a = { fg = colors.darkgray, bg = colors.command, gui = 'bold' },
      b = { fg = colors.gray, bg = colors.outerbg },
      c = { fg = colors.gray, bg = colors.innerbg },
    },
  }
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = M.theme(), -- You can set this to any theme or 'auto'
          section_separators = { '', '' }, -- Remove section separators
          component_separators = { '', '' }, -- Remove component separators
          disabled_filetypes = { 'NvimTree', 'packer' }, -- Disable in certain filetypes (optional)
          globalstatus = true, -- Enable global statusline (if using Neovim 0.7+)
        },
        sections = {
          lualine_a = { 'mode' }, -- Show the current mode (NORMAL, INSERT, etc.)
          lualine_b = { 'branch' }, -- Show the git branch
          lualine_c = { 'filename' }, -- Show the current filename
          lualine_x = { 'encoding', 'fileformat' }, -- File encoding and format
          lualine_y = { 'progress' }, -- Show progress (cursor percentage)
          lualine_z = { 'location' }, -- Show the current line and column
        },
        extensions = {},
        colors = {},
      }
    end,
  },
}
