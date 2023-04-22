return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "BufReadPost",
  opts = {
    auto_install = true,
    sync_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
  },
  config = function (_, opts)
    -- local folders = vim.api.nvim_get_runtime_file('parser', true)

    -- for _, folder in ipairs(folders) do
      -- if not string.find(folder, "nvim%-treesitter") then
      --   print("Removing..." .. folder)
      --   os.execute("rm -rf " .. folder)
      -- end
    -- end

    require("nvim-treesitter.configs").setup(opts)
  end,
}
