-- init.lua
-- =============================================================================
-- PLUGIN MANAGER SETUP (LAZY.NVIM)
-- =============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- CORE SETTINGS
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.showmode = false
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Files and Backup
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undodir"
vim.opt.autowrite = true

-- Behavior
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"

-- =============================================================================
-- KEY MAPPINGS
-- =============================================================================

-- Basic file operations
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Navigation improvements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search and center" })

-- Tab management
vim.keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<S-Tab>", "<cmd>tabprev<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>t", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>x", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- Window management
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Utilities
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Spell check for text files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "txt" },
  desc = "Enable spell check for text files",
  command = "setlocal spell spelllang=en_us,fr",
})

-- =============================================================================
-- PLUGIN SETUP
-- =============================================================================

require("lazy").setup({
  -- Statusline
  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup()
    end,
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gblame", "Gpush", "Gpull" },
  },

  -- File manager
  {
    "mikavilpas/yazi.nvim",
    keys = {
      {
        "<leader>e",
        "<cmd>Yazi toggle<cr>",
        desc = "Toggle Yazi file manager",
        mode = { "n", "v" },
      },
    },
  },

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")

      -- Key mappings
      local keymap = vim.keymap.set
      keymap("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
      keymap("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
      keymap("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
      keymap("n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })
      keymap("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
      keymap("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
      keymap("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
      keymap("n", "<leader>sr", builtin.resume, { desc = "Search Resume" })
      keymap("n", "<leader>s.", builtin.oldfiles, { desc = "Search Recent Files" })
      keymap("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })

      -- Search in current buffer
      keymap("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "Fuzzily search in current buffer" })

      -- Search in open files
      keymap("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "Search in Open Files" })

      -- Search Neovim config files
      keymap("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Search Neovim files" })
    end,
  },
}, {
  install = { colorscheme = { "default" } },
})
