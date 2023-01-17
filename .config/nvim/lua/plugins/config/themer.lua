local status, themer = pcall(require, "themer")
if (not status) then return end

themer.setup({
  transparent = false,
  styles = {
    comment = { style = "italic" },
    keyword = { style = "italic,bold" },
  },
  enable_installer = true,
})

-- Configure aweson initial theme - nordfont
local cmd = vim.cmd
local fn = vim.fn
local themer_install_path = fn.stdpath("data").."/themer/nightfox.nvim"
local group_name = "ThemerInit"

vim.api.nvim_create_autocmd("ChanOpen", {
  group = vim.api.nvim_create_augroup(group_name, {}),
  callback = function ()
    local chans = vim.api.nvim_list_chans()
    local themer_job_id

    for _, value in ipairs(chans) do
      if value.stream == "job" then
        themer_job_id = value.id
      end
    end

    fn.jobwait({themer_job_id})
    cmd[[colorscheme nordfox]]
    vim.api.nvim_del_augroup_by_name(group_name)
  end,
  once = true
})

if fn.empty(fn.glob(themer_install_path)) > 0 then
  local themer_installer_utils = require "themer.modules.installer.utils"
  local nightfox_theme = "EdenEast/nightfox.nvim"

  themer_installer_utils.install(nightfox_theme)
else
  cmd[[colorscheme nordfox]]
end

cmd[[highlight DiffAdd gui=none guifg=none guibg=#273732]]
cmd[[highlight DiffDelete gui=none guifg=none guibg=#3f2d32]]
cmd[[highlight DiffChange gui=none guifg=none guibg=#263549]]
cmd[[highlight DiffText gui=none guifg=none guibg=#813c3c]]


