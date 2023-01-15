vim.g.mapleader = " "

local keymap = vim.keymap

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save and Close
keymap.set('n', '<Leader>w', ':w<CR>')
keymap.set('n', '<Leader>q', ':q<CR>')

-- New tab
keymap.set('n', '<Leader>te', ':tabedit<CR>')

-- Split window
keymap.set('n', '<C-s><C-x>', ':split<Return><C-w>w')
keymap.set('n', '<C-s><C-i>', ':vsplit<Return><C-w>w')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- Move tabs
keymap.set('n', '<Leader>1', '1gt')
keymap.set('n', '<Leader>2', '2gt')
keymap.set('n', '<Leader>3', '3gt')
keymap.set('n', '<Leader>4', '4gt')
keymap.set('n', '<Leader>5', '5gt')
keymap.set('n', '<Leader>6', '6gt')
keymap.set('n', '<Leader>7', '7gt')
keymap.set('n', '<Leader>8', '8gt')
keymap.set('n', '<Leader>9', '9gt')
keymap.set('n', '<Leader>0', ':tablast<CR>')

-- Writing improve maps
keymap.set('i', '<C-e>', '<C-o>$')

-- Reload nvim config
keymap.set('n', '<Leader>x', ':w<CR>:source %<CR>')

-- Plenary
keymap.set('n', '<leader>pt', '<Plug>PlenaryTestFile')

-- Test
keymap.set("n", "<Leader>zz", ":echo test")
