local status, themer = pcall(require, 'themer')
if (not status) then return end

themer.setup({
  transparent = false,
  styles = {
    comment = { style = 'italic' },
    keyword = { style = 'italic,bold' },
  },
  enable_installer = true,
})

vim.cmd[[highlight DiffAdd gui=none guifg=none guibg=#273732]]
vim.cmd[[highlight DiffDelete gui=none guifg=none guibg=#3f2d32]]
vim.cmd[[highlight DiffChange gui=none guifg=none guibg=#263549]]
vim.cmd[[highlight DiffText gui=none guifg=none guibg=#813c3c]]

vim.cmd[[colorscheme nordfox]]
