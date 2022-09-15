local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require('vim.lsp.protocol')

require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require('mason-lspconfig').setup()

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- see `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)

  -- colorizer
  if client.server_capabilities.colorProvider then
    require "document-color".buf_attach(bufnr)
  end

  -- formatting
  require "lsp-format".on_attach(client)

  --protocol.SymbolKind = { }
  protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(
  protocol.make_client_capabilities()
)

capabilities.textDocument.colorProvider = {
  dynamicRegistration = true
}

local lsp_flags = {
  debounce_text_changes = 150,
}

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.diagnostics.phpstan.with({
      prefer_local = "vendor/bin",
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      to_temp_file = false,
      timeout = 20000,
    }),
    null_ls.builtins.formatting.phpcsfixer,
  },
  diagnostics_format = "[#{s}] #{m}",
  on_attach = on_attach,
})

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
  capabilities = capabilities,
  flags = lsp_flags,
}

nvim_lsp.intelephense.setup {
  on_attach = on_attach,
  filetypes = { "php" },
  cmd = { "intelephense", "--stdio" },
  capabilities = capabilities,
  flags = lsp_flags,
  init_options = {
    globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense'
  },
}

nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.eslint_d.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
}

nvim_lsp.volar.setup {
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    volar = {
      takeOverMode = {
        enabled = true
      }
    }
  }
}

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  filetypes = { "lua" },
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
  }
)
