return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({})
            -- Key mappings for fzf-lua commands
            vim.keymap.set("n", "<leader>sf", require("fzf-lua").files, { desc = "Fzf: Find Files" })
            vim.keymap.set("n", "<leader><leader>", require("fzf-lua").buffers, { desc = "Fzf: Open Buffers" })
            vim.keymap.set("n", "<leader>sg", require("fzf-lua").live_grep, { desc = "Fzf: Live Grep" })
            vim.keymap.set("n", "<leader>sw", require("fzf-lua").grep_cword, { desc = "Fzf: Grep Word Under Cursor" })
            vim.keymap.set("n", "<leader>rs", require("fzf-lua").resume, { desc = "Fzf: Resume Last Command" })
            vim.keymap.set("n", "<leader>sk", require("fzf-lua").keymaps, { desc = "Fzf: Show Key Mappings" })
            vim.keymap.set("n", "<leader>sb", require("fzf-lua").builtin, { desc = "Fzf: Show Built-in Commands" })
        end,
    },
}

