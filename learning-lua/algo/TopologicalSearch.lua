local GraphSearch = require "algo.GraphSearch"
local DFS = require "algo.DFS"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local TopologicalSearch = GraphSearch:class()

local function debug(...)
  -- print(...)
end

--- Returns vertices in descending topological order.
---@param src (any) source vertex
local function _iterate(self, src)
  local param_src = src
  local nav_spec, src_spec = self._nav_spec, self._src_spec
  local stack, a = Stack:new(), {}
  if src then
    stack:push(src)
  end
  for from, to in DFS:new(self.graph, src, nav_spec, src_spec):iterate() do
    if not src then -- This condition can be true at most once at the beginning of a topo search.
      debug(string.format("Topo search starting from %s", from))
      src = from
      stack:push(src)
    end
    debug(string.format("%s-%s", from, to))
    while stack:peek() ~= from do -- Enter the loop when the next node comes from a different branch.
      local node = stack:pop()
      if node then
        coroutine.yield(node, stack:empty())
      else -- Started from a different vertex.  This else condition is only possible if
        assert(not param_src) -- the 'src' parameter is not specified.
        debug(string.format("Topo search re-starting from %s", from))
        stack:push(from)
      end
    end -- end while.
    if to then -- 'to' can be nil if 'from' is a lone starting vertex.
      stack:push(to) -- This 'to' would be the same as the next 'from' returned from the
    end -- DFS if 'to' has any unexplored outgoing edges.
  end -- end for.
  -- At this point, the DFS has finished.
  -- Everything left on the stack are yielded in descending topological order.
  local empty = stack:empty()
  while not empty do
    local node = stack:pop()
    empty = stack:empty()
    coroutine.yield(node, empty)
  end
end

--- A topological sort or topological ordering of a directed graph is a linear ordering
--- of its vertices such that for every directed edge (u,v) from vertex u to vertex v,
--- u comes before v in the ordering.
---@param G (table) graph
---@param nav_spec (table) optional navigation spec in the format of {from_1={to_1, to_2, ...}, ...} e.g. {['3']={'5','11'}, ['5']={'7','9'}}
---@param src_spec (table) optional source vertex spec in the format of {v1, v2, ...} e.g. {'1', '2', '3', ...}; applicable only if a single source vertex is not specified
function TopologicalSearch:new(G, nav_spec, src_spec)
  return getmetatable(self):new(G, nil, _iterate, nav_spec, src_spec)
end

return TopologicalSearch
