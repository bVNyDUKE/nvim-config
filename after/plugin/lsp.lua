local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')

require('luasnip').setup{}
require('nvim-lsp-installer').setup{}
require('lsp-format').setup{}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

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

local cmp = require'cmp'
local lspkind = require'lspkind'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help'},
    { name = 'luasnip'},
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = false,
      maxwidth = 50
    })
  }
})

vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]

local capabilities = require('cmp_nvim_lsp').update_capabilities(protocol.make_client_capabilities())

capabilities.textDocument.colorProvider = {
  dynamicRegistration = true
}

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
      null_ls.builtins.diagnostics.eslint_d.with({
        prefer_local = "node_modules/.bin",
      }),
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

local lsp_flags = {
  debounce_text_changes = 150,
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
  capabilities = capabilities,
  flags = lsp_flags,
}

nvim_lsp.intelephense.setup {
  on_attach = on_attach,
  filetypes = {"php"},
  cmd = {"intelephense", "--stdio"},
  capabilities = capabilities,
  flags = lsp_flags,
  init_options = {
    globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense'
  },
}

nvim_lsp.tailwindcss.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
}

nvim_lsp.volar.setup{
  capabilities = capabilities,
  flags = lsp_flags,
  init_options = {
     documentFeatures = {
        documentColor = false,
        documentFormatting = false,
        documentSymbol = true,
        foldingRange = true,
        linkedEditingRange = true,
        selectionRange = true
    }
  }
}


-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
  }
)

