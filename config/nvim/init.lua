-- plugins
local repoaddr = "https://gh-proxy.org/https://github.com/"
vim.pack.add({
  repoaddr .. 'nvim-mini/mini.pairs',
  repoaddr .. 'nvim-mini/mini.surround',
  repoaddr .. 'nvim-mini/mini.pick',
  repoaddr .. 'nvim-mini/mini.icons',
  repoaddr .. 'nvim-mini/mini.trailspace',
  repoaddr .. 'stevearc/oil.nvim',
  repoaddr .. 'ibhagwan/fzf-lua',
  repoaddr .. 'rafamadriz/friendly-snippets',
  repoaddr .. 'neovim/nvim-lspconfig',
  { src = repoaddr .. 'saghen/blink.cmp',                version = vim.version.range("^1"), },
  { src = repoaddr .. 'nvim-treesitter/nvim-treesitter', branch = 'main',                   build = ":TSUpdate", },
})

require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.pick').setup()
require('mini.icons').setup()
require('mini.trailspace').setup()
require('oil').setup()

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

local fzflua = require('fzf-lua')
fzflua.setup()
vim.keymap.set('n', '<leader>ff', function() fzflua.files() end)
vim.keymap.set('n', '<leader>fb', function() fzflua.buffers() end)
vim.keymap.set('n', '<leader>fg', function() fzflua.grep() end)

local blinkgroup = vim.api.nvim_create_augroup('BlinkCmpLazyLoad', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  group = blinkgroup,
  once = true,
  callback = function()
    require('blink.cmp').setup({
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false } },
      signature = { enabled = true },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' }, },
      fuzzy = { implementation = 'prefer_rust_with_warning' }
    })
  end,
})

vim.lsp.config['*'] = {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  root_markers = { '.git' },
}
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
    stylel = 'minimal',
    border = 'rounded',
    source = 'if_many',
    hader = '',
    prefix = '',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN]  = '▲',
      [vim.diagnostic.severity.HINT]  = '⚑',
      [vim.diagnostic.severity.INFO]  = '»',
    },
  },
})

local orig = vim.lsp.util.open_floating_preview
--@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 24
  opts.wrap = opts.wrap ~= false
  return orig(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf
    local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

    map('n', 'K', vim.lsp.buf.hover)
    map('n', 'gd', vim.lsp.buf.definition)
    map('n', 'gD', vim.lsp.buf.declaration)
    map('n', 'gi', vim.lsp.buf.implementation)
    map('n', 'go', vim.lsp.buf.type_definition)
    map('n', 'gr', vim.lsp.buf.references)
    map('n', 'gs', vim.lsp.buf.signature_help)
    map('n', 'gl', vim.diagnostic.open_float)
    map('n', '<F2>', vim.lsp.buf.rename)
    map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
    map('n', '<F4>', vim.lsp.buf.code_action)

    local excluded_filetype = { php = true }

    -- auto-format on save (only if server can't do WillSaveWaitUntil)
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting')
        and not excluded_filetype[vim.bo[buf].filetype]
    then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
        buffer = buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
        end
      })
    end
  end
})

vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetype = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.config['nil_ls'] = {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', 'default.nix', '.git' },
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixpkgs-fmt' },
      }
    }
  }
}
vim.lsp.enable('lua_ls')
vim.lsp.enable('nil_ls')

-- custom options
local set = vim.opt
set.number = true
set.smartindent = true
set.expandtab = true
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.ignorecase = true
set.smartcase = true
set.cursorline = true
set.colorcolumn = "100"
set.splitbelow = true
set.splitbelow = true
set.iskeyword:append("-")
set.scrolloff = 8
set.swapfile = false
set.backup = false
set.incsearch = true
set.clipboard:append("unnamedplus")
vim.cmd("colorscheme habamax")

-- keybinds
vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move line up

vim.keymap.set('n', 'J', "mzJ`z")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set("n", "<esc><esc>", ":noh<cr>")

vim.keymap.set("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>")
vim.keymap.set('n', '<leadder>x', "<cmd>!chmdo +x %<cr>", { silent = true })

vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'x' }, '<leader>d', [["_d]])

-- quickfix list
vim.keymap.set('n', '<C-j>', '<cmd>cnext<cr>zz')
vim.keymap.set('n', '<C-k>', '<cmd>cprev<cr>zz')
vim.keymap.set('n', '<leader>cl', ':cclose<cr>', { silent = true })
vim.keymap.set('n', '<leader>co', ':copen<cr>', { silent = true })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>zz')
vim.keymap.set('n', '<leader>cp', ':cprev<cr>zz')
vim.keymap.set('n', '<leader>li', ':checkhealth vim.lsp<cr>', { desc = "LSP  Info" })
