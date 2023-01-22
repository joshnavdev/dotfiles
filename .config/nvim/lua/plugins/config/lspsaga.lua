local status, saga = pcall(require, 'lspsaga')
if (not status) then return end

saga.init_lsp_saga {
  finder_action_keys = {
    open = {"o", "<CR>"},
    vsplit = "<C-v>",
    split = "<C-x>",
    tabe = "<C-t>",
    quit = "q",
    -- scroll_down = "<C-f>",
    -- scroll_up = "<C-b>", -- quit can be a table
  }
}

local opts = { noremap = true, silent = true }
vim.keymap.set('n', ']g', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '[g', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
-- vim.keymap.set('i', '<C-g><C-h>', '<Cmd>Lspsaga signature_help<CR>', opts) -- remove on #456
vim.keymap.set('n', 'gp', '<Cmd>Lspsaga preview_definition<CR>', opts)
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)

