return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false,
  keys = {
    { "<leader>,", "<cmd>Telescope buffers show_all_buffer=true<CR>", desc = "Switch Buffer"},
    { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Find in Files (Grep)" },
    { "<leader>:", "<cmd>Telescope command_history<CR>", desc = "Command History" },
    { "<leader><space>", "<cmd>Telescope find_files hidden=true<CR>", desc = "Find Files (root dir)" },
    -- find
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
    { "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", desc = "Find Files (root dir)" },
    -- { "<leader>fF", "<cmd> Telescope files", { cwd = false }), desc = "Find Files (cwd)" }, TODO: Make relative
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Find Recents" },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },
    -- search
    { "<leader>sa", "<cmd>Telescope autocommands<CR>", desc = "Search Auto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<CR>", desc = "Search Command History" },
    { "<leader>sC", "<cmd>Telescope commands<CR>", desc = "Search Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "Search Diagnostics" },
    { "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Search Grep (root dir)" },
    -- { "<leader>sG", "<cmd>Telescope live_grep", desc = "Search Grep (cwd)" }, TODO: Make relative
    { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Search Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<CR>", desc = "Search Highlight Groups" },
    { "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "Search Key Maps" },
    { "<leader>sM", "<cmd>Telescope man_pages<CR>", desc = "Search Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<CR>", desc = "Search and Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<CR>", desc = "Search Options" },
    { "<leader>sw", "<cmd>Telescope grep_string<CR>", desc = "Search Word (root dir)" },
    -- { "<leader>sW", "<cmd>Telescope grep_string", desc = "Search Word (cwd)" }, TODO: Make relative
    { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<CR>", desc = "Search Colorscheme with preview" },
  },
  config = function ()
    local actions = require "telescope.actions"

    require("telescope").setup({
      defaults = {
        mappings = {
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
        },
        file_ignore_patterns = { "git/", "node_modules/", "dist/" },
      }
    })
  end,
}
