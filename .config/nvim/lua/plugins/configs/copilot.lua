return {
  "github/copilot.vim",
  event = "BufReadPre", 
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end,
}
