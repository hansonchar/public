local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local DFS = GraphSearch:class()
local E = {}

local function _iterate(self)
  local stack, visited = Stack:new(), {}
  self._visited_count = 0
  local level, from = 0, self.src_vertex
  local t
  while from do
    if not visited[from] then
      visited[from], self._visited_count = true, self._visited_count + 1
      if t then -- t is nil only during the first iteration when we don't yet have an edge to yield
        self._yield(t)
      end
      local vertex = self.graph:vertex(from)
      level = level + 1
      for to, weight in vertex:outgoings() do
        if not visited[to] then
          stack:push{to, weight, level, from}
        end
      end
    end
    t = (stack:pop() or E)
    from, level = t[1], t[3]
  end
end

---@param G (table) graph
---@param src (any) source vertex
function DFS:new(G, src)
  return getmetatable(self):new(G, src, _iterate)
end

return DFS
