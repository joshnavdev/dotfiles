local status, auto_dark_mode = pcall(require, "auto-dark-mode")
if (not status) then return end

if IS_WIN == 1 then
  return
end

local set_mode = function(mode)
  local THEME = DEFAULT_DARK_THEME

  if mode == "light" then
    THEME = DEFAULT_LIGHT_THEME
  end

  return function()
    vim.api.nvim_set_option("background", mode)
    vim.cmd("colorscheme " .. THEME)
  end
end

local set_dark_mode = set_mode('dark')
local set_light_mode = set_mode('light')

auto_dark_mode.setup({
  set_dark_mode = set_dark_mode,
  set_light_mode = set_light_mode,
})

-- auto_dark_mode.init()
