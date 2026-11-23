-- Neovim 0.12+. Run :SetupTools once, then reopen Neovim.
-- Tools: git, fzf, ripgrep, Node/npm, Go, curl, tar, C compiler, tree-sitter CLI >= 0.26.1.
local large_file_bytes = 1024 * 1024

-- Languages and tools installed by :SetupTools.
local languages = {
	{ server = 'pyright', package = 'pyright', parser = 'python' },
	{ server = 'ruff', package = 'ruff' },
	{ server = 'gopls', package = 'gopls', parser = 'go' },
	{ server = 'bashls', package = 'bash-language-server', parser = 'bash' },
	{
		server = 'dockerls',
		package = 'dockerfile-language-server',
		parser = 'dockerfile',
	},
	{
		server = 'docker_compose_language_service',
		package = 'docker-compose-language-service',
	},
	{ server = 'yamlls', package = 'yaml-language-server', parser = 'yaml' },
	{ server = 'jsonls', package = 'json-lsp', parser = 'json' },
	{ server = 'taplo', package = 'taplo', parser = 'toml' },
	{ server = 'lua_ls', package = 'lua-language-server', parser = 'lua' },
}
local extra_tools = {
	{ package = 'shellcheck' },
	{ package = 'shfmt' },
	{ package = 'stylua' },
	{ package = 'prettier' },
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
opt.showmode = false
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.wrap = false
opt.undofile = true
opt.clipboard = 'unnamedplus'
opt.timeoutlen = 500
opt.updatetime = 300
opt.laststatus = 3
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
opt.background = 'dark'
vim.cmd.colorscheme('default')
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
vim.diagnostic.config({ virtual_text = false, severity_sort = true })

if vim.fn.has('nvim-0.12') == 0 then
	warn('This config needs Neovim 0.12+. Core editing remains available.')
	return
end

-- Installed plugin revisions are recorded in nvim-pack-lock.json.
local plugins = {
	'https://github.com/nvim-mini/mini.statusline',
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/mason-org/mason-lspconfig.nvim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/which-key.nvim',
	'https://github.com/stevearc/conform.nvim',
	'https://github.com/ibhagwan/fzf-lua',
	'https://github.com/saghen/blink.cmp',
	'https://github.com/nvim-treesitter/nvim-treesitter',
}
local ok, err = pcall(vim.pack.add, plugins, { confirm = false })
if not ok then
	warn('Plugin installation failed. Check Git/network and restart: ' .. tostring(err))
	return
end

require('mini.statusline').setup()

-- Enter accepts only a selected completion.
local blink = require('blink.cmp')
blink.setup({
	enabled = function()
		return vim.bo.buftype ~= 'prompt' and not vim.b.large_file
	end,
	fuzzy = { implementation = 'lua' },
	keymap = {
		preset = 'default',
		['<CR>'] = { 'accept', 'fallback' },
	},
	completion = {
		list = { selection = { preselect = false, auto_insert = false } },
		documentation = { auto_show = true },
	},
	sources = {
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
	signature = { enabled = true },
})

require('mason').setup()
vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities() })
vim.lsp.config('pyright', {
	settings = {
		pyright = { disableOrganizeImports = true },
		python = {
			analysis = {
				typeCheckingMode = 'basic',
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
require('mason-lspconfig').setup({ automatic_enable = false })

local finder
local function get_finder()
	if not finder then
		finder = require('fzf-lua')
		finder.setup({
			file_icons = false,
			git_icons = false,
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
			get_finder().lsp_references()
		end, 'References')
		lmap('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
		lmap('<leader>ca', vim.lsp.buf.code_action, 'Code actions')
		lmap('<leader>cs', function()
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
vim.api.nvim_create_user_command('SetupTools', function()
	local registry = require('mason-registry')
	registry.update(function(success)
		vim.schedule(function()
			if not success then
				return warn('Mason registry update failed. See :MasonLog and retry :SetupTools.')
			end
			local tools = vim.list_extend(vim.deepcopy(languages), extra_tools)
			for _, tool in ipairs(tools) do
				local package = registry.get_package(tool.package)
				if not package:is_installed() and not package:is_installing() then
					package:install()
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
end, { desc = 'Install missing language tools and Treesitter parsers' })
map('n', '<leader>ps', '<cmd>SetupTools<cr>', 'Install language tools')
map('n', '<leader>pu', function()
	vim.pack.update()
end, 'Review plugin updates')

autocmd('VimEnter', {
	once = true,
	callback = function()
		require('which-key').setup({
			delay = 300,
			icons = { mappings = false },
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
