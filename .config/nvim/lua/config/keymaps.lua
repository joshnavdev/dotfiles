-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local keymap = vim.keymap
local opts = { silent = true }

local mergeDesc = function(desc)
  return vim.tbl_extend("force", opts, { desc = desc })
end

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", mergeDesc("Select All"))

-- Save and Close
keymap.set("n", "<Leader>w", ":w<CR>", mergeDesc("Save Buffer"))
keymap.set("n", "<Leader>q", ":q<CR>", mergeDesc("Close Buffer"))

-- Split window
keymap.set("n", "<C-s><C-x>", ":split<Return><C-w>w", mergeDesc("Split Horizontal"))
keymap.set("n", "<C-s><C-i>", ":vsplit<Return><C-w>w", mergeDesc("Split Vertical"))

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><", mergeDesc("Resize Left"))
keymap.set("n", "<C-w><right>", "<C-w>>", mergeDesc("Resize Right"))
keymap.set("n", "<C-w><up>", "<C-w>+", mergeDesc("Resize Up"))
keymap.set("n", "<C-w><down>", "<C-w>-", mergeDesc("Resize Down"))

-- +tabs
keymap.set("n", "<Leader>te", ":tabedit<CR>", mergeDesc("New Table"))
keymap.set("n", "<Leader>t1", "1gt", mergeDesc("Jump Table 1"))
keymap.set("n", "<Leader>t2", "2gt", mergeDesc("Jump Table 2"))
keymap.set("n", "<Leader>t3", "3gt", mergeDesc("Jump Table 3"))
keymap.set("n", "<Leader>t4", "4gt", mergeDesc("Jump Table 4"))
keymap.set("n", "<Leader>t5", "5gt", mergeDesc("Jupm Table 5"))
keymap.set("n", "<Leader>t6", "6gt", mergeDesc("Jump Table 6"))
keymap.set("n", "<Leader>t7", "7gt", mergeDesc("Jump Table 7"))
keymap.set("n", "<Leader>t8", "8gt", mergeDesc("Jump Table 8"))
keymap.set("n", "<Leader>t9", "9gt", mergeDesc("Jump Table 9"))
keymap.set("n", "<Leader>t0", ":tablast<CR>", mergeDesc("Jump Table Last"))

-- Writing improve maps
keymap.set("i", "<C-e>", "<C-o>$")

-- Reload nvim config
keymap.set("n", "<Leader>x", ":w<CR>:source %<CR>", opts)

-- Plenary
keymap.set("n", "<leader>pt", "<Plug>PlenaryTestFile")
