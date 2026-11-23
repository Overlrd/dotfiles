-- Neovim 0.12+. Run :SetupTools once, then reopen Neovim.
-- Tools: git, fzf, ripgrep, Node/npm, Go, curl, tar, C compiler, tree-sitter CLI >= 0.26.1.
local prefer_system_tools = false
local transparent = false
local large_file_bytes = 1024 * 1024

-- Tool versions are separate from the plugin lockfile.
local languages = {
	{ server = 'pyright', package = 'pyright', version = '1.1.414', parser = 'python' },
	{ server = 'ruff', package = 'ruff', version = '0.17.6' },
	{ server = 'gopls', package = 'gopls', version = 'v0.24.0', parser = 'go' },
	{ server = 'bashls', package = 'bash-language-server', version = '5.8.1', parser = 'bash' },
	{
		server = 'dockerls',
		package = 'dockerfile-language-server',
		version = '0.15.0',
		parser = 'dockerfile',
	},
	{
		server = 'docker_compose_language_service',
		package = 'docker-compose-language-service',
		version = '1.0.0',
	},
	{ server = 'yamlls', package = 'yaml-language-server', version = '2.0.0', parser = 'yaml' },
	{ server = 'jsonls', package = 'json-lsp', version = '4.10.0', parser = 'json' },
	{ server = 'taplo', package = 'taplo', version = '0.10.0', parser = 'toml' },
	{ server = 'lua_ls', package = 'lua-language-server', version = '3.19.2', parser = 'lua' },
}
local extra_tools = {
	{ package = 'shellcheck', version = 'v0.11.0', cmd = 'shellcheck' },
	{ package = 'shfmt', version = 'v3.14.1', cmd = 'shfmt' },
	{ package = 'stylua', version = 'v2.6.0', cmd = 'stylua' },
	{ package = 'prettier', version = '3.10.1', cmd = 'prettier' },
}
local parsers = { 'markdown', 'markdown_inline', 'gomod', 'gosum', 'vim', 'vimdoc', 'query' }
for _, language in ipairs(languages) do
	if language.parser then
		table.insert(parsers, language.parser)
	end
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.scrolloff = 6
opt.termguicolors = true
opt.showmode = false
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.wrap = false
opt.autowrite = false
opt.undofile = true
local undo_dir = vim.fn.stdpath('state') .. '/undo'
vim.fn.mkdir(undo_dir, 'p')
opt.undodir = undo_dir
opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.timeoutlen = 500
opt.updatetime = 300
opt.laststatus = 3
opt.statusline = ' %{mode()}  %<%f %m%r%=%{v:lua.DotfilesDiagnostics()}  %l:%c  %p%% '
function _G.DotfilesDiagnostics()
	local count = vim.diagnostic.count(0)
	return string.format('E:%d W:%d', count[1] or 0, count[2] or 0)
end

local group = vim.api.nvim_create_augroup('Dotfiles', { clear = true })
local function autocmd(event, opts)
	opts.group = group
	vim.api.nvim_create_autocmd(event, opts)
end
local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end
local function warn(message)
	vim.schedule(function()
		vim.notify(message, vim.log.levels.WARN)
	end)
end
local function theme()
	local hl = vim.api.nvim_set_hl
	hl(0, 'Normal', { fg = '#e2e8ef', bg = transparent and 'NONE' or '#243442' })
	hl(0, 'NormalFloat', { fg = '#e2e8ef', bg = '#304657' })
	hl(0, 'FloatBorder', { fg = '#8fe5d3', bg = '#304657' })
	hl(0, 'StatusLine', { fg = '#eafff9', bg = '#315a60' })
	hl(0, 'StatusLineNC', { fg = '#bfd0dc', bg = '#304657' })
	hl(0, 'CursorLine', { bg = '#304657' })
	hl(0, 'Visual', { bg = '#456579' })
	hl(0, 'Pmenu', { fg = '#e2e8ef', bg = '#304657' })
	hl(0, 'PmenuSel', { fg = '#182b31', bg = '#8fe5d3' })
