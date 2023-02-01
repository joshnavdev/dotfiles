-- TODO: When open a file directly most of the needed plugins aren't loaded_cmp
-- example: nvim index.js - not use autopairs, lsp, treesiter
-- but only when ins a new file, if the file exists this doesn't happend
return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "windwp/nvim-autopairs", event = "BufReadPost", config = true },
  { "windwp/nvim-ts-autotag", event = "BufReadPost", config = true },
}
