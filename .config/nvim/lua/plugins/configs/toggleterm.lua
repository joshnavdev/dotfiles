return {
  "akinsho/toggleterm.nvim",
  keys = {
    { ",ti", "<Cmd>exe v:count1 . \"ToggleTerm direction=vertical\"<CR>", desc = "Toggle Term Vertical" },
    { ",tx", "<Cmd>exe v:count1 . \"ToggleTerm direction=horizontal\"<CR>", desc = "Toggle Term Horizontal" },
    { ",tf", "<Cmd>exe v:count1 . \"ToggleTerm direction=float\"<CR>", desc = "Toggle Term Float" },
    { ",t", "<Cmd>ToggleTerm<CR>", mode = { "t" }, desc = "Toggle Term" },
  },
  opts = {
    size = function (term)
      if term.direction == "horizontal" then
        return vim.api.nvim_get_option("lines") / 2
      elseif term.direction == "vertical" then
        return vim.api.nvim_get_option("columns") / 2
      end
    end,
  },
}
