# Neovim

Kickstart-based configuration for Neovim 0.12+, using the native package manager.
Copy init.lua and nvim-pack-lock.json to your Neovim configuration directory.

Install Git, ripgrep, Node/npm, Go, and a C compiler. Treesitter installation
also needs curl, tar and tree-sitter CLI 0.26.1+. Make enables Telescope's native
sorter and LuaSnip's optional regex support. A clipboard provider is needed for
system clipboard access (for example wl-clipboard under Wayland).

On the first online launch, approve plugin installation. Mason installs missing
servers and formatters automatically. Wait for installation to finish in :Mason,
then restart. Use :MasonToolsInstall to retry and :MasonToolsUpdate to update tools.
Use :lua vim.pack.update() for plugins; commit the resulting lockfile.

Python uses Pyright for types/navigation and Ruff for linting, formatting and
import organization. Project settings are respected; activate a virtualenv before
launching Neovim or keep it in .venv. Go uses gopls and goimports. Bash, Docker,
Compose, YAML, JSON, TOML and Lua servers are also configured.

- Up/Down navigate completion; Enter accepts only a selected suggestion.
- Tab/Shift-Tab navigate snippet placeholders; Ctrl-Space opens completion.
- Space f formats the buffer or selection; Space tf toggles save formatting.
- Save formatting defaults to enabled for Python, Go and Lua.
- Space ci organizes imports through the attached language server.
- Space sf searches files; Space sg searches text; Space Space lists buffers.
- Space dn/dp navigate diagnostics; Space dd opens diagnostic details.
- Space hj/hk navigate Git hunks; Space hp previews a hunk.
- grn renames, gra opens code actions, grd finds definitions, grr finds references.
- Space th toggles inlay hints; which-key shows other available bindings.

The UI uses the built-in default dark theme and mini.statusline. Treesitter
provides syntax highlighting and indentation. Use :ConformInfo, :MasonLog and
:checkhealth to inspect missing tools or installation failures.
