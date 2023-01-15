P = function(v)
  print(vim.inspect(v))

  return v
end

HAS = function(x)
  return vim.fn.has(x)
end

IS_MAC = HAS "macunix"
IS_WIN = HAS "win32"

DEFAULT_LIGHT_THEME = "dayfox"
DEFAULT_DARK_THEME = "themer_darknight"
