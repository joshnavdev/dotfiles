local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#4c566a" })
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd "packadd packer.nvim"
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local plugins = require("plugins.config").plugins_init(packer_bootstrap)
local packer_config = require("plugins.config.others").packer_init()

require("packer").startup({ plugins, config = packer_config })

