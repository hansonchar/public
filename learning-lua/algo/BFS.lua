local Graph = require "algo.Graph"
local Queue = require "algo.Queue"
local BFS = {}
local E = {}

local function _iterate(bfs)
  local q = Queue:new()
  local level = 0
  local from = bfs.src_vertex
  repeat
    local vertex = bfs.graph:vertex(from)
    level = level + 1
    for to, weight in vertex:outgoings() do
      coroutine.yield(from, to, weight, level)
      q:enqueue{to, weight, level, from}
    end
    local item = (q:dequeue() or E)
    from, level = item[1], item[3]
  until not from -- note a cyclical path would lead to infinite iteration
end

function BFS:iterate()
  return coroutine.wrap(function()
    _iterate(self)
  end)
end

function BFS:class(o)
  setmetatable(o, self)
  self.__index = self
  return o
end

---@param G (table) graph
---@param src (any) source vertex
function BFS:new(G, src)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  assert(src, "Missing source vertex")
  assert(G:vertex(src), "Source vertex not found in graph")
  return BFS:class{
    graph = G,
    src_vertex = src
  }
end

return BFS
