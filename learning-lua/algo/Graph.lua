local Graph = {} -- Example:
-- local Graph = {
--   s = { egress = { ['v'] = 1, ['w'] = 4 }},
--   v = { egress = { ['t'] = 6, ['w'] = 2 }},
--   w = { egress = { ['t'] = 3 }},
-- }

local mt_vertex = {}
function mt_vertex:outgoings()
  return pairs(self.egress)
end
mt_vertex.__index = mt_vertex

--- Adds a weighted directional edge from u to v.
---@param u (string) vertex from
---@param v (string) vertex to
---@param weight (number) weight of u-v
function Graph:add(u, v, weight)
  if not self[u] then
    self[u] = {}
    setmetatable(self[u], mt_vertex)
  end
  self[u].egress = self[u].egress or {}
  local egress = self[u].egress
  assert(not egress[v], string.format("Duplicate addition of %s-%s %d", u, v, weight))
  egress[v] = weight
end

function Graph:vertices()
  return pairs(self)
end

---@param v (string)
function Graph:edges(v)
  return self[v]
end

---@param u (string)
---@param vertex_u (table)
local function print_outgoings(u, vertex_u)
  for v, weight in vertex_u:outgoings() do
    print(string.format("%s->%s:%d", u, v, weight))
  end
end

---@param u (string) vertex
function Graph:dump(u)
  if u then
    if self[u] then
      print_outgoings(u, self[u])
    end
  else
    for u, vertex_u in self:vertices() do
      print_outgoings(u, vertex_u)
    end
  end
end

function Graph.isGraph(o)
  local mt
  while true do
    mt = getmetatable(o)
    if mt == Graph then
      return true
    elseif not mt or mt == o then
      return false
    else
      o = mt -- check parent metatable
    end
  end
end

function Graph:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

return Graph
