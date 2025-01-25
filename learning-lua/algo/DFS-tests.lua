local DFS = require "algo.DFS"
local Graph = require "algo.Graph"

---@param input (table) array of directed arcs in the format of, for example, "u-v".
---@return (table) a Graph object
local function load_edges(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to = edge:match('(%w-)%-(%w+).*')
    G:add(from, to, 1)
  end
  return G
end

local function dfs_test(input, src, expected_visits, expected_max_level)
  local G = load_edges(input)
  local dfs, count, max_level = DFS:new(G, src), 1, 0
  for from, to, weight, level in dfs:iterate() do
    count = count + 1
    max_level = level > max_level and level or max_level
    -- print(string.format("%d: %s-%s=%d", level, from, to, weight))
  end
  assert(count == expected_visits and dfs:visited_count() == count)
  assert(max_level <= expected_max_level)
end

--- A creative way to do topo sorting.  See TopologicalSearch.lua for a more conventional way.
--- We define a terminal node as the node with the highest topological order in a DAG.
--- We identify the terminal node by detecting the first node with no (unvisited) outgoing edges.
local function topo_sort(input, src)
  local terminal -- the terminal node
  local level_visits = {}
  local G = load_edges(input)
  local dfs = DFS:new(G, src)
  -- outgoings is the number of unvisited outgoing edges
  for from, to, _, depth, outgoings in dfs:iterate() do
    -- print(string.format("%d: %s-%s", level, from, to))
    if not terminal and outgoings == 0 then
      terminal = to
    else
      level_visits[depth] = level_visits[depth] or {}
      local visits = level_visits[depth]
      visits[#visits + 1] = to
    end
  end
  local a = {src}
  for _, visits in ipairs(level_visits) do
    for i = #visits, 1, -1 do
      a[#a + 1] = visits[i]
    end
  end
  a[#a + 1] = terminal
  return a
end

local function a2ordering(a)
  local ordering = {}
  for i, node in ipairs(a) do
    ordering[node] = i
  end
  return ordering
end

local function verify_tim_order(a)
  local ordering = a2ordering(a)
  assert(ordering.s == 1)
  assert(ordering.t == 4)
end

local function verify_scott_order(a)
  -- print(table.concat(a, "-"))
  local ordering = a2ordering(a)
  assert(ordering.A == 1)
  assert(ordering.H == 8)
  assert(ordering.B < ordering.F)
  assert(ordering.C < ordering.D)
  assert(ordering.C < ordering.F)
  assert(ordering.D < ordering.E)
  assert(ordering.E < ordering.G)
  assert(ordering.F < ordering.E)
  assert(ordering.G < ordering.H)
end

local function verify_star_order(a)
  -- print(table.concat(a, "-"))
  local ordering = a2ordering(a)
  assert(ordering.a == 1)
  assert(ordering.d < ordering.e)
end

local function verify_wiki_order(a)
  -- print(table.concat(a, "-"))
  local ordering = a2ordering(a)
  assert(ordering['0'] == 1)
  assert(ordering['11'] < ordering['10'])
  assert(ordering['11'] < ordering['9'])
  assert(ordering['11'] < ordering['2'])
  assert(ordering['8'] < ordering['9'])
  assert(ordering['3'] < ordering['8'])
  assert(ordering['3'] < ordering['10'])
  assert(ordering['7'] < ordering['8'])
  assert(ordering['7'] < ordering['11'])
  assert(ordering['5'] < ordering['11'])
end

local function single_vertex_test()
  print("Testing single vertex ...")
  local G = Graph:new()
  G:add('a')
  local dfs = DFS:new(G, 'a')
  local count = 0
  for from, to, weight, depth in dfs:iterate() do
    count = count + 1
    assert(from == 'a')
    assert(not to)
    assert(not weight)
    assert(depth == 0)
  end
  assert(count == 1)
end

local function no_edges_test()
  print("Testing graph with no edges ...")
  local G = Graph:new()
  G:add('a')
  G:add('b')
  G:add('c')
  local dfs = DFS:new(G)
  local count = 0
  for from, to, weight, depth in dfs:iterate() do
    count = count + 1
    assert(from)
    assert(not to)
    assert(not weight)
    assert(depth == 0)
  end
  assert(count == 3)
end

single_vertex_test()
no_edges_test()

print("Testing topo sort from Tim ...")
local edges = {'1-3', '3-5', '5-1', '3-11', '5-9', '5-7', '11-6', '11-8', '8-6', '6-10', '10-8', '9-2', '9-4', '2-4',
               '2-10', '4-7', '7-9'}
local a = topo_sort(edges, '1')
print(table.concat(a, "-"))

-- Algorithms Illuminated Part 2 by Prof. Tim Roughgarden
local g = {'s-v', 's-w', 'v-w', 'v-t', 'w-t'}
dfs_test(g, 's', 4, 2)
verify_tim_order(topo_sort(g, 's'))
-- os.exit()

-- https://ecal.studentorg.berkeley.edu/files/ce191/CH05-DynamicProgramming.pdf by Prof. Scott Moura
local g = {'A-B', 'A-C', 'A-D', 'B-F', 'C-F', 'C-E', 'C-D', 'D-E', 'D-H', 'E-G', 'E-H', 'F-H', 'F-G', 'F-E', 'G-H'}
dfs_test(g, 'A', 8, 5)
verify_scott_order(topo_sort(g, 'A'))

local g = {'a-b', 'a-c', 'a-d', 'd-e'}
dfs_test(g, 'a', 5, 2)
verify_star_order(topo_sort(g, 'a'))

-- https://en.wikipedia.org/wiki/Topological_sorting
local g = {'0-5', '0-7', '0-3', '5-11', '7-11', '7-8', '11-2', '11-9', '11-10', '8-9', '3-8', '3-10'}
dfs_test(g, '0', 9, 3)
verify_wiki_order(topo_sort(g, '0'))

os.exit()
