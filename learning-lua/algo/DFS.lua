local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local DFS = GraphSearch:class()
local E = {}

local function _iterate(self)
  local stack, visited = Stack:new(), {}
  local depth = 0
  local from = self.src_vertex
  repeat
    local vertex = self.graph:vertex(from)
    depth = depth + 1
    for to, weight in vertex:outgoings() do
      if not visited[to] then
        visited[to] = true
        stack:push{to, weight, depth, from}
      end
    end
    local item = self._yield(stack:pop())
    from, depth = item[1], item[3]
  until not from -- note a cyclical path would lead to infinite iteration
end

---@param G (table) graph
---@param src (any) source vertex
function DFS:new(G, src)
  return getmetatable(self):new(G, src, _iterate)
end

return DFS
