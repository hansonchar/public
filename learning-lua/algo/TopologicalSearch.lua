local GraphSearch = require "algo.GraphSearch"
local DFS = require "algo.DFS"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local TopologicalSearch = GraphSearch:class()

local function debug(...)
  --   print(...)
end

--- Returns vertices in descending topological order.
---@param src (any) source vertex
local function _iterate(self, src)
  local param_src = src
  local nav_spec = self._nav_spec
  local stack, a = Stack:new(), {}
  if src then
    stack:push(src)
  end
  for from, to in DFS:new(self.graph, src, nav_spec):iterate() do
    if not src then
      debug(string.format("Topo search starting from %s", from))
      src = from
      stack:push(src)
    end
    debug(string.format("%s-%s", from, to))
    while stack:peek() ~= from do
      local node = stack:pop()
      if node then
        coroutine.yield(node)
      else -- started from a different vertex
        assert(not param_src) -- only possible if no src specified in the input parameter
        debug(string.format("Topo search starting from %s", from))
        src = from
        stack:push(src)
      end
    end
    if to then -- 'to' can be nil if 'from' is a lone starting vertex
      stack:push(to)
    end
  end
  while not stack:empty() do
    coroutine.yield(stack:pop())
  end
end

---@param G (table) graph
---@param nav_spec (table) navigation spec in the format of {from_1={to_1, to_2, ...}, ...} e.g. {3={5,11}, 5={7,9}}
function TopologicalSearch:new(G, nav_spec)
  return getmetatable(self):new(G, nil, _iterate, nav_spec)
end

return TopologicalSearch
