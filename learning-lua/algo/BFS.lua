local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Queue = require "algo.Queue"
local BFS = GraphSearch:class()
local E = {}

local TO<const>, LEVEL<const> = 2, 4

local function _iterate(self, src)
  local q, visited = Queue:new(), {
    [src] = true
  }
  self._visited_count = 1
  local level = 0
  local from = src
  repeat
    local vertex = self.graph:vertex(from)
    level = level + 1
    for to, weight in vertex:outgoings() do
      if not visited[to] then
        visited[to], self._visited_count = true, self._visited_count + 1
        q:enqueue{from, to, weight, level}
      end
    end
    local entry = (q:dequeue() or E)
    from, level = entry[TO], entry[LEVEL]
    if from then
      self._yield(entry)
    end
  until not from
end

---@param G (table) graph
function BFS:new(G, func_iterate)
  return getmetatable(self):new(G, _iterate)
end

return BFS
