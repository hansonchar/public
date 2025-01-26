local Graph = require "algo.Graph"
local BinaryHeap = require "algo.BinaryHeap"
local GraphSearch = require "algo.GraphSearch"
local ShortestPathSearch = GraphSearch:class()
local E = {}

local FROM<const>, TO<const>, WEIGHT<const>, DEPTH<const>, COST_SO_FAR<const> = 1, 2, 3, 4, 5

local function shortest_path_of(sssp, dst)
  local path = {assert(dst)}
  local from = sssp.vertices[dst].from
  while from and from ~= dst do
    path[#path + 1] = from
    dst = from
    from = sssp.vertices[dst].from
  end
  return table.concat(path, "-"):reverse()
end

local function new_sssp(s)
  local sssp = {
    vertices = {
      [s] = {
        min_cost = 0 -- source node has min cost 0
      }
    }
  }
  setmetatable(sssp.vertices, sssp)
  setmetatable(sssp, sssp)
  sssp.__index = function(self, key)
    local default = {
      min_cost = math.huge -- default min cost to infinity
    }
    self[key] = default
    return default
  end
  sssp.shortest_path_of = shortest_path_of
  sssp.__tostring = function(self) -- to make this work, we set setmetatable(sssp, sssp) above
    local a = {}
    for v in pairs(self.vertices) do
      a[#a + 1] = string.format("%s:%d", self:shortest_path_of(v), self.vertices[v].min_cost)
    end
    return table.concat(a, ', ')
  end
  sssp.min_cost = function(self, v)
    return self.vertices[v].min_cost
  end
  return sssp
end

-- Uses Dijkstra's algorithm
local function _iterate(self, src)
  self.sssp = new_sssp(src)
  local G, sssp = self.graph, self.sssp
  local heap = BinaryHeap:new({}, function(a, b)
    local a, b = a[TO], b[TO]
    return sssp.vertices[a].min_cost <= sssp.vertices[b].min_cost
  end)
  local depth = 0
  local node = src
  repeat
    sssp.vertices[node].ref = nil -- nullify from's heap reference as from is no longer on the heap
    local vertex = self.graph:vertex(node)
    depth = depth + 1
    for to, weight in vertex:outgoings() do
      assert(weight >= 0, "Weight must not be negative")
      local v_info, v_cost_so_far = sssp.vertices[to], sssp.vertices[node].min_cost + weight
      if v_cost_so_far < v_info.min_cost then
        v_info.min_cost = v_cost_so_far
        v_info.from = node
        local v_ref = v_info.ref
        if v_ref then
          local entry = heap:remove(v_ref.pos)
          assert(entry[TO] == to, string.format("removed: %s, to: %s", entry[TO], to)) -- remove from heap if necessary before adding
        end
        v_info.ref = heap:add{node, to, weight, depth, v_cost_so_far}
      end
    end
    local item = self._yield(heap:remove())
    node, depth = item[TO], item[DEPTH]
  until not node -- note a cyclical path would lead to infinite iteration
end

--- ShortestPathSearch.lua enables graph traveral using an iterator
--- (while following the Dijkstra’s graph search strategy).
--- Notes:
--- * Dijkstra’s algorithm is simply one type of graph search strategy,
---   like BFS or DFS.
--- * Once nice property is that if a user is interested only in a specific destination node,
---   [s]he can just cut short iterating upon reaching that node! The min cost would be
---   returned in a silver plater; or so to speak. In other words, the iterator iterates
---   nodes with monotonic non-decreasing
---   shortest possible distances from the source node, in an incremental manner.
--- * No full computation on the entire graph necessary a priori.
---@param G (table) graph
---@param src (any) source vertex
function ShortestPathSearch:new(G)
  local o = getmetatable(self):new(G, _iterate)
  o.shortest_paths = function(self)
    return self.sssp
  end
  return o
end

return ShortestPathSearch
