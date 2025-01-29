local GraphSearch = require "algo.GraphSearch"
local Stack = require "algo.Stack"
local DFS = GraphSearch:class()
local E = {}

-- Element index of a stack entry with the format: {from, to, weight, depth, count_unvisited, begin_vertex, is_visited}
-- local FROM <const> = 1
local TO <const> = 2
-- local WEIGHT <const> = 3
local DEPTH <const>, UNVISITED <const>, BEGIN_VERTEX <const>, IS_VISITED <const> = 4, 5, 6, 7

local function debug(...)
  -- print(...)
end

--- Push all unvisited outgoing edges to the stack.
---@param self (table) the current DFS instance
---@param from (any) from node
---@param level (number) the number of hops from the source node
---@param stack (table) the stack to push edges to
---@param visited_hist (table) used to check if a node has been visited
---@param is_include_visited (boolean) true to include the edges already visited.
--- These visited edges are called "fronds".
--- (See Depth-First Search and Linear Graph Algorithms by Robert Tarjan.)
---@return (number) the number of unvisited outgoing edges pushed to the stack
---@return (number) the number of stack pushes
local function push_edges(self, from, level, stack, visited_hist, is_include_visited)
  local vertex, count_unvisited = self.graph:vertex(from), 0
  local visits_first = {} -- used to record vertices already taken care of via preferrential navigation
  local preferred_nav_order = self._nav_spec[from] or E -- e.g. {'1','2'}
  for i = 1, #preferred_nav_order do -- convert array into a map for O(1) access.
    visits_first[i] = true
  end
  -- Process the nodes with no preferred traversal order first, so that they
  -- get pushed to the bottom of the stack.
  local push_count = 0
  for to, weight in vertex:outgoings() do
    if not visits_first[to] then
      if visited_hist[to] then -- already explored node
        if is_include_visited then
          -- Ignoring the 'unvisited count' and 'begin vertex' for now.
          local entry = {from, to, weight, level}
          entry[IS_VISITED] = true
          stack:push(entry)
        end
      else -- unexplored node
        stack:push {from, to, weight, level}
        push_count = push_count + 1
        count_unvisited = count_unvisited + 1
      end
    end
  end
  -- Process the nodes with explicit preferred traversal order last, so they
  -- get pushed to the top of the stack.
  for i = #preferred_nav_order, 1, -1 do -- push to the stack in reversed order.
    local to = preferred_nav_order[i]
    if visited_hist[to] then -- already explored node
      if is_include_visited then
        local weight = vertex.egress[to]
        -- Ignoring the 'unvisited count' and 'begin vertex' for now.
        local entry = {from, to, weight, level}
        entry[IS_VISITED] = true
        stack:push(entry)
      end
    else -- unexplored node
      local weight = vertex.egress[to]
      stack:push {from, to, weight, level}
      push_count = push_count + 1
      count_unvisited = count_unvisited + 1
    end
  end
  return count_unvisited, push_count
end

local function vertices_of(G)
  local vertices = {}
  for v in G:vertices() do
    vertices[v] = true
  end
  return vertices
end

