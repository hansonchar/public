local DFS = require "algo.DFS"
local Graph = require "algo.Graph"

local function load_input(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add(from, to, cost)
  end
  return G
end

local function dfs_test(input, src, expected_visits, expected_max_level)
  local G = load_input(input)
  local dfs, count, max_level = DFS:new(G, src), 1, 0
  for from, to, weight, level in dfs:iterate() do
    count = count + 1
    max_level = level > max_level and level or max_level
    -- print(string.format("%d: %s-%s=%d", level, from, to, weight))
  end
  assert(count == expected_visits and dfs:visited_count() == count)
  assert(max_level <= expected_max_level)
end

--- We define a terminal node as the node with the highest topological order in a DAG.
--- We identify the terminal node by detecting the first node with no (unvisited) outgoing edges.
local function topo_sort(input, src)
  local terminal -- the terminal node
  local level_visits = {}
  local G = load_input(input)
  local dfs = DFS:new(G, src)
  -- outgoings is the number of unvisited outgoing edges
  for from, to, _, level, outgoings in dfs:iterate() do
    -- print(string.format("%d: %s-%s", level, from, to))
    if not terminal and outgoings == 0 then
      terminal = to
    else
      level_visits[level] = level_visits[level] or {}
      local visits = level_visits[level]
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

local function verify_star(a)
  -- print(table.concat(a, "-"))
  local ordering = a2ordering(a)
  assert(ordering.a == 1)
  assert(ordering.d < ordering.e)
end

-- Algoriths Illuminated Part 2 by Prof. Tim Roughgarden
local g = {'s-v=1', 's-w=4', 'v-w=2', 'v-t=6', 'w-t=3'}
dfs_test(g, 's', 4, 2)
verify_tim_order(topo_sort(g, 's'))

-- https://ecal.studentorg.berkeley.edu/files/ce191/CH05-DynamicProgramming.pdf by Prof. Scott Moura
local g = {'A-B=2', 'A-C=4', 'A-D=4', 'B-F=6', 'C-F=5', 'C-E=7', 'C-D=1', 'D-E=5', 'D-H=11', 'E-G=3', 'E-H=4', 'F-H=5',
           'F-G=2', 'F-E=1', 'G-H=2'}
dfs_test(g, 'A', 8, 5)
verify_scott_order(topo_sort(g, 'A'))

local g = {'a-b=1', 'a-c=1', 'a-d=1', 'd-e=1'}
dfs_test(g, 'a', 5, 2)
verify_star(topo_sort(g, 'a'))

os.exit()
