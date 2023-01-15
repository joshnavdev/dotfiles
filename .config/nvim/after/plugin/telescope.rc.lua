local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close,
        ["<C-i>"] = actions.select_vertical,
        ["<C-v>"] = actions.nop,
      },
      i = {
        ["<Esc>"] = actions.close,
        ["<C-i>"] = actions.select_vertical,
        ["<C-v>"] = actions.nop,
      },
    },
    file_ignore_patterns = { "git/", "node_modules/", "dist/" },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      grouped = true,
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      initial_mode = "normal",
      respect_gitignore = false,
      hidden = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["ma"] = fb_actions.create,
          ["mm"] = fb_actions.rename,
          ["md"] = fb_actions.remove,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
    themes = {
      theme = 'dropdown',
      initial_mode = 'normal'
    }
  },
}

telescope.load_extension("file_browser")
telescope.load_extension("themes")

vim.keymap.set('n', '<C-p>',
  function()
    builtin.find_files({
      hidden = true
    })
  end)
vim.keymap.set('n', ';r', function()
  builtin.live_grep()
end)
vim.keymap.set('n', '\\\\', function()
  builtin.buffers()
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
vim.keymap.set('n', '<Leader>th', ':Telescope themes<CR>')
vim.keymap.set("n", "<Leader>nt", function() -- nt for NerdTree (old file browser)
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    initial_mode = "normal",
    layout_config = { height = 400 }
  })
end)
