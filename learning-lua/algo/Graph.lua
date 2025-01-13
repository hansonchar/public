local Graph = {} -- Example:
local E = {}
-- local Graph = {
--   s = { egress = { ['v'] = 1, ['w'] = 4 }},
--   v = { egress = { ['t'] = 6, ['w'] = 2 }},
--   w = { egress = { ['t'] = 3 }},
-- }

local mt_vertex = {}
function mt_vertex:outgoings()
  return pairs(self.egress and self.egress or E)
end
mt_vertex.__index = mt_vertex

--- Adds a vertex u and optionally a weighted directional edge from u to v.
---@param u (string) vertex from
---@param v (string) vertex to (optional)
---@param weight (number) weight of u-v
function Graph:add(u, v, weight)
  if not self[u] then
    self[u] = setmetatable({}, mt_vertex)
  end
  self[u].egress = self[u].egress or {}
  local egress = self[u].egress
  if v then
    assert(not egress[v], string.format("Duplicate addition of %s-%s %d", u, v, weight))
    egress[v] = tonumber(weight)
    if not self[v] then -- add v as a vertex
      self[v] = setmetatable({}, mt_vertex)
    end
  end
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
---@param tostring_f (function) apply this function to u for display purposes
---@return (number) the number of edges printed
local function print_outgoings(u, vertex_u, tostring_f)
  local u_str = tostring_f and tostring_f(u) or u
  local count = 0
  for v, weight in vertex_u:outgoings() do
    local v_str = tostring_f and tostring_f(v) or v
    print(string.format("%s->%s:%d", u_str, v_str, weight))
    count = count + 1
  end
  return count
end

---@param u (string) vertex
---@param tostring_f (function) apply this function to u for display purposes
---@return (number) the number of edges dumped
function Graph:dump(u, tostring_f)
  local count = 0
  if u then
    if self[u] then
      count = count + print_outgoings(u, self[u], tostring_f)
    end
  else
    for u, vertex_u in self:vertices() do
      count = count + print_outgoings(u, vertex_u, tostring_f)
    end
  end
  return count
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
