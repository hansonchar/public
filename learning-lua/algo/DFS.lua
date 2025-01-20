local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local DFS = GraphSearch:class()
local E = {}

--- Push all unvisited outgoing edges to the stack.
---@param self (table) the current DFS instance
---@param from (any) from node
---@param level (number) the number of hops from the source node
---@param stack (table) the stack to push edges to
---@param visited (table) used to check if a node has been visited
---@return (number) the number of unvisited outoing edges pushed to the stack
---@return (number) the number of unvisited outoing edges already visited
local function push_edges(self, from, level, stack, visited)
  local vertex, count_unvisited, count_visited = self.graph:vertex(from), 0, 0
  for to, weight in vertex:outgoings() do
    if visited[to] then
      count_visited = count_visited + 1
    else
      stack:push{to, weight, level, from}
      count_unvisited = count_unvisited + 1
    end
  end
  return count_unvisited, count_visited
end

local function _iterate(self)
  local stack, visited = Stack:new(), {}
  self._visited_count = 0
  local level, from = 0, self.src_vertex
  local t
  while from do
    if not visited[from] then
      visited[from], self._visited_count = true, self._visited_count + 1
      local vertex = self.graph:vertex(from)
      level = level + 1
      local count_unvisited, count_visited = push_edges(self, from, level, stack, visited)
      if t then -- t is nil only during the first iteration when we are starting with the source node.
        t[#t + 1] = count_unvisited -- append the number of unvisited outgoing edges.
        t[#t + 1] = count_visited -- append the number of visited outgoing edges.
        self._yield(t)
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
