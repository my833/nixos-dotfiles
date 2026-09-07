vim.opt.number = true
vim.opt.autochdir = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase= true
vim.opt.wrap = false
vim.opt.colorcolumn = "81"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.iskeyword:append("-")
-- vim.opt.selection = "exclusive"
vim.opt.clipboard:append("unnamedplus")

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99

vim.opt.splitbelow = true
vim.opt.splitright = true

-- vim.api.nvim_set_hl(0, "LineNr", { bg = '#3a3a3a' })
-- vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#3a3a3a' })

vim.api.nvim_create_autocmd('colorscheme', {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { bg = '#3a3a3a' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = '#3a3a3a' })
  end
})
vim.cmd("colorscheme habamax")


vim.api.nvim_create_user_command("PackAdd", function(opts)
    vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2)" })

vim.api.nvim_create_user_command("PackDel", function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	-- checks if any argument is passed
    if opts.args:match("%S") then
        -- update specific plugins
        local plugins = vim.split(opts.args, "%s+", { trimempty = true })
		-- update only specified plugins
        vim.pack.update(plugins)
    else
        -- update all
        vim.pack.update()
    end
end, { nargs = "*", desc = "Update all plugins or specific ones" })


vim.g.mapleader = " "
vim.g.maplocallader = " "

vim.keymap.set("n", "<esc><esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("n", "<leader>fc", ':e ~/.config/nvim/init.lua<cr>', { desc = "Open Nvim Init File" })

vim.keymap.set("n", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window verrtically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })


local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

--- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

--- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore last cursor positon",
  callback = function()
    if vim.o.diff then
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"')
    local last_line = vim.api.nvim_buf_line_count(0)

    local row = last_pos[1]
    if row < 1 or row > last_line then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   group = augroup,
--   -- pattern = { "markdown", "text", "gitcommit" },
--   pattern = { "markdown", "gitcommit" },
--   callback = function()
--     vim.opt_local.wrap = true
--     vim.opt_local.linebreak = true
--     vim.opt_local.spell= true
--   end,
-- })


local repoaddr = "https://gh-proxy.org/https://github.com/"

vim.pack.add({
  repoaddr .. "stevearc/oil.nvim",
  repoaddr .. "nvim-mini/mini.pairs",
  repoaddr .. "nvim-mini/mini.files",
  repoaddr .. "nvim-mini/mini.icons",
  repoaddr .. "nvim-mini/mini.surround",
  repoaddr .. "nvim-mini/mini.statusline",
  repoaddr .. "nvim-mini/mini.notify",
  repoaddr .. "nvim-mini/mini.trailspace",
  repoaddr .. "nvim-mini/mini.pick",
  repoaddr .. "nvim-mini/mini.visits",
  repoaddr .. "windwp/nvim-autopairs",
  repoaddr .. "ibhagwan/fzf-lua",
  repoaddr .. "rafamadriz/friendly-snippets",
  { src = repoaddr .. "saghen/blink.cmp", version = vim.version.range("^1"), },
  { src = repoaddr .. "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate"},
  repoaddr .. "neovim/nvim-lspconfig",
  repoaddr .. "mason-org/mason.nvim",
})

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- require("mini.pairs").setup()
require("mini.files").setup()
vim.keymap.set("n", "<leader>fe", function() MiniFiles.open() end, { desc = "MiniFiles" })
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.statusline").setup()
require("mini.notify").setup({
  content = {
    format = function(notif)
      return notif.msg
    end,
  },
})
require("mini.trailspace").setup()
require("mini.pick").setup()
require("mini.visits").setup()

require("nvim-autopairs").setup()

local make_select_path = function(select_global, recency_weight)
  local visits = require('mini.visits')
  local sort = visits.gen_sort.default({ recency_weight = recency_weight })
  local select_opts = { sort = sort }
  return function()
    local cwd = select_global and '' or vim.fn.getcwd()
    visits.select_path(cwd, select_opts)
  end
end

local map = function(lhs, desc, ...)
  vim.keymap.set('n', lhs, make_select_path(...), { desc = desc })
end

-- Adjust LHS and description to your liking
map('<Leader>fr', 'Select recent (all)',   true,  1)
map('<Leader>fR', 'Select recent (cwd)',   false, 1)


local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"vim",
		"vimdoc",
		"rust",
		"c",
		"cpp",
		"c_sharp",
		"go",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"typescript",
		"vue",
		"svelte",
		"bash",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(config.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end
setup_treesitter()

local fzflua = require("fzf-lua")
fzflua.setup()
vim.keymap.set("n", "<leader>ff", function() fzflua.files() end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function() fzflua.grep() end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function() fzflua.buffers() end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>ft", function() fzflua.help_tags() end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function() fzflua.diagnostics_document() end, { desc = "FZF Diagnostics Docuemnt" })
vim.keymap.set("n", "<leader>fX", function() fzflua.diagnostics_workspace() end, { desc = "FZF Diagnostics Workspace" })

local blinkgroup = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  group = blinkgroup,
  once = true,
  callback = function()
    require("blink.cmp").setup({
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = { documentation = { auto_show = false }},
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    })
  end,
})

vim.lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json'}, '.git' },
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" }},
      telemetry = { enable = false },
    },
  },
})
vim.lsp.config('nix_ls', {
  filetypes = { 'nix' },
  cmd = { 'nil' },
  settings = {
    formatting = {
      command = { 'nixfmt' },
    },
  },
})
vim.lsp.config['ocamllsp'] = {
  cmd = { 'ocamllsp' },
  filetypes = {
    'ocaml',
    'ocaml.interface',
    'ocaml.menhir',
    'ocaml.ocamllex',
    'dune',
    'reason',
  },
  root_markers = {
    { 'dune-project', 'dune-workspace' },
    { "*.opam", "esy.json", "package.json" },
    '.git',
  },
  settings = {},
}

-- vim.lsp.enable({
--   "lua_ls", "nix_ls", 'ocamllsp'
-- })
vim.lsp.enable('lua_ls')
vim.lsp.enable('nix_ls')

-- require("mason-lspconfig").setup({
--   servers = {
--     clangd = { mason = false },
--     gopls = { mason = false },
--     ols = { mason = false },
--     rust_analyzer = { mason = false },
--   },
-- })

require("mason").setup({
  github = {
    download_url_template = "https://gh-proxy.org/https://github.com/%s/releases/download/%s/%s",
  },
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)

	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)

	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

