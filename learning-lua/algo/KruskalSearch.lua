local GraphSearch = require "algo.GraphSearch"
-- local UnionFind = require "algo.UnionFindNaive" -- this also works
local UnionFind = require "algo.UnionFind"
local KruskalSearch = GraphSearch:class()

-- local DEBUG = require "algo.Debug":new(false)
-- local debugf, debug = DEBUG.debugf, DEBUG.debug

local U <const>, V <const>, WEIGHT <const> = 1, 2, 3

local function _iterate(self)
  local uf = UnionFind:new()
  for _, edge in ipairs(self._edges) do
    local u, v, weight = table.unpack(edge)
    local u_par = uf:find(u)
    local v_par = uf:find(v)
    if u_par ~= v_par then
      self._yield {u, v, weight}
      uf:union(u, v)
    end
  end
end

---@param G (table) graph
function KruskalSearch:new(G)
  local o = getmetatable(self):new(G, _iterate)
  local edges = {}
  for u, v, weight in G:edges() do
    edges[#edges + 1] = {u, v, weight}
  end
  table.sort(edges, function(edge1, edge2)
    return edge1[WEIGHT] < edge2[WEIGHT]
  end)
  o._edges = edges
  return o
end

return KruskalSearch
