local schemastore = require "schemastore"
local json_schemas = schemastore.json.schemas()
local yaml_schemas = vim.list_extend(
  {
    {
      description = 'Kubernetes Schema',
      fileMatch = { '*.k8s.yaml', '*.k8s.yml' },
      name = "k8s.json",
      url = "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json",
    },
  },
  schemastore.yaml.schemas()
)

return {
  get_servers_config = function (nvim_lsp)
    return {
      ["tsserver"] = {
        root_dir = nvim_lsp.util.root_pattern("package.json"),
        single_file_support = false,
      },
      ["lua_ls"] = {
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
            schemas = json_schemas,
            validate = { enable = true },
          },
        },
      },
      ["yamlls"] = {
        settings = {
          yaml = {
            schemas = yaml_schemas,
          }
        }
      },
      ["cssls"] = {},
      ["tailwindcss"] = {
        filetypes = {
          "haml", "handlebars", "hbs", "html", "html-eex", "heex", "jade", "leaf", "liquid", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "typescriptreact", "typescript", "javascript", "javascriptreact"
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
