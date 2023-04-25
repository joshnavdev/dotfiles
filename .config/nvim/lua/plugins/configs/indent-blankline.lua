return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  opts = {
    show_end_of_line = true,
    filetype_exclue = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
  },
  config = function (_, opts)
    vim.opt.list = true
    vim.opt.listchars:append "eol:↴"

    require("indent_blankline").setup(opts)
  end
}
