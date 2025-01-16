local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Queue = require "algo.Queue"
local BFS = GraphSearch:class()
local E = {}

local function _iterate(self)
  local q, visited = Queue:new(), {
    [self.src_vertex] = true
  }
  self._visited_count = 1
  local level = 0
  local from = self.src_vertex
  repeat
    local vertex = self.graph:vertex(from)
    level = level + 1
    for to, weight in vertex:outgoings() do
      if not visited[to] then
        visited[to], self._visited_count = true, self._visited_count + 1
        q:enqueue{to, weight, level, from}
      end
    end
    local t = (q:dequeue() or E)
    from, level = t[1], t[3]
    if from then
      self._yield(t)
    end
  until not from
end

---@param G (table) graph
---@param src (any) source vertex
function BFS:new(G, src, func_iterate)
  return getmetatable(self):new(G, src, _iterate)
end

return BFS
