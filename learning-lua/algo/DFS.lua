local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local DFS = GraphSearch:class()
local E = {}

local function debug(...)
  -- print(...)
end

--- Push all unvisited outgoing edges to the stack.
---@param self (table) the current DFS instance
---@param from (any) from node
---@param level (number) the number of hops from the source node
---@param stack (table) the stack to push edges to
---@param visited (table) used to check if a node has been visited
---@return (number) the number of unvisited outgoing edges pushed to the stack
---@return (number) the number of outgoing edges already visited
local function push_edges(self, from, level, stack, visited)
  local vertex, count_unvisited, count_visited = self.graph:vertex(from), 0, 0
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
      if visited[to] then
        count_visited = count_visited + 1
      else
        stack:push{to, weight, level, from}
        push_count = push_count + 1
        count_unvisited = count_unvisited + 1
      end
    end
  end
  -- Process the nodes with explicit preferred traversal order last, so they
  -- get pushed to the top of the stack.
  for i = #preferred_nav_order, 1, -1 do -- push to the stack in reversed order.
    local to = preferred_nav_order[i]
    if visited[to] then
      count_visited = count_visited + 1
    else
      local weight = vertex.egress[to]
      stack:push{to, weight, level, from}
      push_count = push_count + 1
      count_unvisited = count_unvisited + 1
    end
  end
  return count_unvisited, count_visited, push_count
end

local function vertices_of(G)
  local vertices = {}
  for v in G:vertices() do
    vertices[v] = true
  end
  return vertices
end

local function _iterate(self)
  local stack, visited = Stack:new(), {}
  -- Applicable only if a single source is not specified for this DFS.
  -- If a single source is specified, the DFS will only be performed from that source vertex.
  -- Otherwise, DFS is performed from potentially many source vertices until all vertices have been explored.
  local unvisited_vertices -- Contains vertices that have not been visited; visited ones are erased.
  local src_spec_idx = 0
  self._visited_count = 0
  local from = self.src_vertex -- DFS from a single source vertex
  if not from then -- DFS from potentially many source vertices
    unvisited_vertices = vertices_of(self.graph)
    local next_unvisited = next(unvisited_vertices) -- we are done if all vertices have been visited.
    if next_unvisited then
      local src_spec = self._src_spec
      src_spec_idx = src_spec_idx + 1
      from = src_spec[src_spec_idx] -- give preference to the specified sequence of source vertices.
      from = from or next_unvisited
    end
  end

  -- A DFS retry is necessary if no source vertex is explicitly specified, and a preious DFS
  -- from an arbitrary vertex doesn't cover the entire graph.  In that case, another
  -- vertex will be used for a DFS retry.
  local beginning = from -- The starting vertex of a DFS or a DFS retry.
  local level = 0
  debug(string.format("DFS starting from %s", from))
  ::retry::
  local t
  while from do
    if not visited[from] then
      visited[from], self._visited_count = true, self._visited_count + 1
      (unvisited_vertices or E)[from] = nil
      local vertex = self.graph:vertex(from)
      level = level + 1
      local count_unvisited, count_visited, push_count = push_edges(self, from, level, stack, visited)
      if t then -- t is nil only during the first iteration when we are starting with the source node.
        t[#t + 1] = count_unvisited -- append the number of unvisited outgoing edges.
        t[#t + 1] = count_visited -- append the number of visited outgoing edges.
        t[#t + 1] = beginning -- append the source vertex.
        self._yield(t)
      elseif push_count == 0 and from == beginning then -- the starting node is the only node with unvisited edges.
        visited[from], self._visited_count = true, self._visited_count + 1
        (unvisited_vertices or E)[from] = nil
        -- format: to, weight, depth, from, count_unvisited, count_visited, beginning
        self._yield {nil, nil, 0, from, 0, 0, beginning} -- yield it anyway so we don't loose a vertex during DFS
      end
    end
    t = (stack:pop() or E)
    from, level = t[1], t[3]
    if unvisited_vertices and from then
      unvisited_vertices[from] = nil
    end
  end
  if unvisited_vertices then -- implies doing the search for the entire graph.
    local next_unvisited = next(unvisited_vertices) -- we are done if all vertices have been visited.
    if next_unvisited then
      local src_spec = self._src_spec
      src_spec_idx = src_spec_idx + 1
      from = src_spec[src_spec_idx] -- give preference to the specified sequence of source vertices.
      while from and not unvisited_vertices[from] do -- skip those vertices we have visited.
        src_spec_idx = src_spec_idx + 1
        from = src_spec[src_spec_idx]
      end
      from = from or next_unvisited
      level = 0
      debug(string.format("DFS retrying from %s", from))
      beginning = from
      goto retry
    end
  end
end

---@param G (table) graph
---@param src (any) source vertex
---@param nav_spec (table) opional navigation spec in the format of {from_1={to_1, to_2, ...}, ...} e.g. {['3']={'5','11'}, ['5']={'7','9'}}
---@param src_spec (table) optional source vertex spec in the format of {v1, v2, ...} e.g. {'1', '2', '3', ...}; applicable only if 'src' is not specified
function DFS:new(G, src, nav_spec, src_spec)
  return getmetatable(self):new(G, src, _iterate, nav_spec, src_spec)
end

return DFS
