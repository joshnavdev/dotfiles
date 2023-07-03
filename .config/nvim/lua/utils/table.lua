local M = {}

M.merge = function (t1, t2)
  local table_merged = {}
  
  for k,v in pairs(t2) do t1[k] = v end
end

local t1 = {{"joshua"}}
local t2 = {{"navarro"}}
P(M.merge(t1,t2))
P(t1)
P(t2)

return M