end
vim.cmd.colorscheme('habamax')
theme()
autocmd('ColorScheme', { callback = theme })
autocmd('TextYankPost', {
	callback = function()
		vim.hl.on_yank({ timeout = 150 })
	end,
})
autocmd('BufReadPre', {
	callback = function(ev)
		local stat = vim.uv.fs_stat(ev.file)
		vim.b[ev.buf].large_file = stat and stat.size > large_file_bytes or false
	end,
})
autocmd('FileType', {
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		if ft == 'go' or ft == 'gomod' or ft == 'make' then
			vim.bo[ev.buf].expandtab = false
			vim.bo[ev.buf].tabstop = 8
			vim.bo[ev.buf].shiftwidth = 8
		elseif
			vim.tbl_contains(
				{ 'yaml', 'yaml.docker-compose', 'json', 'jsonc', 'lua', 'sh', 'bash' },
				ft
			)
		then
			vim.bo[ev.buf].shiftwidth = 2
			vim.bo[ev.buf].tabstop = 2
		end
		if ft == 'markdown' or ft == 'text' then
			vim.opt_local.spelllang = { 'en_us', 'fr' }
			vim.opt_local.spell = true
		end
	end,
})

map('n', '<leader>w', '<cmd>write<cr>', 'Save file')
map('n', '<leader>q', '<cmd>quit<cr>', 'Quit window')
map('n', '<leader>e', '<cmd>Explore<cr>', 'File explorer')
map('n', '<Esc>', '<cmd>nohlsearch<cr>', 'Clear search highlight')
map('n', '<C-d>', '<C-d>zz', 'Page down')
map('n', '<C-u>', '<C-u>zz', 'Page up')
map('n', 'n', 'nzzzv', 'Next match')
map('n', 'N', 'Nzzzv', 'Previous match')
for key, direction in pairs({ h = 'h', j = 'j', k = 'k', l = 'l' }) do
	map('n', '<C-' .. key .. '>', '<C-w>' .. direction, 'Focus window')
end
map('n', '<leader>tn', '<cmd>tabnew<cr>', 'New tab')
map('n', '<leader>tc', '<cmd>tabclose<cr>', 'Close tab')
map('n', '<leader>tj', '<cmd>tabprevious<cr>', 'Previous tab')
map('n', '<leader>tk', '<cmd>tabnext<cr>', 'Next tab')
map('n', '<leader>tt', '<cmd>terminal<cr>', 'Terminal')
map('t', '<Esc><Esc>', '<C-\\><C-n>', 'Leave terminal mode')
map('n', '<leader>dn', function()
	vim.diagnostic.jump({ count = 1, float = true })
end, 'Next diagnostic')
map('n', '<leader>dp', function()
	vim.diagnostic.jump({ count = -1, float = true })
end, 'Previous diagnostic')
map('n', '<leader>dd', vim.diagnostic.open_float, 'Diagnostic details')
vim.diagnostic.config({ virtual_text = false, severity_sort = true, float = { border = 'rounded' } })

if vim.fn.has('nvim-0.12') == 0 then
	warn('This config needs Neovim 0.12+. Core editing remains available.')
	return
end

-- Pinned commits also make copying init.lua alone reproducible.
local plugins = {
	{
		src = 'https://github.com/mason-org/mason.nvim',
		version = '2a6940af80375532e5e9e7c1f2fc6319a1b7a69d',
	},
	{
		src = 'https://github.com/mason-org/mason-lspconfig.nvim',
		version = 'a5671269a1ddfa7790cdf97c14e600e269da550f',
	},
	{
		src = 'https://github.com/neovim/nvim-lspconfig',
		version = '4648fd8ba5c678d7e2db75ae44ffac269bb589d8',
	},
	{
		src = 'https://github.com/folke/which-key.nvim',
		version = 'fcbf4eea17cb299c02557d576f0d568878e354a4',
	},
	{
		src = 'https://github.com/stevearc/conform.nvim',
		version = '3543d000dafbc41cc7761d860cfdb24e82154f75',
	},
	{
		src = 'https://github.com/ibhagwan/fzf-lua',
		version = 'a8312697c30b4d3b110fa3dc56e3699107aed9a0',
	},
	{
		src = 'https://github.com/saghen/blink.cmp',
		version = '78336bc89ee5365633bcf754d93df01678b5c08f',
	},
	{
		src = 'https://github.com/nvim-treesitter/nvim-treesitter',
		version = '52773f0d13a0c11d0c3ef33c14ab6ecc1c17148b',
	},
}
local ok, err = pcall(vim.pack.add, plugins, { confirm = false })
if not ok then
	warn('Plugin installation failed. Check Git/network and restart: ' .. tostring(err))
	return
