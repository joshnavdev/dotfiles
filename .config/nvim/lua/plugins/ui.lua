return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {} },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {} },
    },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "slant",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { ",ti", '<Cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>', desc = "Toggle Term Vertical" },
      { ",tx", '<Cmd>exe v:count1 . "ToggleTerm direction=horizontal"<CR>', desc = "Toggle Term Horizontal" },
      { ",tf", '<Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>', desc = "Toggle Term Float" },
      { ",t", "<Cmd>ToggleTerm<CR>", mode = { "t" }, desc = "Toggle Term" },
      { "<Esc>", "<C-\\><C-n>", mode = "t", desc = "Jump Normal Moder in Term" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.api.nvim_get_option_value("lines", {}) / 2
        elseif term.direction == "vertical" then
          return vim.api.nvim_get_option_value("columns", {}) / 2
        end
      end,
    },
  },
}
