local lsp = require('lsp-zero')
local autopairs = require("nvim-autopairs")
local nvim_lsp = require("lspconfig")

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I',
  }
})

lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
})

-- lsp.configure('eslint',{
--   working_directories = {"./frontend"}
-- })

lsp.configure('tsserver', {
  root_dir = nvim_lsp.util.root_pattern("package.json")
})

-- Config for no LspSaga
lsp.on_attach(function(_, bufnr)
  local opts = {buffer = bufnr, remap = false}
  local bind = vim.keymap.set
  bind('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  bind('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  bind('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  bind('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  bind('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
  bind('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
end)

lsp.setup()

autopairs.setup {}

local null_ls = require("null-ls")
local null_opts = lsp.build_options('null-ls', {})
null_ls.setup({
  on_attach = function(client, bufnr)
    null_opts.on_attach(client, bufnr)

    require "lsp-format".on_attach(client)

    if client.server_capabilities.colorProvider then
      require "document-color".buf_attach(bufnr)
    end
  end,

  -- Vue setup:
  -- prettierd - only local
  -- NextJs setup:
  -- prettierd - default
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.eslint,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.prettier.with({
      only_local = "node_modules/.bin",
      disabled_filetypes = {"vue"},
      extra_filetypes = {"astro"}
    }),
  }
})
