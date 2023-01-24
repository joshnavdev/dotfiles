return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
    keys = {
      { "<leader>ps", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>pl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>pd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function ()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
          _____                      __        __    __                      _______                      
         |     \                    |  \      |  \  |  \                    |       \                     
          \$$$$$  ______    _______ | $$____  | $$\ | $$  ______  __     __ | $$$$$$$\  ______  __     __ 
            | $$ /      \  /       \| $$    \ | $$$\| $$ |      \|  \   /  \| $$  | $$ /      \|  \   /  \
       __   | $$|  $$$$$$\|  $$$$$$$| $$$$$$$\| $$$$\ $$  \$$$$$$\\$$\ /  $$| $$  | $$|  $$$$$$\\$$\ /  $$
      |  \  | $$| $$  | $$ \$$    \ | $$  | $$| $$\$$ $$ /      $$ \$$\  $$ | $$  | $$| $$    $$ \$$\  $$ 
      | $$__| $$| $$__/ $$ _\$$$$$$\| $$  | $$| $$ \$$$$|  $$$$$$$  \$$ $$  | $$__/ $$| $$$$$$$$  \$$ $$  
       \$$    $$ \$$    $$|       $$| $$  | $$| $$  \$$$ \$$    $$   \$$$   | $$    $$ \$$     \   \$$$   
        \$$$$$$   \$$$$$$  \$$$$$$$  \$$   \$$ \$$   \$$  \$$$$$$$    \$     \$$$$$$$   \$$$$$$$    \$    
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")

      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.opts.layout[1].val = 8

      return dashboard
    end,
    config = function (_, dashboard)
      vim.b.miniindentscope_disable = true
      require("alpha").setup(dashboard.opts)
    end,
  }
}