---@param src (any) optional source vertex. If specified, DFS will only be performed
---from this source vertex (ie. not necessarily exploring all nodes in the graph.).
---Otherwise, DFS will be performed on the entire graph exploring all nodes.
---@param is_include_visited (boolean) true if visited nodes are returned in addition to unvisited node.
---The visited edges are called "fronds".
---(See Depth-First Search and Linear Graph Algorithms by Robert Tarjan.)
---This can be useful in special circumstances, such as implementing the Tarjan's SCC algorithm.
local function _iterate(self, src, is_include_visited)
  local stack, visited_hist = Stack:new(), {}
  -- Applicable only if a single source (ie the 'src' parameter) is not specified for this DFS.
  -- If a single source is specified, the DFS will only be performed from that source vertex.
  -- Otherwise, DFS is performed from potentially many source vertices until all vertices have been explored.
  local unvisited_vertices -- Contains vertices that have not been visited; visited ones are erased.
  local src_spec_idx = 0
  self._visited_count = 0
  local node = src -- DFS from a single source vertex.
  if not node then -- DFS from potentially many source vertices.
    unvisited_vertices = vertices_of(self.graph)
    local next_unvisited = next(unvisited_vertices) -- we are done if all vertices have been visited.
    if next_unvisited then
      local src_spec = self._src_spec
      src_spec_idx = src_spec_idx + 1
      node = src_spec[src_spec_idx] -- give preference to the specified sequence of source vertices.
      node = node or next_unvisited
    end
  end
  local is_visited -- applicable only if 'is_include_visited' is true.
  -- A DFS retry is necessary if no source vertex is explicitly specified, and a preious DFS
  -- from an arbitrary vertex doesn't cover the entire graph.  In that case, another
  -- vertex will be used for a DFS retry.
  local begin_vertex = node -- The starting vertex of a DFS or a DFS retry.
  local depth = 0
  debug(string.format("DFS starting from %s", node))
  ::retry::
  local entry -- format: {from, to, weight, depth, count_unvisited, begin_vertex, is_visited}
  while node do
    if visited_hist[node] then
      if is_include_visited then
        entry[IS_VISITED] = true
        self._yield(entry)
      end
    else -- first time visiting this node
      visited_hist[node], self._visited_count = true, self._visited_count + 1
      (unvisited_vertices or E)[node] = nil
      depth = depth + 1
      local count_unvisited, push_count = push_edges(self, node, depth, stack, visited_hist, is_include_visited)
      -- 'entry' is nil only during the first iteration when we are starting with the source node.
      if entry then
        entry[UNVISITED] = count_unvisited -- number of unvisited outgoing edges.
        entry[BEGIN_VERTEX] = begin_vertex -- the source vertex of the DFS.
        self._yield(entry)
      elseif push_count == 0 then -- the source node has no outgoing edges
        assert(node == begin_vertex)
        visited_hist[node], self._visited_count = true, self._visited_count + 1
        (unvisited_vertices or E)[node] = nil
        -- format: {from, to, weight, depth, count_unvisited, begin_vertex}
        -- yield the single node anyway so we don't loose a vertex during DFS.
        self._yield {node, nil, nil, 0, 0, begin_vertex}
      end
    end
    entry = (stack:pop() or E)
    node, depth, is_visited = entry[TO], entry[DEPTH], entry[IS_VISITED]
    while is_visited do -- only possible if 'is_include_visited' is true.
      self._yield(entry)
      entry = (stack:pop() or E)
      node, depth, is_visited = entry[TO], entry[DEPTH], entry[IS_VISITED]
    end
    if unvisited_vertices and node then
      unvisited_vertices[node] = nil
    end
  end -- end while
  if unvisited_vertices then -- implies doing the search for the entire graph.
    local next_unvisited = next(unvisited_vertices) -- we are done if all vertices have been visited.
    if next_unvisited then
      local src_spec = self._src_spec
      src_spec_idx = src_spec_idx + 1
      -- give preference to the specified sequence of source vertices.
      node = src_spec[src_spec_idx]
      while node and not unvisited_vertices[node] do -- skip those vertices we have visited.
        src_spec_idx = src_spec_idx + 1
        node = src_spec[src_spec_idx]
      end
      node = node or next_unvisited
      depth = 0
      debug(string.format("DFS retrying from %s", node))
      begin_vertex = node
      goto retry
    end
  end
end

---@param G (table) graph
---@param nav_spec (table?) opional navigation spec in the format of
---{from_1={to_1, to_2, ...}, ...} e.g. {['3']={'5','11'}, ['5']={'7','9'}}
---@param src_spec (table?) optional source vertex spec in the format of
---{v1, v2, ...} e.g. {'1', '2', '3', ...}; applicable only if 'src' is not specified
function DFS:new(G, nav_spec, src_spec)
  return getmetatable(self):new(G, _iterate, nav_spec, src_spec)
end

return DFS
