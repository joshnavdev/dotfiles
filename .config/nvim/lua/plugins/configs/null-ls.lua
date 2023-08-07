-- TODO: Make a way to find config in package.json on node env
local eslint_filetypes = { "js", "cjs", "yaml", "yml", "json" }
local deno_filetypes = { "json", "jsonc" }
local stylelint_filetypes = { "", ".cjs", ".json", ".yaml", ".yml" }

local get_config_files = function (filetypes, source_rc)
  local config_files = {}

  for _, filetype in ipairs(filetypes) do
    table.insert(config_files, source_rc .. filetype)
  end

  return config_files
end

return {
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = true,
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
        debug = false,
        sources = {
          diagnostics.eslint_d.with({
            diagnostics_format = "[#{c}] #{m} (#{s})",
            condition = function (utils)
              local eslint_config_files = get_config_files(eslint_filetypes, ".eslintrc.")
              return utils.root_has_file(eslint_config_files)
            end,
          }),
          diagnostics.jsonlint,
          diagnostics.stylelint.with({
            condition = function (utils)
              local stylelint_config_files = get_config_files(stylelint_filetypes, ".stylelintrc")
              return utils.root_has_file(stylelint_config_files)
            end,
          }),
          formatting.stylelint,
          formatting.deno_fmt.with({
            condition = function (utils)
              local deno_config_files = get_config_files(deno_filetypes, "deno.")
              return utils.root_has_file(deno_config_files)
            end,
          })
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
        -- "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        -- "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    },
  },
}
