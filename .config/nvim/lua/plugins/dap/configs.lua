local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

return {

  setup = function(dap)
    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        -- Debug on custom PORT
        {
          type = "node2",
          request = "attach",
          name = "Attach on custom PORT",
          port = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "PORT: ",
                default = "9229",
              }, function(port)
                if port == nil or port == "" then
                  return
                else
                  coroutine.resume(co, port)
                end
              end)
            end)
          end,
          restart = true,
        },
        -- Debug web application (client side)
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch & Debug Chrome",
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = "Enter URL: ",
                default = "http://localhost:3000",
              }, function(url)
                if url == nil or url == "" then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = vim.fn.getcwd(),
          protocol = "inspector",
          sourceMaps = true,
        },
        {
          name = "Next.js: debug server-side",
          type = "node-terminal",
          request = "launch",
          command = "bun run dev",
        },
      }
    end
  end,
}
