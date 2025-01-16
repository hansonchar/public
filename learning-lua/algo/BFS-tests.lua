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

local function bfs_test(input, src, expected_visits, expected_max_level)
  local G = load_input(input)
  local bfs, count, prev_level = BFS:new(G, src), 1, 0
  for from, to, weight, level in bfs:iterate() do
    count = count + 1
    assert(prev_level <= level)
    prev_level = level
    -- print(string.format("%d: %s-%s=%d", level, from, to, weight))
  end
  assert(count == expected_visits and count == bfs:visited_count(), count)
  assert(prev_level == expected_max_level)
end

bfs_test({'s-v=1', 's-w=4', 'v-w=2', 'v-t=6', 'w-t=3'}, 's', 4, 2)
bfs_test({'A-B=2', 'A-C=4', 'A-D=4', 'B-F=6', 'C-F=5', 'C-E=7', 'C-D=1', 'D-E=5', 'D-H=11', 'E-G=3', 'E-H=4', 'F-H=5',
          'F-G=2', 'F-E=1', 'G-H=2'}, 'A', 8, 3)
