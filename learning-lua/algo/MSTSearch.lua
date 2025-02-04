local BinaryHeap = require "algo.BinaryHeap"
local GraphSearch = require "algo.GraphSearch"
local MSTSearch = GraphSearch:class()

local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

-- Format of a heap entry: {weight, u, v}.  Note a heap reference, in contrast, has the structure:
-- { pos=(number), val=(heap entry) }
local WEIGHT <const>, U <const>, V <const> = 1, 2, 3

-- Iterates through a miminum spanning tree of a given undirected connected graph.
-- Greedily expand the MST frontier by selecting the least weight among all the nodes
-- outside but directly connected to the frontier.
-- This is basically Prim's Algorithm, optimized with a binary heap.
---@param self (table)
---@param src (string?) a source node, or default to an arbitrary node if not specified.
local function _iterate(self, src)
  -- In general, nodes that belong to the MST is put as key into 'mst' with it's from edge as the value.
  -- One exception is the source node which has itself as the value in the 'mst'.
  src = src or next(self.graph)
  -- Used to keep track of the MST with each node as the key,
  -- and each "from" node as the value.
  local mst = {[src] = src}
  local heap_ref = {} -- keep track of the heap references, with the node as the key.
  local heap = BinaryHeap:new({}, function(a_entry, b_entry)
    local a, b = a_entry[WEIGHT], b_entry[WEIGHT]
    return a <= b
  end)
  local u = src
  local u_vertex = self.graph:vertex(u)
  assert(u_vertex, "Vertex not found in graph.")
  for v, weight in u_vertex:outgoings() do
    assert(not heap_ref[v])
    heap_ref[v] = heap:add {weight, u, v}
  end
  local entry = heap:remove()
  while entry do
    local weight, u, v = table.unpack(entry)
    assert(heap_ref[v])
    heap_ref[v] = nil -- entry no longer on the heap
    if mst[v] then
      -- debugf("Discarding %s-%s: %s", u, v, weight)
    else
      mst[v] = u
      self._yield {u, v, weight}
      for w, weight in self.graph:vertex(v):outgoings() do
        if mst[w] then
        else
          local w_ref = heap_ref[w] -- Check if 'w' is currently on the heap.
          if w_ref then -- If so, we update it only if we find an edge with a lesser weight to lead to it.
            if weight < w_ref.val[WEIGHT] then
              assert(w == w_ref.val[V])
              debugf("%s - %s-%s: %s < %s-%s: %s on heap",
                w, v, w, weight, w_ref.val[U], w, w_ref.val[WEIGHT])
              heap_ref[w] = heap:update(w_ref.pos, {weight, v, w})
              -- heap:verify()
              -- heap:remove(w_ref.pos)
              -- -- heap:verify()
              -- heap_ref[w] = heap:add {weight, v, w}
              -- -- heap:verify()
            end
          else -- w not on heap
            heap_ref[w] = heap:add {weight, v, w}
          end
        end
      end -- end for
    end -- end if
    entry = heap:remove()
  end -- end while
  assert(not heap:remove())
  assert(not next(heap_ref))
end

---@param G (table) graph
function MSTSearch:new(G)
  local o = getmetatable(self):new(G, _iterate)
  return o
end

return MSTSearch
