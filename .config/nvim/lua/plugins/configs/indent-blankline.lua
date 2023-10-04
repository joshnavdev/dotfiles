return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  main = "ibl",
  opts = {
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" }
    }
  },
  config = function(_, opts)
    vim.opt.list = true
    vim.opt.listchars:append "eol:↴"
    require("ibl").setup(opts)
  end,
}
