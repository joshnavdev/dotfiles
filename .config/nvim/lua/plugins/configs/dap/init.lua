return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "mxsdev/nvim-dap-vscode-js",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function ()
      local dap = require "dap"
      local mason_dap = require "mason-nvim-dap"
      local adapters = require "plugins.configs.dap.adapters"
      local configurations = require "plugins.configs.dap.configs"

      dap.set_log_level "TRACE"

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Debuggers                                                │
      -- ╰──────────────────────────────────────────────────────────╯
      -- We need the actual programs to connect to running instances of our code.
      -- Debuggers are installed via https://github.com/jayp0521/mason-nvim-dap.nvim
      -- The VSCode debugger requires a special adapter, seen in /lua/plugins/dap/adapters.lua
      mason_dap.setup({
        ensure_installed = { "node2", "js@v1.76.1" },
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
      local dap_icons = require("configs").icons.dap

      for name, sign in pairs(dap_icons) do
        sign = type(sign) == "table" and sign or { sign }

        vim.fn.sign_define(
          "Dap"..name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
        { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,

  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
}
