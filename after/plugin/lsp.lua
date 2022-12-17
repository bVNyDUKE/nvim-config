local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'sumneko_lua',
})

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
  sources = {
    null_ls.builtins.formatting.eslint_d.with({
      only_local = "node_modules/.bin",
      filter = function(diagnostic)
        return diagnostic.code ~= "prettier/prettier"
      end,
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
      only_local = "node_modules/.bin"
    }),
  }
})
