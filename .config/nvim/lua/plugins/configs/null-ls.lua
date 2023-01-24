return {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  dependencies = { "mason.nvim" },
  opts = function ()
    local null_ls = require "null-ls"

    return {
      on_attach = function (client, _)
        if client.server_capabilities.documentFormattingProvider then
          local group = vim.api.nvim_create_augroup("Format", {})
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = 0,
            callback = function ()
              vim.lsp.buf.format()
            end,
          })
        end
      end,
      debug = true,
      sources = {
        null_ls.builtins.diagnostics.eslint_d.with({
          diagnostics_format = "[#{c}] #{m} (#{s})"
        }),
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.formatting.stylelint,
        null_ls.builtins.formatting.prettierd,
      }
    }
  end,
}
