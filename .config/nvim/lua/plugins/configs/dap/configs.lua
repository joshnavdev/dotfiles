local utils_table = require("utils.table")

local js_or_ts = {
  {
    type = "node2",
    name = "Node2 Debugger - Launch",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    type = 'node2',
    name = 'Node2 Debugger - Attach',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

local chrome_debugger = {
  {
    type = "pwa-chrome",
    request = "launch",
    name = "VSCode Chrome - Launch",
    webRoot = "${workspaceFolder}/src",
    url = "http://localhost:3000",
  },
    {
    type = "pwa-chrome",
    request = "attach",
    name = "VSCode Chrome - attach",
    webRoot = "${workspaceFolder}/src",
    cwd = vim.fn.getcwd(),
    program = "${file}",
    sourceMaps = true,
    port = 9222,
  },
}

local js_or_ts_chrome = utils_table.merge(js_or_ts, chrome_debugger)

return {
  setup = function (dap)
    dap.configurations = {
      -- javascript = js_or_ts,
      javascript =  js_or_ts_chrome,
      typescript = js_or_ts,
      javascriptreact = chrome_debugger,
      vue = chrome_debugger,
    }
  end,
}
