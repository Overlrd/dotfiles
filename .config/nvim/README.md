# Neovim

Requires Neovim 0.12+. Copy `init.lua` and `nvim-pack-lock.json` into your
Neovim configuration directory. Plugins install on the first online launch.

Install Git, fzf and ripgrep. Language tools need Node/npm and a recent Go
compiler. Python projects use their own Python environment. Treesitter parser
installation needs a C compiler, curl, tar and tree-sitter CLI 0.26.1 or newer.
On Windows, provide these executables on PATH and use Neovim's standard config
directory (`%LOCALAPPDATA%/nvim`). No shell-specific configuration is required.

Run `:SetupTools`, let installation finish, then reopen Neovim. It installs the
latest available versions of missing language tools and missing parsers. Retry the command after a failed
download. Inspect failures in `:MasonLog`; use `:checkhealth` for dependencies.
French and English spell dictionaries can be downloaded through Neovim's
built-in prompt when first enabling spelling in a text file.

- Space Space finds files; Space b lists buffers; Space e opens the explorer.
- Space s opens search bindings; Space c exposes code actions and formatting.
- Space d exposes diagnostics; Space p exposes tool management.
- Up / Down select a completion. Enter accepts the selected item.
- Enter inserts a newline when nothing is selected. Ctrl+e closes completion.
- Tab / Shift+Tab move through active snippet placeholders.
- Space cf formats; Space ct toggles format-on-save for the current buffer.
- Space ci organises imports through the attached language server.

Edit the language list near the top of init.lua. Mason tools take precedence
over system tools when installed; otherwise system tools on PATH are used.
Use Mason to update installed tools. Space pu reviews plugin updates through
vim.pack; commit the resulting lockfile to reproduce installed revisions.
After a Treesitter plugin upgrade, run :TSUpdate as well.

The UI uses Neovim's default dark colorscheme and mini.statusline.

Pyright respects `pyrightconfig.json`, otherwise it discovers the active
virtual environment or a project `.venv`. Configure Odoo source paths in your
project. Files larger than 1 MiB skip completion and Treesitter and detach LSP.

