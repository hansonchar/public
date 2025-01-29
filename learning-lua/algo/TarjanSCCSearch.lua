local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local TarjanSCCSearch = GraphSearch:class()
local E = {}

local function debug(...)
  -- print(...)
end

local function node_info(node, info)
  info[node] = info[node] or {
    label = node
  }
  return info[node]
end

local function strongconnect(v, index, stack, G, info)
  v.index, v.lowlink = index, index
  index = index + 1
  stack:push(v)
  v.onStack = true
  for node in G:vertex(v.label):outgoings() do
    local w = node_info(node, info)
    if not w.index then
      index = strongconnect(w, index, stack, G, info)
      v.lowlink = v.lowlink < w.lowlink and v.lowlink or w.lowlink
    elseif w.onStack then
      v.lowlink = v.lowlink < w.index and v.lowlink or w.index
    end
  end

  local w
  if v.lowlink == v.index then
    local count = 0
    repeat
      w = stack:pop()
      w.onStack = false
      count = count + 1
      coroutine.yield(w.label, v.lowlink, count)
    until w == v
  end
  return index
end

-- https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm
--
-- Depth-First Search and Linear Graph Algorithms by Robert Tarjan:
-- https://github.com/tpn/pdfs/blob/master/Depth-First%20Search%20and%20Linear%20Graph%20Algorithms%20-%20Tarjan%20(1972).pdf
local function _iterate(self)
  local info = {}
  local G = self.graph
  local index = 1
  local stack = Stack:new()
  for node in G:vertices() do
    local v = node_info(node, info)
    if not v.index then
      index = strongconnect(v, index, stack, G, info)
    end
  end
end

---@param G (table) graph
function TarjanSCCSearch:new(G)
  return getmetatable(self):new(G, _iterate)
end

return TarjanSCCSearch
