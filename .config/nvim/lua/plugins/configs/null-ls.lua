return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function ()
      local null_ls = require "null-ls"

      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      return {
        on_attach = function (current_client, bufnr)
          if current_client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function(client)
                    -- only use null-ls for formatting instead of lsp server
                    return client.name == "null-ls"
                  end,
                  bufnr = bufnr,
                })
              end,
            })
          end
        end,
        debug = true,
        sources = {
          diagnostics.eslint_d.with({
            diagnostics_format = "[#{c}] #{m} (#{s})"
          }),
          diagnostics.jsonlint,
          diagnostics.stylelint,
          formatting.stylelint,
        }
      }
    end,
  },
  {
    "MunifTanjim/prettier.nvim",
    event = "BufReadPre",
    opts = {
      bin = "prettier",
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    },
  },
}
