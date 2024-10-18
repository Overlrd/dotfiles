-- fuzzy finding 
return {
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { { "junegunn/fzf", build = "./install --bin" },  "nvim-tree/nvim-web-devicons" },
        config = function()

            ------ FZF KEYMAPS ------
            local fzf = require("fzf-lua")
            vim.keymap.set('n', '<leader><leader>', fzf.buffers, { desc = "[S]earch buffers " })
            vim.keymap.set('n', '<leader>sf', fzf.files, { desc = "[S]earch [F]iles " })
            vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = "[S]earch [R]esume " })
            vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = "[S]earch [B]uiltin " })
            vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = "[S]earch [K]eymaps " })
            vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = "[S]earch [G]rep " })
            vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = "[S]earch [w]ord under cursor " })
            vim.keymap.set('n', '<leader>sd', fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostics Workspace"})
            vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = "[S]earch [H]elp Tags"})
            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set('n', '<leader>sn', function()
                fzf.files { cwd = vim.fn.stdpath 'config' }
            end, { desc = '[S]earch [N]eovim files' })
        end
    }
}
