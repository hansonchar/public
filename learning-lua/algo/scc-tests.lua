local DFS = require "algo.DFS"
local Graph = require "algo.Graph"
local E = {}

local function debug(...)
  -- print(...)
end

---@param input (table) array of directed arcs in the format of, for example, "u-v=1".
---@return (table) a Graph object
local function load_edges(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add(from, to, cost)
  end
  return G
end

--- Removes all the vertices in scc from the given graph.
---@param graph (table)
---@param scc (table) vertices of a strongly connected component
local function remove_scc(graph, scc)
  for node in pairs(scc) do
    graph:remove(node)
  end
  return graph
end

---Returns a comma delimited string of the keys of the given table.
---@param t (table)
---@return (string)
local function keys_tostring(t)
  local a = {}
  for v in pairs(t) do
    a[#a + 1] = v
  end
  return table.concat(a, ",")
end

---Returns the string of a path, with each node delimited by
---a dash ('-') character.
---@param path (table)
---@return (string)
local function path_tostring(path) -- for debugging
  local a = {}
  for v, i in pairs(path) do
    a[i] = v
  end
  return table.concat(a, "-")
end

--- Performs a full or partial DFS on the graph starting from the 'start' vertex.
---@param G (table) the graph.
---@param start (any) the starting vertex (aka node).
---@param max_path_length (number) the maximum number of vertices to traverse; or nil for a full path.
---@return (table) the path, either full or partial, with vertex as the key, and the position on the path as value.
---@return (number) the number of vertices in the path.
---@return (table) the dead ends encountered during the walk. A dead end is defined as a vertex where either there is no outgoing edge or if all the outgoing edges lead to vertices that have already been visited.
---@return (number) the number of dead ends encountered during the walk.
---@return (table) the path as an array of vertices.
local function walk(G, start, max_path_length)
  local max = max_path_length or math.huge
  local path_size, path = 1, { -- a path is has the nodes as key and their positions along the path as values.
    [start] = 1
  }
  local path_list = {start} -- the "path list" is an array of nodes
  local deadends_size, deadends = 0, {}
  for from, to, weight, level, unvisited_cnt, visited_cnt in DFS:new(G, start):iterate() do
    if not to then
      break -- from is a lone vertex with no outgoing edges
    end
    debug(string.format("level=%d: %s-%s -> %d unvisited, %d visited", level, from, to, unvisited_cnt, visited_cnt))
    path_size = path_size + 1
    path[to] = path_size
    path_list[#path_list + 1] = to
    if unvisited_cnt == 0 then
      deadends[to], deadends_size = true, deadends_size + 1
    end
    if path_size >= max then
      break -- short circuit
    end
  end
  debug(path_tostring(path))
  if not max_path_length then
    debug(string.format("Dead ends: %s", keys_tostring(deadends)))
  end
  debug()
  return path, path_size, deadends, deadends_size, path_list
end

--- Identifies all Strongly Connected Components (SCCs) of a graph using the following algorithm:
---
--- 1. Perform a Depth-First Search (DFS) starting from a random node, recording:
---    (a) Define the "active path" as the full traversal path if:
---        - The active path has not yet been defined, or
---        - The active path is empty.
---        A full traversal path is the sequence of vertices visited during the DFS 
---        (each vertex is visited at most once, as per the definition of DFS).
---    (b) Record all dead-end nodes: vertices with no outgoing edges or whose outgoing edges lead only 
---        to previously visited vertices.
---
--- 2. Analyze the active path:
---    - If the path contains only one vertex, it is immediately identified as a singleton SCC.
---    - Otherwise, perform a DFS from each dead-end node, selecting the shortest resulting path.
---      The shortest path is identified as an SCC.
---      * Optimization: If a DFS produces a path of length one, it is directly identified as a 
---        singleton SCC without further computation.
---    - Note: A DFS starting from any dead-end node will always produce a resulting path that is a 
---      subset of the active path.
---
--- 3. After identifying an SCC:
---    - Remove all vertices of the SCC from the graph.
---    - Update the active path by excluding the SCC's vertices while retaining the remaining vertices 
---      in their original order of traversal.
---    - Restart the process from step (1), selecting a new starting node:
---      * Prefer nodes still present in the updated active path, selected in reverse order of 
---        their positions in the path.
---      * If the active path becomes empty (i.e., all its SCCs have been identified), select a 
---        random node from the remaining graph.
---
--- Repeat this process until the graph is empty.
---@param g (table) array of arcs that define a graph.
---@return (number) number of SCC's of the graph; at least one and at most the number of vertices in the graph.
local function find_scc(G)
  print("============= Start finding SCC's =============")
  local scc_count, walk_count = 0, 0
  local src = next(G)
  local active_path_sz = 0
  local active_path, active_path_list_max, active_path_list

  while src do
    local path, path_size, deadends, deadends_size, path_list = walk(G, src)
    if active_path_sz == 0 then
      active_path, active_path_sz = path, path_size
      active_path_list, active_path_list_max = path_list, #path_list
    end
    walk_count = walk_count + 1
    local scc, scc_size = path, path_size
    if scc_size > 1 then
      for start in pairs(deadends) do
        local p, p_size, des, des_size = walk(G, start, scc_size)
        walk_count = walk_count + 1
        if p_size < scc_size then
          scc, scc_size = p, p_size
        end
        if scc_size == 1 then
          break
        end
      end
    end
    debug(string.format("*** scc: %s found after %d walks\n", keys_tostring(scc), walk_count))
    scc_count = scc_count + 1
    walk_count = 0
    remove_scc(G, scc)
    src = nil
    if active_path_sz == scc_size then
      active_path_sz = 0 -- drop the active path
    else
      for v in pairs(scc) do -- erase the scc from the active path stuff
        local pos = active_path[v]
        active_path[v], active_path_sz = nil, active_path_sz - 1
        active_path_list[pos] = nil
        while active_path_list_max > 0 and (pos == active_path_list_max or not active_path_list[active_path_list_max]) do
          active_path_list_max = active_path_list_max - 1
        end
      end
      src = active_path_list[active_path_list_max]
    end
    src = src or next(G)
    print(string.format("Setting src to %s", src))
  end
  return scc_count
end

local function find_scc_by_edges(edges_spec)
  return find_scc(load_edges(edges_spec):build_ingress())
end

-- https://snap.stanford.edu/data/
local function load_graph_from_edgelist(file_path)
  local g = Graph:new()
  for line in io.lines(file_path) do
    local from, to = line:match("^(%d+)%s+(%d+).*")
    if from then
      g:add(from, to, 1)
    end
  end
  return g:build_ingress()
end

-- local g = load_graph_from_edgelist("/Users/hchar/Downloads/congress_network/congress.edgelist")
-- assert(find_scc(g) == 7)
-- os.exit()

-- local g = load_graph_from_edgelist("/Users/hchar/Downloads/amazon0601.txt")
-- print(find_scc(g))
-- os.exit()

print("Testing a linear SCC graph")
local edges = {"a-b=1", "b-c=1", "c-d=1", "d-e=1"}
assert(find_scc_by_edges(edges) == 5)
-- os.exit()

-- https://en.wikipedia.org/wiki/Strongly_connected_component
print("Testing SCC from wikipedia ...")
local edges = {'a-b=1', 'b-c=1', 'b-f=1', 'b-e=1', 'c-d=1', 'c-g=1', 'd-c=1', 'd-h=1', 'e-a=1', 'e-f=1', 'f-g=1',
               'g-f=1', 'h-d=1', 'h-g=1'}
assert(find_scc_by_edges(edges) == 3)

-- Algoriths Illuminated Part 2 by Prof. Tim Roughgarden
print("Testing SCC from Tim ...")
local edges = {'1-3=1', '3-5=1', '5-1=1', '3-11=1', '5-9=1', '5-7=1', '11-6=1', '11-8=1', '8-6=1', '6-10=1', '10-8=1',
               '9-2=1', '9-4=1', '2-4=1', '4-7=1', '7-9=1'}
assert(find_scc_by_edges(edges) == 4)

-- https://cp-algorithms.com/graph/strongly-connected-components.html
print("Testing SCC from cp-algorithms ...")
local edges = {'0-1=1', '0-7=1', '1-2=1', '1-1=1', '2-1=1', '2-5=1', '3-2=1', '3-4=1', '4-9=1', '5-3=1', '5-6=1',
               '5-9=1', '6-2=1', '7-0=1', '7-6=1', '7-8=1', '8-6=1', '8-9=1', '9-4=1'}
assert(find_scc_by_edges(edges) == 4)

-- https://cseweb.ucsd.edu/classes/fa18/cse101-b/lec4.pdf by Miles Jones
print("Testing 1st SCC from Miles ...")
local edges = {'A-B=1', 'B-C=1', 'B-F=1', 'D-A=1', 'D-E=1', 'E-B=1', 'E-C=1', 'E-H=1', 'G-E=1', 'H-F=1'}
assert(find_scc_by_edges(edges) == 8)

print("Testing 2nd SCC from Miles ...")
local edges = {'A-B=1', 'A-F=1', 'B-C=1', 'C-F=1', 'C-I=1', 'D-C=1', 'D-G=1', 'E-H=1', 'E-K=1', 'F-B=1', 'G-D=1',
               'H-B=1', 'H-I=1', 'I-F=1', 'J-G=1', 'J-L=1', 'K-J=1', 'L-M=1', 'M-K=1'}
assert(find_scc_by_edges(edges) == 6)

print("Testing 3rd SCC from Miles ...")
local edges = {'A-B=1', 'A-C=1', 'B-G=1', 'C-E=1', 'D-C=1', 'E-D=1', 'F-A=1', 'G-F=1'}
assert(find_scc_by_edges(edges) == 2)

-- https://www.geeksforgeeks.org/strongly-connected-components/
print("Testing SCC from geeksforgeeks ...")
local edges = {'1-2=1', '2-3=1', '2-4=1', '3-4=1', '3-6=1', '4-1=1', '4-5=1', '5-6=1', '6-7=1', '7-5=1'}
assert(find_scc_by_edges(edges) == 2)

-- Introduction to Algorithms by Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, and Clifford Stein.
print("Testing SCC from CLRS ...")
local edges = {'a-b=1', 'b-c=1', 'b-e=1', 'b-f=1', 'c-d=1', 'c-g=1', 'd-c=1', 'd-h=1', 'e-a=1', 'e-f=1', 'f-g=1',
               'g-f=1', 'g-h=1', 'h-h=1'}
assert(find_scc_by_edges(edges) == 4)

-- A strong-connectivity algorithm and its applications in data flow analysis by Micha Sharir.
print("Testing SCC from Micha ...")
local edges = {'a-b=1', 'b-c=1', 'b-d=1', 'c-b=1', 'd-e=1', 'e-d=1', 'e-f=1', 'e-g=1', 'f-b=1', 'g-h=1', 'g-j=1',
               'h-i=1', 'i-h=1', 'i-l=1', 'j-i=1', 'j-k=1', 'k-j=1', 'l-i=1', 'l-k=1'}
assert(find_scc_by_edges(edges) == 4)

-- Depth-first search and linear graph algorithms by Tarjan, R.E.
print("Testing 1st SCC from Tarjan ...")
local edges = {'A-B=1', 'B-C=1', 'C-D=1', 'D-E=1', 'E-F=1', 'E-H=1', 'F-A=1', 'F-G=1', 'G-D=1', 'G-B=1', 'H-A=1',
               'H-C=1'}
assert(find_scc_by_edges(edges) == 1)

print("Testing 2nd SCC from Tarjan ...")
local edges = {"1-2=1", "2-3=1", "2-8=1", "3-4=1", "3-7=1", "4-5=1", "5-3=1", "5-6=1", "7-4=1", "7-6=1", "8-1=1",
               "8-7=1"}
assert(find_scc_by_edges(edges) == 3)
os.exit()
