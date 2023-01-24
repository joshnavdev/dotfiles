return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
    },
    config = function ()
      local nvim_lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers_config = require "plugins.configs.lsp.servers"

      for server_name, server_opts in pairs(servers_config) do
        server_opts.capabilities = capabilities
        nvim_lsp[server_name].setup(server_opts)
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
  "b0o/SchemaStore.nvim",
}
