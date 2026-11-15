-- Colorscheme of the active theme (tools/theme.sh set <name>), kanagawa-wave by default
local function active_colorscheme()
  local env_file = vim.fn.expand("~/.config/dotfiles/theme/theme.env")
  if vim.fn.filereadable(env_file) == 1 then
    for _, line in ipairs(vim.fn.readfile(env_file)) do
      local name = line:match('^NVIM_COLORSCHEME="?([%w%-_]+)"?')
      if name then
        return name
      end
    end
  end
  return "kanagawa-wave"
end

return {
  { "EdenEast/nightfox.nvim" }, -- lazy
  { "oxfist/night-owl.nvim" },
  { "rose-pine/neovim" },
  { "rebelot/kanagawa.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = active_colorscheme(),
    },
  },
}
