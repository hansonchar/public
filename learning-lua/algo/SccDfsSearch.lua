local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local TopologicalSearch = require "algo.TopologicalSearch"
local DFS = require "algo.DFS"
local SccDfsSearch = GraphSearch:class()
local E = {}

local function debug(...)
  -- print(...)
end

local function reversed(a)
  local j = #a
  for i = 1, #a do
    if i >= j then
      break
    end
    a[i], a[j] = a[j], a[i]
    j = j - 1
  end
  return a
end

-- Uses the Kosaraju algorithm.
-- 1. Transpose the graph, then perform a topo search to get an array of vertexes in descending topo order.
-- 2. Transpose the graph again, then perform a DFS iteration using the reversed array as the 'src_spec'.
--    A 'src_spec' is used to specify the order of source vertices to choose from whenenver
--    the search needs to restart from a different source vertex.
-- 3. We get a new SCC whenever the source vertex changes during the iteration.
local function _iterate(self)
  local src_spec = {}
  local G = self.graph
  G:transpose()
  for v in TopologicalSearch:new(G):iterate() do
    src_spec[#src_spec + 1] = v
  end
  G:transpose()
  local scc_id, count = 0, 0
  local src_spec = reversed(src_spec)
  debug(table.concat(src_spec, ","))
  local dfs = DFS:new(G, nil, nil, src_spec)
  local scc_src_vertex
  for from, to, _, _, _, _, src_vertex in dfs:iterate() do
    debug(string.format("from=%s to=%s, src_vertex=%s", from, to, src_vertex))
    if scc_src_vertex == src_vertex then -- During a DFS, but not at the first (re-)starting node.
      count = count + 1 -- We only need to yield 'to' because the 'from' must be the same
      coroutine.yield(to, scc_id, count) -- as the previous 'to' which has already been yielded.
    else -- DFS starting (ore retrying) at a new sourre node.
      assert(from == src_vertex) -- The algoritm applied here implies a new SCC.
      scc_id, count = scc_id + 1, 1 -- So we want to yield both the 'from', and 'to' if any.
      coroutine.yield(from, scc_id, count)
      scc_src_vertex = src_vertex -- src_vertex is the starting vertex of a DFS or a DFS retry.
      if to then -- If 'to' is nil, then the SCC must be a singular node.
        count = count + 1
        coroutine.yield(to, scc_id, count)
      end
    end
  end
end

---@param G (table) graph
function SccDfsSearch:new(G)
  return getmetatable(SccDfsSearch):new(G, nil, _iterate)
end

return SccDfsSearch