end

-- One completion engine, with explicit selection before Enter accepts.
local blink = require('blink.cmp')
blink.setup({
	enabled = function()
		return vim.bo.buftype ~= 'prompt' and not vim.b.large_file
	end,
	fuzzy = { implementation = 'lua' },
	keymap = {
		preset = 'none',
		['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-n>'] = { 'select_next', 'fallback' },
		['<C-p>'] = { 'select_prev', 'fallback' },
		['<CR>'] = { 'accept', 'fallback' },
		['<C-e>'] = { 'hide', 'fallback' },
		['<Tab>'] = { 'snippet_forward', 'fallback' },
		['<S-Tab>'] = { 'snippet_backward', 'fallback' },
		['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
		['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
	},
	completion = {
		list = { selection = { preselect = false, auto_insert = false } },
		documentation = { auto_show = true, window = { border = 'rounded' } },
		menu = {
			border = 'rounded',
			draw = {
				columns = { { 'label', 'label_description', gap = 1 }, { 'kind', 'source_name' } },
			},
		},
	},
	sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
		providers = {
			buffer = {
				opts = {
					get_bufnrs = function()
						return { vim.api.nvim_get_current_buf() }
					end,
				},
			},
		},
	},
	signature = { enabled = true, window = { border = 'rounded' } },
})

require('mason').setup({
	PATH = prefer_system_tools and 'append' or 'prepend',
	registry_cache = { refresh = false },
	ui = {
		check_outdated_packages_on_open = false,
		icons = { package_installed = '+', package_pending = '~', package_uninstalled = '-' },
	},
})
vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities() })
vim.lsp.config('pyright', {
	settings = {
		pyright = { disableOrganizeImports = true },
		python = {
			analysis = {
				typeCheckingMode = 'basic',
				diagnosticMode = 'openFilesOnly',
				diagnosticSeverityOverrides = {
					reportUnusedImport = 'none',
					reportUnusedVariable = 'none',
					reportDuplicateImport = 'none',
					reportUndefinedVariable = 'none',
				},
			},
		},
	},
	before_init = function(_, config)
		-- Respect pyrightconfig.json; otherwise discover the active or project venv.
		if config.root_dir and vim.uv.fs_stat(config.root_dir .. '/pyrightconfig.json') then
			return
		end
		local env = vim.env.VIRTUAL_ENV
		if not env and config.root_dir then
			env = config.root_dir .. '/.venv'
		end
		if env then
			local python = vim.fs.joinpath(
				env,
				vim.fn.has('win32') == 1 and 'Scripts/python.exe' or 'bin/python'
			)
			if vim.fn.executable(python) == 1 then
				config.settings.python.pythonPath = python
			end
		end
	end,
})
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = { globals = { 'vim' } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config('yamlls', {
	cmd = { 'yaml-language-server', '--stdio' },
	filetypes = { 'yaml', 'yaml.gitlab', 'yaml.helm-values' },
	settings = { yaml = { schemaStore = { enable = true } } },
})
vim.lsp.config('jsonls', { cmd = { 'vscode-json-language-server', '--stdio' } })
vim.filetype.add({
	filename = {
		['compose.yaml'] = 'yaml.docker-compose',
		['compose.yml'] = 'yaml.docker-compose',
		['docker-compose.yaml'] = 'yaml.docker-compose',
		['docker-compose.yml'] = 'yaml.docker-compose',
	},
	pattern = {
		['.*/compose%.[^/]+%.ya?ml'] = 'yaml.docker-compose',
		['.*/docker%-compose%.[^/]+%.ya?ml'] = 'yaml.docker-compose',
	},
})
require('mason-lspconfig').setup({ ensure_installed = {}, automatic_enable = false })

local finder
local function get_finder()
	if not finder then
		finder = require('fzf-lua')
		finder.setup({
			file_icons = false,
			git_icons = false,
			winopts = { border = 'rounded' },
			previewers = {
				builtin = { syntax_limit_b = large_file_bytes, limit_b = large_file_bytes * 2 },
			},
		})
	end
	return finder
end

local function enable_servers()
	for _, language in ipairs(languages) do
		local config = vim.lsp.config[language.server]
		if config and type(config.cmd) == 'table' and vim.fn.executable(config.cmd[1]) == 1 then
			vim.lsp.enable(language.server)
		end
	end
end
enable_servers()
autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if vim.b[ev.buf].large_file then
			vim.lsp.buf_detach_client(ev.buf, client.id)
			return
		end
		if client.name == 'ruff' then
			client.server_capabilities.hoverProvider = false
		end
		local function lmap(key, action, desc)
			vim.keymap.set('n', key, action, { buffer = ev.buf, desc = desc })
		end
		lmap('gd', vim.lsp.buf.definition, 'Definition')
		lmap('gr', function()
			if vim.fn.executable('fzf') == 0 then
				return vim.lsp.buf.references()
			end
			get_finder().lsp_references()
		end, 'References')
		lmap('K', vim.lsp.buf.hover, 'Documentation')
		lmap('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
		lmap('<leader>ca', vim.lsp.buf.code_action, 'Code actions')
		lmap('<leader>cs', function()
			if vim.fn.executable('fzf') == 0 then
				return vim.lsp.buf.document_symbol()
			end
			get_finder().lsp_document_symbols()
		end, 'Document symbols')
		lmap('<leader>ci', function()
			vim.lsp.buf.code_action({
				context = { only = { 'source.organizeImports' }, diagnostics = {} },
				apply = true,
			})
		end, 'Organise imports')
	end,
})

