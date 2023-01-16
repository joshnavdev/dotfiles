local M = {}
local autocmd = vim.api.nvim_create_autocmd

M.lazy_load = function (tb)
  autocmd(tb.events, {
    group = vim.api.nvim_create_augroup(tb.augroup_name, {}),
    callback = function ()
      if tb.condition() then
        vim.api.nvim_del_augroup_by_name(tb.augroup_name)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        -- Only for treesitter
        if tb.plugin == "nvim-treesitter" then
          require("packer").loader(tb.plugin)
        end
      end
    end
  })
end

-- load certain plugins only when there's a file opened in the buffer
-- if "nvim filename" is executed -> load the plugin after nvim gui loads
-- This gives an instant preview of nvim with the file opened
M.on_file_open = function (plugin_name)
  M.lazy_load {
    events = { "BufRead", "BufWinEnter", "BufNewFile" },
    augroup_name = "BeLazyOnFileOpen" .. plugin_name,
    plugin = plugin_name,
    condition = function()
      local file = vim.fn.expand "%"
      return file ~= "NvimTree_1" and file ~= "[packer]" and file ~= ""
    end,
  }
end

return M
