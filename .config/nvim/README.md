# Neo Vim dotfile

## NeoVim base configuration using Lua

### Contains

- init.lua configuration with "macos" or "win32" configurations
- lua/base.lua configuration with the vim standard configurations
- lua/highlighths.lua conf with some configuration to the theme
- lua/maps.lua conf with the base maps configurations
- lua/plugins.lua conf with the initial plugin to stetic perfomance (not include LSP and relates)
  - wbthomason/packer.nvim
  - svrana/neosolarized.nvim: Theme
  - kyazdani42/nvim-web-devicons: File icons
  - hoob3rt/lualine.nvim: Statusline
  - windwp/nvim-autopairs: Autocomplete pairs
  - windwp/nvim-ts-autotag: Autocomplete tags
  - nvim-lua/plenary.nvim: Require dependency for telescope
  - nvim-telescope/telescope.nvim: Telesco for searching
  - nvim-telescope/telescope-file-browser.nvim: telescope for browser files
  - akinsho/nvim-bufferline.lua: improve ui of the bufferline
  - lewis6991/gitsigns.nvim: Ui for change on git
  - dinhhuy258/git.nvim: fork git blame & browser
  - tpope/vim-fugitive: Git commands on buffer
  - terrortylor/nvim-comment: Commenter
  - alexghergh/nvim-tmux-navigation: Navigate between windows

### Setting up

- You only have to clone this repo into ~/.config/nvim/ folder and run PackerSync the first time to enter to NeoVim.
- You must install [eslint_d](https://github.com/mantoni/eslint_d.js/) and [prettierd](https://github.com/fsouza/prettierd) dependencies globally.

