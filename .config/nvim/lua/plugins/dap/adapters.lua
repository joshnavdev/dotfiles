local dap_vscode_ok, dap_vscode = pcall(require, "dap-vscode-js")
if not dap_vscode_ok then
  vim.api.nvim_err_writeln("dap-vscode-js not installed!")
end

local mason_folder = vim.fn.stdpath("data") .. "/mason"

-- Register adapters for nvim-dap
return {
  setup = function(dap)
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { mason_folder .. "/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }

    -- Registry adapters for Typescript using dap-vscode-js
    require("dap-vscode-js").setup({
      -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
      debugger_path = mason_folder .. "/packages/js-debug-adapter", -- Path to vscode-js-debug installation.
      -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
      log_file_path = "/Users/joshua.navarro/tmp/daplogs.txt", -- Path for file logging
      log_file_level = 1, -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })
  end,
}
