local status, nvim_lsp = pcall(require, 'lspconfig')
if (not status) then
  print('lspconfig not installed')
  return
end

local protocol = require('vim.lsp.protocol')

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = require('cmp_nvim_lsp').default_capabilities()


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end
end

nvim_lsp.tsserver.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
}

-- sumneko_lua
-- required: Install lua-language-server
nvim_lsp.sumneko_lua.setup {
  -- on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}

-- JSON
capabilities.textDocument.completion.completionItem.snippetSupport = true

local schemas = require 'schemastore'.json.schemas()

nvim_lsp.jsonls.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = schemas,
      validate = { enable = true }
    }
  }
}

-- YAML
nvim_lsp.yamlls.setup {
  capabilities,
  settings = {
    yaml = {
      schemas = schemas,
    },
  },
}

-- CSS
nvim_lsp.cssls.setup {
  -- on_attach = on_attach,
  capabilities = capabilities,
}

-- Tailwind
nvim_lsp.tailwindcss.setup {}

