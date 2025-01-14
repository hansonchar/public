local BinaryHeap = require "algo.BinaryHeap"
local Graph = require "algo.Graph"
local Dijkstra = {}
local E = {}

---@param dst (any) optional destination vertex for finding a single shortest path; nil for all shortest paths.
function Dijkstra:shortest_paths(dst)
  local G, s, sssp = self.graph, self.src_vertex, self.sssp
  local heap = BinaryHeap:new({}, function(a, b)
    return sssp.vertices[a].min_cost <= sssp.vertices[b].min_cost
  end)
  local u = s
  repeat
    sssp.vertices[u].ref = nil -- nullify u's heap reference as u is no longer on the heap
    if u == dst then
      break -- if we are only interested in the shortest path to dst
    end
    local vertex = G:vertex(u)
    if vertex then
      for v, weight in vertex:outgoings() do
        assert(weight >= 0, "Weight must not be negative")
        local v_info, v_cost_so_far = sssp.vertices[v], sssp.vertices[u].min_cost + weight
        if v_cost_so_far < v_info.min_cost then
          v_info.min_cost = v_cost_so_far
          v_info.from = u
          local v_ref = v_info.ref
          if v_ref then
            assert(heap:remove(v_ref.pos) == v) -- remove from heap if necessary before adding
          end
          v_info.ref = heap:add(v)
        end
      end
    end
    u = heap:remove() -- extract the next vertex (with the shortest path from s) into u
  until not u
  return sssp
end

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

local function dump(sssp)
  for v in pairs(sssp.vertices) do
    print(string.format("%d: %s", sssp.vertices[v].min_cost, sssp:shortest_path_of(v)))
  end
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
  sssp.__index = function(self, key)
    local default = {
      min_cost = math.huge -- default min cost to infinity
    }
    self[key] = default
    return default
  end
  sssp.shortest_path_of = shortest_path_of
  sssp.dump = dump
  sssp.min_cost = function(self, v)
    return self.vertices[v].min_cost
  end
  return sssp
end

function Dijkstra:class(o)
  setmetatable(o, self)
  self.__index = self
  return o
end

---@param G (table) graph
---@param src (any) source vertex
function Dijkstra:new(G, src)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  assert(src, "Missing source vertex")
  assert(G:vertex(src), "Source vertex not found in graph")
  return self:class{
    graph = G,
    src_vertex = src,
    sssp = new_sssp(src)
  }
end

return Dijkstra
