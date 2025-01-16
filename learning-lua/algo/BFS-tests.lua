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
  assert(level_counts[2] == 1)
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
  assert(level_counts[2] == 3)
  assert(level_counts[3] == 1)
end

tim_test()
scott_moura_test()
