local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Queue = require "algo.Queue"
local BFS = GraphSearch:class()
local E = {}

local function _iterate(self)
  local q, visited = Queue:new(), {}
  local level = 0
  local from = self.src_vertex
  repeat
    local vertex = self.graph:vertex(from)
    level = level + 1
    for to, weight in vertex:outgoings() do
      if not visited[to] then
        visited[to] = true
        coroutine.yield(from, to, weight, level)
        q:enqueue{to, weight, level, from}
      end
    end
    local item = (q:dequeue() or E)
    from, level = item[1], item[3]
  until not from -- note a cyclical path would lead to infinite iteration
end

---@param G (table) graph
---@param src (any) source vertex
function BFS:new(G, src, func_iterate)
  return getmetatable(self):new(G, src, _iterate)
end

return BFS
