return {
  { "nvim-pack/nvim-spectre", enabled = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = false,
      window = {
        mappings = {
          ["i"] = "open_vsplit",
          ["x"] = "open_split",
          ["o"] = "open",
        },
      },
      filesystem = {
        follow_current_file = {
          enable = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")

      opts.defaults.mappings = vim.tbl_extend("force", opts.defaults.mappings, {
        n = {
          ["q"] = actions.close,
          ["<C-i>"] = actions.select_vertical,
          ["<C-v>"] = actions.nop,
        },
        i = {
          ["<Esc>"] = actions.close,
          ["<C-i>"] = actions.select_vertical,
          ["<C-v>"] = actions.nop,
        },
      })
    end,
  },
}
