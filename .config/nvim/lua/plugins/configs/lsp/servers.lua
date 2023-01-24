local schemas = require("schemastore").json.schemas()

return {
  ["tsserver"] = {},
  ["sumneko_lua"] = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  },
  ["jsonls"] = {
    settings = {
      json = {
        schemas = schemas,
        validate = { enable = true },
      },
    },
  },
  ["yamlls"] = {
    settings = {
      yaml = {
        schemas = schemas,
      }
    }
  },
  ["cssls"] = {},
  ["tailwindcss"] = {},
}
