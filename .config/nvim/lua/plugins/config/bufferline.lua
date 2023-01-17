local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

local colors = {
  selected = {"#4c566a", "#b5b5b5"},
  no_solected = {"#2e3440", "#666666"},
  black = "#1f2124",
}

bufferline.setup({
  options = {
    mode = "tabs",
    separator_style = "slant",
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true,
  },
  highlights = {
    background = {
      bg = colors.no_solected[1],
      fg = colors.no_solected[2],
    },
    fill = {
      bg = colors.black,
    },
    buffer_selected = {
      bg = colors.selected[1],
      fg = colors.selected[2],
      italic = false
    },
    duplicate = {
      bg = colors.no_solected[1],
      fg = colors.no_solected[2],
    },
    duplicate_selected = {
      bg = colors.selected[1],
      fg = colors.selected[2],
    },
    separator = {
      bg = colors.no_solected[1],
      fg = colors.black,
    },
    separator_selected = {
      bg = colors.selected[1],
      fg = colors.black,
    },
    modified_selected = {
      bg = colors.selected[1],
    }
  }
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
