local Graph = require "algo.Graph"
local BinaryHeap = require "algo.BinaryHeap"
local GraphSearch = require "algo.GraphSearch"
local HeapBasedDFS = GraphSearch:class()
local E = {}

local function _iterate(self)
  local heap = BinaryHeap:new({}, function(a, b)
    local depth_a, depth_b = a[3], b[3]
    local order_a, order_b = a[5], b[5]
    return depth_a > depth_b or depth_a == depth_b and order_a < order_b
  end)
  local depth = 0
  local order -- ordering within the same depth
  local from = self.src_vertex
  repeat
    local vertex = self.graph:vertex(from)
    depth, order = depth + 1, 0
    for to, weight in vertex:outgoings() do
      order = order + 1
      heap:add{to, weight, depth, from, order}
    end
    local item = self._yield(heap:remove())
    from, depth = item[1], item[3]
  until not from -- note a cyclical path would lead to infinite iteration
end

---@param G (table) graph
---@param src (any) source vertex
function HeapBasedDFS:new(G, src)
  return getmetatable(self):new(G, src, _iterate)
end

return HeapBasedDFS
