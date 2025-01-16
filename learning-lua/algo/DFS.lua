local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local DFS = GraphSearch:class()
local E = {}

local function _iterate(self)
  local stack, visited = Stack:new(), {
    [self.src_vertex] = true
  }
  self._visited_count = 1
  local level = 0
  local from = self.src_vertex
  repeat
    local vertex = self.graph:vertex(from)
    level = level + 1
    for to, weight in vertex:outgoings() do
      stack:push{to, weight, level, from}
    end
    local t = (stack:pop() or E)
    from, level = t[1], t[3]
    if from and not visited[from] then
      visited[from], self._visited_count = true, self._visited_count + 1
      self._yield(t)
    end
  until not from
end

---@param G (table) graph
---@param src (any) source vertex
function DFS:new(G, src)
  return getmetatable(self):new(G, src, _iterate)
end

return DFS