local conform = require('conform')
conform.setup({
	formatters_by_ft = {
		python = { 'ruff_format' },
		lua = { 'stylua' },
		sh = { 'shfmt' },
		bash = { 'shfmt' },
		yaml = { 'prettier' },
		['yaml.docker-compose'] = { 'prettier' },
		json = { 'prettier' },
		jsonc = { 'prettier' },
		markdown = { 'prettier' },
		toml = { 'taplo' },
	},
	default_format_opts = { lsp_format = 'fallback', timeout_ms = 2000 },
	format_on_save = function(buf)
		if vim.b[buf].format_on_save and not vim.b[buf].large_file then
			return { timeout_ms = 2000 }
		end
	end,
})
map({ 'n', 'x' }, '<leader>cf', function()
	conform.format({ async = true })
end, 'Format')
map('n', '<leader>ct', function()
	vim.b.format_on_save = not vim.b.format_on_save
	vim.notify('Format on save: ' .. tostring(vim.b.format_on_save))
end, 'Toggle format on save')

local function project_root()
	return vim.fs.root(0, { 'go.work', 'go.mod', 'pyproject.toml', 'pyrightconfig.json', '.git' })
		or vim.fn.getcwd()
end
local function picker(name, opts)
	return function()
		if vim.fn.executable('fzf') == 0 then
			return warn('Install fzf to use the finder.')
		end
		if (name == 'live_grep' or name == 'grep_cword') and vim.fn.executable('rg') == 0 then
			return warn(
				'Install ripgrep for project search; :vimgrep is available in the meantime.'
			)
		end
		get_finder()[name](vim.tbl_extend('force', { cwd = project_root() }, opts or {}))
	end
end
-- fzf-lua's Lua modules load on the first search.
map('n', '<leader><leader>', picker('files'), 'Find project files')
map('n', '<leader>ff', function()
	picker('files', { cwd = vim.fn.getcwd() })()
end, 'Find files in working directory')
map('n', '<leader>fr', picker('oldfiles'), 'Recent files')
map('n', '<leader>b', picker('buffers'), 'Buffers')
map('n', '<leader>sg', picker('live_grep'), 'Search project')
map('n', '<leader>sw', picker('grep_cword'), 'Search word')
map('n', '<leader>sh', picker('helptags'), 'Search help')
map('n', '<leader>sk', picker('keymaps'), 'Search keybindings')
map('n', '<leader>sr', picker('resume'), 'Resume search')
map('n', '<leader>dl', picker('diagnostics_workspace'), 'Project diagnostics')
map('n', '<leader>gg', picker('git_status'), 'Git status')
map('n', '<leader>gl', picker('git_bcommits'), 'File history')
map('n', '<leader>pm', '<cmd>Mason<cr>', 'Mason tools')
map('n', '<leader>ph', '<cmd>checkhealth<cr>', 'Check health')

