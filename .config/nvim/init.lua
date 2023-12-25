-- bootstrap lazy.nvim, LazyVim and your plugins
P = function(v)
  print(vim.inspect(v))

  return v
end

require("config.lazy")
