return {
  { "nvim-mini/mini.surround", enabled = false },
  { "sindrets/diffview.nvim" },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "L3MON4D3/LuaSnip",
  --   },
  --   opts = function(_, opts)
  --     local luasnip = require("luasnip")
  --     local cmp = require("cmp")
  --
  --     opts.mapping = vim.tbl_extend("force", opts.mapping, {
  --       ["<Tab>"] = cmp.mapping(function(fallback)
  --         if cmp.visible() then
  --           cmp.select_next_item()
  --         elseif luasnip.expand_or_jumpable() then
  --           luasnip.expand_or_jump()
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --       ["<S-Tab>"] = cmp.mapping(function(fallback)
  --         if cmp.visible() then
  --           cmp.select_prev_item()
  --         elseif luasnip.jumpable(-1) then
  --           luasnip.jump(-1)
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --     })
  --   end,
  -- },
  {
    "nvim-mini/mini.comment",
    opts = {
      mappings = {
        comment_line = "<leader>cc",
        comment_visual = "<leader>c",
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>lg", "<Cmd>LazyGit<CR>", { desc = "LazyGit" } },
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
