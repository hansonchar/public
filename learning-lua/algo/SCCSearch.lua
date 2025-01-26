local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local TopologicalSearch = require "algo.TopologicalSearch"
local DFS = require "algo.DFS"
local SCCSearch = GraphSearch:class()
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

-- Uses the Kosaraju algorithm, but uses a topological search instead of DFS for the second pass.
-- Simpler code, but arguably less "traditional" as using DFS directly.  (See SccDfsSearch.lua)
-- 1. Transpose the graph, then perform a topo search to get an array of vertexes in descending topo order.
-- 2. Transpose the graph again, then perform a topological iteration using the reversed array as the 'src_spec'.
--    A 'src_spec' is used to specify the order of source vertices to choose from whenenver
--    the search needs to restart from a different source vertex.
-- 3. We get a new SCC whenever the topological search retries from a different branch of the graph.
-- This also works, leveraging on a Topological search instead of DFS.
local function _iterate(self)
  local src_spec = {}
  local G = self.graph
  G:transpose()
  for v in TopologicalSearch:new(G):iterate() do
    src_spec[#src_spec + 1] = v
  end
  G:transpose()
  local scc_id, count = 1, 0
  local src_spec = reversed(src_spec)
  debug(table.concat(src_spec, ","))
  local topo = TopologicalSearch:new(G, nil, src_spec)
  for scc, is_first_scc in topo:iterate() do
    count = count + 1
    coroutine.yield(scc, scc_id, count)
    if is_first_scc then
      scc_id, count = scc_id + 1, 0
    end
  end
end

---@param G (table) graph
function SCCSearch:new(G)
  return getmetatable(self):new(G, _iterate)
end

return SCCSearch
