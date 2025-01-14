local BinaryHeap = require "algo.BinaryHeap"
local Graph = require "algo.Graph"
local Dijkstra = {}
local E = {}

---@param Q (string) optional destination vertex for finding a single shortest path; nil for all shortest paths.
function Dijkstra:shortest_paths(Q)
  local G, s, sssp = self.graph, self.starting_vertex, self.sssp
  local heap = BinaryHeap:new({}, function(a, b)
    return sssp.vertices[a].min_cost <= sssp.vertices[b].min_cost
  end)
  local u = s
  repeat
    sssp.vertices[u].ref = nil -- nullify u's heap reference as u is no longer on the heap
    if u == Q then
      break -- if we are only interested in the shortest path to Q
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

local function shortest_path_of(sssp, vertex)
  local path = {assert(vertex)}
  local from = sssp.vertices[vertex].from
  while from and from ~= vertex do
    path[#path + 1] = from
    vertex = from
    from = sssp.vertices[vertex].from
  end
  path[#path + 1] = source
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
---@param s (string) starting vertex
function Dijkstra:new(G, s)
  assert(G, "Missing Graph")
  assert(Graph.isGraph(G), "G must be a graph object")
  assert(s, "Missing starting vertex")
  assert(G:vertex(s), "Starting vertex with at least one outgoing edge not found in graph")
  return self:class{
    graph = G,
    starting_vertex = s,
    sssp = new_sssp(s)
  }
end

return Dijkstra