require('nvim-treesitter').setup({})
autocmd('FileType', {
	callback = function(ev)
		if not vim.b[ev.buf].large_file then
			pcall(vim.treesitter.start, ev.buf)
		end
	end,
})
-- Keep a selection history so shrinking returns to the previous node.
local selections = {}
local function select_node(shrink)
	local buf = vim.api.nvim_get_current_buf()
	local state = selections[buf]
	local visual = vim.fn.mode():match('[vV]')
	if not visual or not state or state.tick ~= vim.api.nvim_buf_get_changedtick(buf) then
		local success, node = pcall(vim.treesitter.get_node)
		if not success or not node then
			return warn('No Treesitter parser for this buffer.')
		end
		state = { nodes = { node }, tick = vim.api.nvim_buf_get_changedtick(buf) }
		selections[buf] = state
	elseif shrink then
		if #state.nodes > 1 then
			table.remove(state.nodes)
		end
	else
		local parent = state.nodes[#state.nodes]:parent()
		if parent then
			table.insert(state.nodes, parent)
		end
	end
	local sr, sc, er, ec = state.nodes[#state.nodes]:range()
	if er == sr and ec == sc then
		return
	end
	if ec == 0 then
		er = er - 1
		ec = #vim.api.nvim_buf_get_lines(buf, er, er + 1, false)[1]
	end
	if visual then
		vim.cmd('normal! \27')
	end
	vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
	vim.cmd('normal! v')
	vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
end
map({ 'n', 'x' }, '<leader>v', function()
	select_node(false)
end, 'Expand syntax selection')
map('x', '<leader>V', function()
	select_node(true)
end, 'Shrink syntax selection')
autocmd('BufWipeout', {
	callback = function(ev)
		selections[ev.buf] = nil
	end,
})

vim.api.nvim_create_user_command('SetupTools', function()
	local registry = require('mason-registry')
	registry.update(function(success)
		vim.schedule(function()
			if not success then
				return warn('Mason registry update failed. See :MasonLog and retry :SetupTools.')
			end
			local tools = vim.list_extend(vim.deepcopy(languages), extra_tools)
			for _, tool in ipairs(tools) do
				local executable = tool.cmd or vim.lsp.config[tool.server].cmd[1]
				local use_system = prefer_system_tools and vim.fn.executable(executable) == 1
				local found, package = pcall(registry.get_package, tool.package)
				if found and not use_system and not package:is_installing() then
					if
						not package:is_installed()
						or package:get_installed_version() ~= tool.version
					then
						package:install(
							{ version = tool.version },
							vim.schedule_wrap(function(installed)
								if installed then
									enable_servers()
								else
									warn(tool.package .. ' failed. See :MasonLog.')
								end
							end)
						)
					end
				elseif not found then
					warn('Mason package missing: ' .. tool.package)
				end
			end
			vim.cmd.Mason()
		end)
	end)
	if
		vim.fn.executable('tree-sitter') == 1
		and vim.fn.executable('curl') == 1
		and vim.fn.executable('tar') == 1
	then
		require('nvim-treesitter').install(parsers)
	else
		warn(
			'Parsers need tree-sitter CLI >= 0.26.1, curl, tar and a C compiler. Install them, then retry :SetupTools.'
		)
	end
end, { desc = 'Install pinned language tools and Treesitter parsers' })
map('n', '<leader>ps', '<cmd>SetupTools<cr>', 'Install language tools')
map('n', '<leader>pu', function()
	vim.pack.update()
end, 'Sync pinned plugins')

autocmd('VimEnter', {
	once = true,
	callback = function()
		require('which-key').setup({
			delay = 300,
			icons = { mappings = false },
			win = { border = 'rounded' },
		})
		require('which-key').add({
			{ '<leader>f', group = 'Files' },
			{ '<leader>s', group = 'Search' },
			{ '<leader>c', group = 'Code' },
			{ '<leader>d', group = 'Diagnostics' },
			{ '<leader>p', group = 'Packages' },
			{ '<leader>t', group = 'Tabs / terminal' },
			{ '<leader>g', group = 'Git' },
		})
	end,
})
