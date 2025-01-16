local BFS = require "algo.BFS"
local Graph = require "algo.Graph"

local function load_input(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add(from, to, cost)
  end
  return G
end

local function tim_test()
  print("BFS tim_test...")
  local input<const> = {'s-v=1', 's-w=4', 'v-w=2', 'v-t=6', 'w-t=3'}
  local src<const> = 's'
  local G = load_input(input)
  local level_counts = {}
  for from, to, weight, level in BFS:new(G, src):iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d", level, from, to, weight))
  end
  assert(level_counts[1] == 2)
  assert(level_counts[2] == 3)
  assert(level_counts[3] == 1)
end

local function scott_moura_test()
  print("BFS scott_moura_test ... ")
  local input<const> = {'A-B=2', 'A-C=4', 'A-D=4', 'B-F=6', 'C-F=5', 'C-E=7', 'C-D=1', 'D-E=5', 'D-H=11', 'E-G=3',
                        'E-H=4', 'F-H=5', 'F-G=2', 'F-E=1', 'G-H=2'}
  local src<const> = 'A'
  local level_counts = {}
  local G = load_input(input)
  for from, to, weight, level in BFS:new(G, src):iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d", level, from, to, weight))
  end
  assert(level_counts[1] == 3)
  assert(level_counts[2] == 6)
  assert(level_counts[3] == 12)
  assert(level_counts[4] == 10)
  assert(level_counts[5] == 3)
end

local function bfs_topo_sort(input, src)
  print("BFS topo sort ... ")
  local node_depth = { -- maximum depth of each node
    [src] = 0
  }
  local depth_to_nodes = {
    [0] = {
      [src] = true
    }
  }
  local G = load_input(input)
  for from, to, _, depth in BFS:new(G, src):iterate() do
    local old_depth = node_depth[to]
    assert(not old_depth or old_depth <= depth)
    if old_depth ~= depth then
      if old_depth then -- recorded earlier at a lesser depth; so remove it.
        depth_to_nodes[old_depth][to] = nil
      end
      node_depth[to] = depth
      depth_to_nodes[depth] = depth_to_nodes[depth] or {}
      depth_to_nodes[depth][to] = true
    end
  end

  local sorted = {}
  for i = 0, #depth_to_nodes do
    for node in pairs(depth_to_nodes[i]) do
      sorted[#sorted + 1] = node
    end
  end
  print(table.concat(sorted, "-"))
end

tim_test()
scott_moura_test()
bfs_topo_sort({'A-B=1', 'B-C=1', 'C-E=1', 'A-D=1', 'D-E=1'}, 'A')
bfs_topo_sort({'A-B=1', 'B-C=1', 'C-D=1', 'A-D=1'}, 'A')
-- Source https://en.wikipedia.org/wiki/Topological_sorting
bfs_topo_sort(
  {'0-3=1', '0-5=1', '0-7=1', '5-11=1', '11-2=1', '11-9=1', '11-10=1', '7-11=1', '7-8=1', '3-8=1', '3-10=1', '8-9=1'},
  '0')
