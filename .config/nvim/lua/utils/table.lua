local M = {}

M.clone = function (tb)
  return {table.unpack(tb)}
end

M.merge = function (t1, t2)
  local table_merged = {}

  for _,v in pairs(t1) do
    table.insert(table_merged, v)
  end

  for _, v in pairs(t2) do
    table.insert(table_merged, v)
  end

  return table_merged
end

return M
