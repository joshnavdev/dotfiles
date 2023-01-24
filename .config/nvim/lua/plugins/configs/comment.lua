return {
  "terrortylor/nvim-comment",
  name = "nvim_comment",
  -- Override maps for permofance issues (no silent)
  -- TODO: Make a PR that permit silent opts
  keys = {
    { "<leader>cc", "<Cmd>set operatorfunc=CommentOperator<CR>g@l", desc = "Comment Current Line" },
    { "<leader>c", "<Cmd>set operatorfunc=CommentOperator<CR>g@", desc = "Comment Range Normal" },
    {
      "<leader>c",
      ":<C-u>call CommentOperator(visualmode())<CR>",
      mode = "x",
      silent=true,
      desc = "Comment Range Visual"
    },
  },
  opts = {
    marker_padding = true,
    create_mappings = false,
  },
}
