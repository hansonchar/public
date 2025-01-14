local Graph = require "algo.Graph"
local BinaryHeap = require "algo.BinaryHeap"
local DFS = {}
local E = {}

local function yield(item)
  if item then
    local to, weight, depth, from, order = table.unpack(item)
    coroutine.yield(from, to, weight, depth)
    return item
  else
    return E
  end
end

local function _iterate(dfs)
  local heap = BinaryHeap:new({}, function(a, b)
    local depth_a, depth_b = a[3], b[3]
    local order_a, order_b = a[5], b[5]
    return depth_a > depth_b or depth_a == depth_b and order_a < order_b
  end)
  local depth = 0
  local order -- ordering within the same depth
  local from = dfs.src_vertex
  repeat
    local vertex = dfs.graph:vertex(from)
    depth, order = depth + 1, 0
    for to, weight in vertex:outgoings() do
      order = order + 1
      heap:add{to, weight, depth, from, order}
    end
    local item = yield(heap:remove())
    from, depth = item[1], item[3]
  until not from -- note a cyclical path would lead to infinite iteration
end

function DFS:iterate()
  return coroutine.wrap(function()
    _iterate(self)
  end)
end

function DFS:class(o)
  setmetatable(o, self)
  self.__index = self
  return o
end

---@param G (table) graph
---@param src (any) source vertex
function DFS:new(G, src)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  assert(src, "Missing source vertex")
  assert(G:vertex(src), "Source vertex not found in graph")
  return DFS:class{
    graph = G,
    src_vertex = src
  }
end

return DFS
