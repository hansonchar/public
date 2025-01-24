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
    if not src then -- this condition can be true at most once at the beginning of a topo search.
      debug(string.format("Topo search starting from %s", from))
      src = from
      stack:push(src)
    end
    debug(string.format("%s-%s", from, to))
    while stack:peek() ~= from do -- enter the loop when the next node comes from a different branch.
      local node = stack:pop()
      if node then
        coroutine.yield(node, stack:empty())
      else -- started from a different vertex
        assert(not param_src) -- only possible if no src specified in the input parameter
        debug(string.format("Topo search re-starting from %s", from))
        stack:push(from)
      end
    end
    if to then -- 'to' can be nil if 'from' is a lone starting vertex
      stack:push(to)
    end
  end
  local empty = stack:empty()
  while not empty do
    local node = stack:pop()
    empty = stack:empty()
    coroutine.yield(node, empty)
  end
end

---@param G (table) graph
---@param nav_spec (table) optional navigation spec in the format of {from_1={to_1, to_2, ...}, ...} e.g. {['3']={'5','11'}, ['5']={'7','9'}}
---@param src_spec (table) optional source vertex spec in the format of {v1, v2, ...} e.g. {'1', '2', '3', ...}; applicable only if a single source vertex is not specified
function TopologicalSearch:new(G, nav_spec, src_spec)
  return getmetatable(self):new(G, nil, _iterate, nav_spec, src_spec)
end

return TopologicalSearch
