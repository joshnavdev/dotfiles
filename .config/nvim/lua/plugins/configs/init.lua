local cmd = vim.cmd

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function ()
      cmd[[colorscheme catppuccin-frappe]]
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "windwp/nvim-autopairs", event = "BufReadPost", config = true },
}
