local Graph = require "algo.Graph"
local GraphSearch = {} -- A common base class for DFS, BFS, etc.
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

function GraphSearch:iterate()
  return coroutine.wrap(function()
    self:_iterate()
  end)
end

function GraphSearch:class(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self._yield = _yield
  return o
end

---@param G (table) graph
---@param src (any) source vertex
---@param func_iterate (function) function for iteration
function GraphSearch:new(G, src, func_iterate)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  assert(src, "Missing source vertex")
  assert(G:vertex(src), "Source vertex not found in graph")
  local o = GraphSearch:class{
    graph = G,
    src_vertex = src
  }
  o._iterate = func_iterate
  return o
end

return GraphSearch
