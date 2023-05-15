return {
  "glepnir/lspsaga.nvim",
  event = "BufRead",
  branch = "def",
  keys = {
    { "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "LSP Next Diagnostic" },
    { "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "LSP Prev Diagnostic" },
    { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "LSP Open Hover Docs" },
    { "gd", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Go To Finders" },
    { "gD", "<cmd>Lspsaga goto_definition<CR>", desc = "LSP Go To Definition" },
    { "gr", "<cmd>Lspsaga rename<CR>", desc = "LSP Rename" },
    {
      "]G",
      function ()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "LSP Next Error Diagnostic"
    },
    {
      "[G",
      function ()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "LSP Prev Error Diagnostic"
    },
  },
  opts = {
    finder = {
      keys = {
        vsplit = "i",
        split = "x",
      },
    },
    diagnostic = {
      show_code_action = false,
    },
    ui = {
      -- currently only round theme
      theme = 'round',
      -- this option only work in neovim 0.9
      title = false,
      -- border type can be single,double,rounded,solid,shadow.
      border = 'single',
      winblend = 0,
      expand = '',
      collapse = '',
      preview = ' ',
      code_action = '💡',
      diagnostic = '🐞',
      incoming = ' ',
      outgoing = ' ',
      kind = {},
    },
  },
  config = function (_, opts)
    -- vim.cmd[[hi! default link SagaBorder NormalFloat]]
    -- vim.cmd[[hi! default link SagaNormal NormalFloat]]

    require("lspsaga").setup(opts)
  end
}
