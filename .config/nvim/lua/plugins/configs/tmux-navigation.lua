return {
  "alexghergh/nvim-tmux-navigation",
  event = "BufReadPost",
  opts = {
    disable_when_zoomed = true,
    keybindings = {
      left = "<C-h>",
      down = "<C-j>",
      up = "<C-k>",
      right = "<C-l>",
    },
  },

}
