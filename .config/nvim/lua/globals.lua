P = function(v)
  print(vim.inspect(v))

  return v
end

HAS = function(x)
  return vim.fn.has(x)
end

IS_MAC = HAS "macunix"
IS_WIN = HAS "win32"
IS_LIN = HAS "unix"

DEFAULT_LIGHT_THEME = "nordfox"
DEFAULT_DARK_THEME = "nordfox"
