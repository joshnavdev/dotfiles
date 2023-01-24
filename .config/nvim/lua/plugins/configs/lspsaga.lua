return {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    keys = {
      { "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "LSP Next Diagnostic" },
      { "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "LSP Prev Diagnostic" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "LSP Open Hover Docs" },
      { "gd", "<cmd>Lspsaga lsp_finder<CR>", desc = "LSP Go To Finders" },
      { "gr", "<cmd>Lspsaga rename<CR>", desc = "LSP Rename" },
    },
    opts = {
      finder = {
        vsplit = "i",
        split = "x",
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
}
