local Graph = {} -- Example:
local E = {}
-- local Graph = {
--   s = { egress = { ['v'] = 1, ['w'] = 4 }},
--   v = { egress = { ['t'] = 6, ['w'] = 2 }},
--   w = { egress = { ['t'] = 3 }},
-- }

local mt_vertex = {}
mt_vertex.__index = mt_vertex

function mt_vertex:outgoings()
  local xtra_info = getmetatable(self.graph)
  if xtra_info._is_transposed then
    return pairs(self.ingress and self.ingress or E)
  else
    return pairs(self.egress and self.egress or E)
  end
end

function mt_vertex:incomings()
  local xtra_info = getmetatable(self.graph)
  if xtra_info._is_transposed then
    return pairs(self.egress and self.egress or E)
  else
    return pairs(self.ingress and self.ingress or E)
  end
end

--- Returns true if there is an outgoing edge from 'from' to 'to'.
---@param from (any) from node.
---@param to (any) to node.
function Graph:is_arc(from, to)
  local xtra_info = getmetatable(self)
  if xtra_info._is_transposed then
    return (self[from].ingress or E)[to]
  else
    return self[from].egress[to]
  end
end

--- Remove the specified node from this graph.
--- Note this method requires Graph:build_ingress() to have been invoked.
---@param node (any) the specified node to be removed
function Graph:remove(node)
  local egress = self[node].egress or E
  local ingress = self[node].ingress or E
  for v in pairs(egress) do
    self[v].ingress[node] = nil
  end
  for v in pairs(ingress) do
    self[v].egress[node] = nil
  end
  self[node] = nil
end

--- Adds a vertex u and optionally a weighted directional edge from u to v.
--- (FEATURE): Calling this method after Graph:build_ingress() would lead to undefined behavior.
---@param u (string) vertex from
---@param v (string) vertex to (optional)
---@param weight (number) weight of u-v
function Graph:add(u, v, weight)
  assert(not self:is_ingress_built(), "Currently calling this method after Graph:build_ingress() would lead to undefined behavior.")
  if not self[u] then
    self[u] = setmetatable({
      graph = self
    }, mt_vertex)
  end
  self[u].egress = self[u].egress or {}
  local egress = self[u].egress
  if v then
    assert(not egress[v], string.format("Duplicate addition of %s-%s %d", u, v, weight))
    egress[v] = tonumber(weight)
    if not self[v] then -- add v as a vertex
      self[v] = setmetatable({
        graph = self
      }, mt_vertex)
    end
  end
end

--- (FEATURE): Currently this method can be called at most once; otherwise undefined behavior.
function Graph:build_ingress()
  assert(not self:is_ingress_built(), "Currently Graph:build_ingress() can be called at most once")
  for u, u_node in pairs(self) do
    for v, weight in pairs(u_node.egress or E) do
      local v_node = self[v]
      v_node.ingress = v_node.ingress or {}
      v_node.ingress[u] = weight
    end
  end
  local xtra_info = getmetatable(self)
  xtra_info._is_ingress_built = true
  return self
end

function Graph:is_ingress_built()
  local xtra_info = getmetatable(self)
  return xtra_info._is_ingress_built
end

function Graph:vertices()
  return pairs(self)
end

function Graph:empty()
  return not next(self)
end

---@param v (string)
function Graph:vertex(v)
  return self[v]
end

---@param u (string)
---@param vertex_u (table)
---@param tostring_f (function) apply this function to u for display purposes
---@return (table) an array of all the outgoing edges of u for debugging purposes
local function outgoing_str_of(u, vertex_u, tostring_f)
  local a = {}
  local u_str = tostring_f and tostring_f(u) or u
  for v, weight in vertex_u:outgoings() do
    local v_str = tostring_f and tostring_f(v) or v
    a[#a + 1] = string.format("%s->%s:%d", u_str, v_str, weight)
  end
  return a
end

---@param u (string) vertex u or nil for all vertices
---@param tostring_f (function) apply this function to u for display purposes
---@return (string), (number) a string of all the outgoing edges (of either vertex u if specified or of all vertices otherwise) for debugging purposes, and a count of the edges.
function Graph:outgoing_str(u, tostring_f)
  local a = {}
  if u then
    if self[u] then
      local from = outgoing_str_of(u, self[u], tostring_f)
      table.move(from, 1, #from, #a + 1, a)
    end
  else
    for u, vertex_u in self:vertices() do
      local from = outgoing_str_of(u, vertex_u, tostring_f)
      table.move(from, 1, #from, #a + 1, a)
    end
  end
  return table.concat(a, ","), #a
end

local function incoming_str_of(v, vertex_v, tostring_f)
  local a = {}
  local v_str = tostring_f and tostring_f(v) or v
  for u, weight in vertex_v:incomings() do
    local u_str = tostring_f and tostring_f(u) or u
    a[#a + 1] = string.format("%s->%s:%d", u_str, v_str, weight)
  end
  return a
end

function Graph:incoming_str(v, tostring_f)
  local a = {}
  if v then
    if self[v] then
      local from = incoming_str_of(v, self[v], tostring_f)
      table.move(from, 1, #from, #a + 1, a)
    end
  else
    for v, vertex_v in self:vertices() do
      local from = incoming_str_of(v, vertex_v, tostring_f)
      table.move(from, 1, #from, #a + 1, a)
    end
  end
  return table.concat(a, ","), #a
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

function Graph:is_transposed()
  local xtra_info = getmetatable(self)
  return xtra_info._is_transposed
end

function Graph:transpose()
  if not self:is_ingress_built() then
    self:build_ingress()
  end
  local xtra_info = getmetatable(self)
  xtra_info._is_transposed = not xtra_info._is_transposed
  return not xtra_info._is_transposed -- return the old value
end

function Graph:new()
  local xtra_info = setmetatable({}, self) -- used to store graph instance specific additional info
  self.__index = self
  local o = setmetatable({}, xtra_info)
  xtra_info.__index = xtra_info
  return o
end

return Graph
