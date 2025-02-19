-- Use a quick and dirty tree based approach.
-- See 15.6.4 Quick-and-Dirty Implementation of Union-Find
-- in Algorithm Illuminated Part 3 by Tim Roughgarden

local UnionFind = {}
UnionFind.__index = UnionFind

---Returns the root node for the given label.
---@param x (any) the given label.
---@return (table)
function UnionFind:find(x)
  -- Only the root node contains a parent the same as the key itself.
  self[x] = self[x] or {parent = x, size = 1}
  local node = self[x]
  while node.parent ~= x do
    x = node.parent
    node = self[x]
  end
  return node
end

function UnionFind:union(x, y)
  local x_root = self:find(x)
  local y_root = self:find(y)
  if x_root.size < y_root.size then
    x_root.parent = y_root.parent
    y_root.size = y_root.size + x_root.size
    x_root.size = nil
  else
    y_root.parent = x_root.parent
    x_root.size = x_root.size + y_root.size
    y_root.size = nil
  end
end

function UnionFind:new()
  return setmetatable({}, self)
end

return UnionFind
