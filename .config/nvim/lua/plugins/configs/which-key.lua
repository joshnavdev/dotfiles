return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
  },
  config = function (_, opts)
    vim.o.timeout = true
    vim.o.timeoutlen = 500

    local wk = require "which-key"
    wk.setup(opts)
    wk.register({
      mode = { "n", "v" },
      ["g"] = { name = "+goto" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>t"] = { name = "+tabs" },
      ["<leader>sn"] = { name = "+noice" },
      ["<leader>u"] = { name = "+ui" },
      ["<leader>x"] = { name = "+diagnostics/quickfix" },
      ["<leader>f"] = { name = "+find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>p"] = { name = "+plenary & persistence" },
      ["<C-s>"] = { name = "+split" },
    })
  end
}
