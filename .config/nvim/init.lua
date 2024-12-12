-- Core variables
vim.g.undodir = os.getenv("HOME") .. "/.cache/vim/undodir/"
vim.g.have_nerd_font = true
vim.o.background = "dark"

-- Core settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.swapfile = false
vim.opt.undodir = vim.g.undodir
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c-i:block"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic keymaps
vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Save file" }) -- Save
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit file" }) -- Quit

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })

-- Escape search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Format buffer
vim.keymap.set('n', '<space>fm', function() vim.lsp.buf.format { async = true } end)

-- On on_attach function to run whenever a language server is attached to a buffer
local on_attach = function (event)
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, noremap = true, silent = true, desc = desc })
    end

    -- Rename the variable under your cursor.
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    -- Hover documentation
    map('K', vim.lsp.buf.hover, "LSP: Hover Documentation")

    -- Signature help
    map('<C-k>', vim.lsp.buf.signature_help, "LSP: Signature Help")

    -- Diagnostics navigation
    map('<A-p>', vim.diagnostic.goto_prev, "LSP: Previous Diagnostic")
    map('<A-n>', vim.diagnostic.goto_next, "LSP: Next Diagnostic")

    -- Open diagnostics in floating window
    map('<leader>e', vim.diagnostic.open_float, "LSP: Show Diagnostics")
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- Detect tabstop and shiftwidth automatically
        "tpope/vim-sleuth",
        -- Git commands
        "tpope/vim-fugitive",

        {
            'echasnovski/mini.statusline',
            version = '*',
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                require('mini.statusline').setup()
            end
        },

        -- Treesitter: syntax highlighting, text objects, and more
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "c", "cpp", "lua", "python", "javascript", "markdown" },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },

        -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-buffer",
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
            config = function()
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                luasnip.config.setup({})

                cmp.setup({
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<Tab>"] = cmp.mapping.select_next_item(),
                        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                        ["<C-Space>"] = cmp.mapping.complete(),
                    }),
                    sources = {
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                        { name = "buffer" },
                        { name = "path" },
                    },
                })
            end,
        },
        {
            "ibhagwan/fzf-lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("fzf-lua").setup({})
                vim.keymap.set("n", "<Leader>ff", require('fzf-lua').files, { desc = "Fzf Files" })
                vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep, { desc = 'Fzf live grep' })
                vim.keymap.set('n', '<leader><leader>', require('fzf-lua').buffers, { desc = 'Telescope buffers' })

                -- Shortcut for searching your Neovim configuration files
                vim.keymap.set('n', '<leader>sn', function()
                    require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
                end, { desc = '[S]earch [N]eovim files' })
            end
        },

        -- LSP Configuration
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                { "j-hui/fidget.nvim", opts = {} },
            },
            config = function()
                vim.api.nvim_create_autocmd('LspAttach', {
                    callback = on_attach
                })

                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                local servers = {
                    bashls = {},
                    ruff = {
                        on_attach = function(client, bufnr)
                            if client.name == 'ruff_lsp' or client.name == 'ruff' then
                                -- Disable hover in favor of Pyright
                                client.server_capabilities.hoverProvider = false
                            end
                        end
                    },
                    basedpyright = {
                        settings = {
                            basedpyright = {
                                disableOrganizeImports = true,
                                disableTaggedHints = false,
                                analysis = {
                                    typeCheckingMode = "standard",
                                    useLibraryCodeForTypes = true, -- Analyze library code for type information
                                    autoImportCompletions = true,
                                    autoSearchPaths = true,
                                    diagnosticSeverityOverrides = {
                                        reportIgnoreCommentWithoutRule = true,
                                    },
                                },
                            },
                        },
                    },
                    lua_ls = {
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = { globals = { "vim" } },
                                workspace = { checkThirdParty = false },
                                telemetry = { enable = false },
                            },
                        },
                    },
                    clangd = {
                        mason = false,
                        root_dir = function(fname)
                            return require("lspconfig.util").root_pattern(
                                    "Makefile",
                                    "configure.ac",
                                    "configure.in",
                                    "config.h.in",
                                    "meson.build",
                                    "meson_options.txt",
                                    "build.ninja"
                                )(fname) or
                                require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                                    fname
                                ) or require("lspconfig.util").find_git_ancestor(fname)
                        end,
                        capabilities = {
                            offsetEncoding = { "utf-16" },
                        },
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                            "--completion-style=detailed",
                            "--function-arg-placeholders",
                            "--fallback-style=llvm",
                        },
                        init_options = {
                            usePlaceholders = true,
                            completeUnimported = true,
                            clangdFileStatus = true,
                        },
                    },
                }

                local all_servers = vim.tbl_keys(servers or {})
                local ensure_installed = {}

                for _, server in ipairs(all_servers) do
                    -- Ensure 'mason' is either true or set to true if not defined
                    if servers[server].mason == nil then
                        servers[server].mason = true
                    end

                    -- If 'mason' is true, add to 'ensure_installed'
                    if servers[server].mason == true then
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end

                vim.list_extend(ensure_installed, {
                    'stylua', 'shfmt', 'shellcheck',
                })

                require('mason').setup()
                require('mason-tool-installer').setup { ensure_installed = ensure_installed }

                for server, config in pairs(servers) do
                    require("lspconfig")[server].setup(vim.tbl_deep_extend("force", {
                        capabilities = capabilities,
                    }, config))
                end

                require('mason-lspconfig').setup {
                    handlers = {
                        function(server_name)
                            local server = servers[server_name] or {}
                            -- This handles overriding only values explicitly passed
                            -- by the server configuration above. Useful when disabling
                            -- certain features of an LSP (for example, turning off formatting for ts_ls)
                            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
                                server.capabilities or {})
                            require('lspconfig')[server_name].setup(server)
                        end,
                    },
                }

                -- Change diagnostic symbols in the sign column (gutter)
                if vim.g.have_nerd_font then
                    local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
                    local diagnostic_signs = {}
                    for type, icon in pairs(signs) do
                        diagnostic_signs[vim.diagnostic.severity[type]] = icon
                    end
                    vim.diagnostic.config { signs = { text = diagnostic_signs } }
                end
            end,
        },

        -- debug
        require 'neovim.debug',
    },
    install = { colorscheme = { "default" } },
    checker = { enabled = false },
})
