local lsp = require('lsp-zero')
local nvim_lsp = require('lspconfig')

require('mini.pairs').setup()

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
})

lsp.configure('tailwindcss', {
  root_dir = nvim_lsp.util.root_pattern("tailwind.config.*")
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I',
  },
  set_lsp_keymaps = false
})

lsp.configure('intelephense', {
  init_options = {
    globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense'
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

lsp.configure('tsserver', {
  root_dir = nvim_lsp.util.root_pattern("package.json")
})

lsp.configure('denols', {
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
})

lsp.configure('svelte', {
  settings = {
    Svelte = {
      ['enable-ts-plugin'] = false
    }
  }
})

-- No LspSaga config
lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({bufnr = bufnr})
  local opts = {buffer = bufnr, remap = false}
  local bind = vim.keymap.set
  bind('n', ']g', vim.diagnostic.goto_next, opts)
  bind('n', '[g', vim.diagnostic.goto_prev, opts)
  bind('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  bind('n', '<leader>vr', vim.lsp.buf.references, opts)
  bind('n', 'K', vim.lsp.buf.hover, opts)
  bind('n', 'gR',vim.lsp.buf.rename, opts)
  bind('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
end)

lsp.setup()

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
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.mypy.with({
      extra_args = {"--python-executable", "./env/bin/python"}
    }),
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.eslint.with({
      prefer_local = "node_modules/.bin",
      extra_filetypes = {"astro", "svelte"}
    }),
    null_ls.builtins.formatting.eslint.with({
      prefer_local = "node_modules/.bin",
      extra_filetypes = {"astro", "svelte"}
    }),
    null_ls.builtins.code_actions.eslint.with({
      prefer_local = "node_modules/.bin",
      extra_filetypes = {"astro", "svelte"}
    }),
    null_ls.builtins.formatting.black.with({
      only_local = "env/bin"
    }),
    null_ls.builtins.diagnostics.phpstan.with({
      prefer_local = "vendor/bin",
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      to_temp_file = false,
      timeout = 20000,
      diagnostic_config = {
        virtual_text = false,
        underline = true,
        signs = true,
        update_in_insert = false,
        severity_sort = false,
      },
    }),
    null_ls.builtins.formatting.phpcsfixer,
    null_ls.builtins.formatting.prettier.with({
      disabled_filetypes = {"vue"},
      extra_filetypes = {"astro", "svelte"}
    }),
    null_ls.builtins.formatting.rustfmt,
  }
})

vim.cmd([[
  command! -range=% Pfmt <line1>,<line2>!npx prettier --stdin-filepath %
]])

-- Turn off semantic highlighting
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     client.server_capabilities.semanticTokensProvider = nil
--   end
-- })
