local dap_vscode_ok, dap_vscode = pcall(require, "dap-vscode-js")
if not (dap_vscode_ok) then
  vim.api.nvim_err_writeln("dap-vscode-js not installed!")
  return
end

local mason_folder = vim.fn.stdpath("data") .. "/mason"

return {
  setup = function (dap)
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { mason_folder .. "/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }

    -- The VSCode Debugger requires a special setup
    P( mason_folder .. "/packages/js-debug-adapter")
    dap_vscode.setup({
      adapters = { "pwa-node", "pwa-chrome" },
      debugger_path = mason_folder .. "/packages/js-debug-adapter", -- Path to VSCode Debugger
      log_file_level = 1,
    })
  end
}
