local Graph = require "algo.Graph"
local GraphSearch = {} -- A common base class for DFS, BFS, etc.
-- local Queue = require "algo.Queue"
local E = {}

local function _yield(item)
  if item then
    local to, weight, depth, from = table.unpack(item)
    coroutine.yield(from, to, weight, depth, table.unpack(item, 5))
    return item
  else
    return E
  end
end

---@param src (any) optional source vertex; this takes precedence.
function GraphSearch:iterate(src)
  self._visited_count = 0
  -- self._nav = build_navigation(self)
  return coroutine.wrap(function()
    self:_iterate(src)
  end)
end

function GraphSearch:visited_count()
  return self._visited_count
end

function GraphSearch:class(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self._yield = _yield
  return o
end

---@param G (table) graph
---@param src (any) source vertex (optional)
---@param func_iterate (function) function for iteration
---@param nav_spec (table) optional navigation spec in the format of {from_1={to_1, to_2, ...}, ...} e.g. {['3']={'5','11'}, ['5']={'7','9'}}
---@param src_spec (table) optional source vertex spec in the format of {v1, v2, ...} e.g. {'1', '2', '3', ...}; applicable only if 'src' is not specified
function GraphSearch:new(G, src, func_iterate, nav_spec, src_spec)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  -- assert(src, "Missing source vertex")
  assert(not src or G:vertex(src), "Source vertex not found in graph")
  local o = GraphSearch:class{
    graph = G,
    src_vertex = src
  }
  o._iterate = func_iterate
  o._nav_spec = nav_spec or E
  o._src_spec = src_spec or E
  return o
end

return GraphSearch
