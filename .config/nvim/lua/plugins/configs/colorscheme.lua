local set_colorscheme_by_background = function (background)
  local theme = DEFAULT_DARK_THEME

  if background == "light" then
    theme = DEFAULT_LIGHT_THEME
  end

  vim.cmd("colorscheme " .. theme)
end

local is_day = function ()
  local local_hour = os.date("*t").hour

  return local_hour > 8 and local_hour < 16
end

local set_colorscheme = function ()
  local period = "dark"

  if is_day() then
    period = "light"
  end

  vim.opt.background = period
  set_colorscheme_by_background(period)
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function ()
      set_colorscheme()
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function ()
      set_colorscheme()
    end

  }
}
