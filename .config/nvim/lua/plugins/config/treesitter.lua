local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  auto_install = true,
  sync_install = true,
  highlight = {
    enable = true,
    use_languaguetree = true,
  },
  indent = {
    enable = true,
  },
  ensure_installed = {
    'lua',
  },
}
