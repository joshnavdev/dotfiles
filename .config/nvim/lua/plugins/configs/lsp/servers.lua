local schemas = require("schemastore").json.schemas()


return {
  get_servers_config = function (nvim_lsp)
    return {
      ["tsserver"] = {
        root_dir = nvim_lsp.util.root_pattern("package.json"),
        single_file_support = false,
      },
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
      ["tailwindcss"] = {
        filetypes = {
          "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "twig", "css", "less", "postcss", "sass", "scss", "stylus",
        }
      },
      ["denols"] = {
        root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
      },
      ["gopls"] = {
        cmd = {"gopls", "serve"},
        filetypes = {"go", "gomod"},
        root_dir = nvim_lsp.util.root_pattern("go.work", "go.mod", ".git"),
      },
    }
  end,
}
