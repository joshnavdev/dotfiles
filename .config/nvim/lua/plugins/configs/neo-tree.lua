return {
  "nvim-neo-tree/neo-tree.nvim",
  cmd = "Neotree",
  version = "v2.x",
  keys = {
    {
      "<leader>fe",
      function ()
        require("neo-tree.command").execute({ toggle = true })
      end,
      desc = "Explore NeoTree (root dir)",
    },
    { "<leader>fE", "<cmd>Neotree toggle<CR>", desc = "Explorer NeoTree (cwd)" },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  init = function ()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
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
      follow_current_file = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
