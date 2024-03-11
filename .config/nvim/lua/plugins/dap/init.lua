return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = {
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "mxsdev/nvim-dap-vscode-js",
  },
  opts = function()
    local dap = require("dap")
    local mason_dap = require("mason-nvim-dap")
    local adapters = require("plugins.dap.adapters")
    local configurations = require("plugins.dap.configs")

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Debuggers                                                │
    -- ╰──────────────────────────────────────────────────────────╯
    -- We need the actual programs to connect to running instances of our code.
    -- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim
    -- The VSCode debugger requires a special adapter, seen in /lua/plugins/dap/adapters.lua
    mason_dap.setup({
      ensure_installed = { "js@v1.76.1", "node2" },
      automatic_installation = true,
    })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Adapters                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    -- Neovim needs a debug adapter with which it can communicate. Neovim can either
    -- launch the debug adapter itself, or it can attach to an existing one.
    -- To tell Neovim if it should launch a debug adapter or connect to one, and if
    -- so, how, you need to configure them via the `dap.adapters` table.
    adapters.setup(dap)

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Configuration                                            │
    -- ╰──────────────────────────────────────────────────────────╯
    -- In addition to launching (possibly) and connecting to a debug adapter, Neovim
    -- needs to instruct the adapter itself how to launch and connect to the program
    -- that you are trying to debug (the debugee).
    configurations.setup(dap)

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Keybindings + UI                                         │
    -- ╰──────────────────────────────────────────────────────────╯
    -- Doing by LazyVim
  end,
}
