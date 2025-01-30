local Graph = require "algo.Graph"
local GraphSearch = {} -- A common base class for DFS, BFS, etc.
-- local Queue = require "algo.Queue"
local E = {}

---@param entry any the entry to be yielded either in packed or unpacked format.
---@param is_packed (boolean?) true if the entry is to be yield as is without being unpacked; default is false.
---@return any entry the input entry or an empty table if the input entry is nil.
local function _yield(entry, is_packed)
  if entry then
    if is_packed then
      coroutine.yield(entry)
    else
      coroutine.yield(table.unpack(entry))
    end
    return entry
  else
    return E
  end
end

---@param src (any) optional source vertex; this takes precedence.
---@param is_include_visited (boolean) true if visited nodes are returned in addition to unvisited node.  (Currently only DFS supports this parameter.)
function GraphSearch:iterate(src, is_include_visited)
  assert(not src or self.graph:vertex(src), "Source vertex not found in graph")
  self._visited_count = 0
  -- self._nav = build_navigation(self)
  return coroutine.wrap(function ()
    self:_iterate(src, is_include_visited)
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
---@param func_iterate (function) function for iteration
---@param nav_spec (table) optional navigation spec in the format of {from_1={to_1, to_2, ...}, ...} e.g. {['3']={'5','11'}, ['5']={'7','9'}}
---@param src_spec (table) optional source vertex spec in the format of {v1, v2, ...} e.g. {'1', '2', '3', ...}; applicable only if 'src' is not specified
function GraphSearch:new(G, func_iterate, nav_spec, src_spec)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  local o = GraphSearch:class {
    graph = G
  }
  o._iterate = func_iterate
  o._nav_spec = nav_spec or E
  o._src_spec = src_spec or E
  return o
end

return GraphSearch
