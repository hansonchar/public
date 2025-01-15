local ShortestPathSearch = require "algo.ShortestPathSearch"
local Graph = require "algo.Graph"

local function basic_tests()
  print("ShortestPathSearch basic tests...")
  local G = Graph:new()
  G:add('s', 'v', 1)
  G:add('s', 'w', 4)
  G:add('v', 'w', 2)
  G:add('v', 't', 6)
  G:add('w', 't', 3)

  local search = ShortestPathSearch:new(G, 's')
  for from, to, weight, level, min_cost in search:iterate() do
    -- print(string.format("%d: %s-%s=%d, min:%d", level, from, to, weight, min_cost))
  end

  local sssp = search:shortest_paths()
  print(sssp)
  assert(sssp:min_cost('s') == 0)
  assert(sssp:min_cost('t') == 6)
  assert(sssp:min_cost('v') == 1)
  assert(sssp:min_cost('w') == 3)
end

local function load_input(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add(from, to, cost)
  end
  return G
end

--- Example from Algorithms Illuminated Part 2, 2018, by Tim Roughgarden.
local function tim_test()
  print("ShortestPathSearch tim_test...")
  local input<const> = {'s-v=1', 's-w=4', 'v-w=2', 'v-t=6', 'w-t=3'}
  local src<const> = 's'
  local G = load_input(input)
  local level_counts = {}
  local search = ShortestPathSearch:new(G, src)
  for from, to, weight, level, min_cost in search:iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d, min:%d", level, from, to, weight, min_cost))
  end
  for _, count in pairs(level_counts) do
    assert(count == 1)
  end
  local shortest_paths = search:shortest_paths()
  print(shortest_paths)
  assert(shortest_paths:min_cost('s') == 0)
  assert(shortest_paths:shortest_path_of('s') == 's')
  assert(shortest_paths:min_cost('v') == 1)
  assert(shortest_paths:shortest_path_of('v') == 's-v')
  assert(shortest_paths:min_cost('w') == 3)
  assert(shortest_paths:shortest_path_of('w') == 's-v-w')
  assert(shortest_paths:min_cost('t') == 6)
  assert(shortest_paths:shortest_path_of('t') == 's-v-w-t')
end

-- Example from https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
local function geek_test()
  print("ShortestPathSearch geek_test...")
  local input<const> = {'0-1=4', '1-0=4', '0-7=8', '7-0=8', '1-2=8', '2-1=8', '1-7=11', '7-1=11', '2-3=7', '3-1=7',
                        '2-5=4', '5-2=4', '2-8=2', '8-2=2', '3-4=9', '4-3=9', '3-5=14', '5-3=14', '4-5=10', '5-4=10',
                        '5-6=2', '6-5=2', '6-7=1', '7-6=1', '6-8=6', '8-6=6', '7-8=7', '8-7=7'}
  local src<const> = '0'
  local G = load_input(input)
  local level_counts = {}
  local search = ShortestPathSearch:new(G, src)
  for from, to, weight, level, min_cost in search:iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d, min:%d", level, from, to, weight, min_cost))
  end
  assert(level_counts[1] == 2)
  assert(level_counts[2] == 2)
  assert(level_counts[3] == 3)
  assert(level_counts[4] == 1)

  local sssp = search:shortest_paths()
  print(sssp)
  assert(sssp:shortest_path_of('0') == '0')
  assert(sssp:min_cost('0') == 0)

  assert(sssp:shortest_path_of('1') == '0-1')
  assert(sssp:min_cost('1') == 4)

  assert(sssp:shortest_path_of('2') == '0-1-2')
  assert(sssp:min_cost('2') == 12)

  assert(sssp:shortest_path_of('3') == '0-1-2-3')
  assert(sssp:min_cost('3') == 19)

  assert(sssp:shortest_path_of('4') == '0-7-6-5-4')
  assert(sssp:min_cost('4') == 21)

  assert(sssp:shortest_path_of('5') == '0-7-6-5')
  assert(sssp:min_cost('5') == 11)

  assert(sssp:shortest_path_of('6') == '0-7-6')
  assert(sssp:min_cost('6') == 9)

  assert(sssp:shortest_path_of('7') == '0-7')
  assert(sssp:min_cost('7') == 8)

  assert(sssp:shortest_path_of('8') == '0-1-2-8')
  assert(sssp:min_cost('8') == 14)
end

-- https://www.redblobgames.com/pathfinding/posts/reprioritize.html
local function redblobgames_test()
  print("ShortestPathSearch redblobgames_test...")
  local input<const> = {'A-B=1', 'B-C=1', 'B-E=4', 'C-D=1', 'D-E=1'}
  local src<const> = 'A'

  local G = load_input(input)
  local level_counts = {}
  local search = ShortestPathSearch:new(G, src)
  for from, to, weight, level, min_cost in search:iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d, min:%d", level, from, to, weight, min_cost))
  end
  for _, count in pairs(level_counts) do
    assert(count == 1)
  end

  local sssp = search:shortest_paths()
  print(sssp)
  assert(sssp:shortest_path_of('A') == 'A')
  assert(sssp:min_cost(src) == 0)

  assert(sssp:shortest_path_of('B') == 'A-B')
  assert(sssp:min_cost('B') == 1)

  assert(sssp:shortest_path_of('C') == 'A-B-C')
  assert(sssp:min_cost('C') == 2)

  assert(sssp:shortest_path_of('D') == 'A-B-C-D')
  assert(sssp:min_cost('D') == 3)

  assert(sssp:shortest_path_of('E') == 'A-B-C-D-E')
  assert(sssp:min_cost('E') == 4)
end

-- https://algodaily.com/lessons/an-illustrated-guide-to-dijkstras-algorithm
local function algodaily_test()
  print("ShortestPathSearch algodaily_test...")
  local input<const> = {'A-B=5', 'A-C=2', 'B-C=7', 'B-D=8', 'C-D=4', 'C-E=8', 'D-E=6', 'D-F=4', 'E-F=3', 'B-A=5',
                        'C-A=2', 'C-B=7', 'D-B=8', 'D-C=4', 'E-C=8', 'E-D=6', 'F-D=4', 'F-E=3'}
  local src<const> = 'A'

  local G = load_input(input)
  local level_counts = {}
  local search = ShortestPathSearch:new(G, src)
  for from, to, weight, level, min_cost in search:iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d, min:%d", level, from, to, weight, min_cost))
  end
  assert(level_counts[1] == 2)
  assert(level_counts[2] == 2)
  assert(level_counts[3] == 1)

  local sssp = search:shortest_paths()
  print(sssp)
  assert(sssp:shortest_path_of('A') == 'A')
  assert(sssp:min_cost(src) == 0)

  assert(sssp:shortest_path_of('B') == 'A-B')
  assert(sssp:min_cost('B') == 5)

  assert(sssp:shortest_path_of('C') == 'A-C')
  assert(sssp:min_cost('C') == 2)

  assert(sssp:shortest_path_of('D') == 'A-C-D')
  assert(sssp:min_cost('D') == 6)

  assert(sssp:shortest_path_of('E') == 'A-C-E')
  assert(sssp:min_cost('E') == 10)

  assert(sssp:shortest_path_of('F') == 'A-C-D-F')
  assert(sssp:min_cost('F') == 10)
end

-- CE 191 - CEE Systems Analysis by Processor Scott Moura, University of California, Berkeley
local function scott_moura_test()
  print("ShortestPathSearch scott_moura_test...")
  local input<const> = {'A-B=2', 'A-C=4', 'A-D=4', 'B-F=6', 'C-F=5', 'C-E=7', 'C-D=1', 'D-E=5', 'D-H=11', 'E-G=3',
                        'E-H=4', 'F-H=5', 'F-G=2', 'F-E=1', 'G-H=2'}
  local src<const> = 'A'

  local G = load_input(input)
  local level_counts = {}
  local search = ShortestPathSearch:new(G, src)
  for from, to, weight, level, min_cost in search:iterate() do
    level_counts[level] = level_counts[level] or 0
    level_counts[level] = level_counts[level] + 1
    -- print(string.format("%d: %s-%s=%d, min:%d", level, from, to, weight, min_cost))
  end
  assert(level_counts[1] == 3)
  assert(level_counts[2] == 2)
  assert(level_counts[3] == 1)
  assert(level_counts[4] == 1)

  local sssp = search:shortest_paths()
  print(sssp)
  assert(sssp:shortest_path_of('A') == 'A')
  assert(sssp:min_cost(src) == 0)

  assert(sssp:shortest_path_of('B') == 'A-B')
  assert(sssp:min_cost('B') == 2)

  assert(sssp:shortest_path_of('C') == 'A-C')
  assert(sssp:min_cost('C') == 4)

  assert(sssp:shortest_path_of('D') == 'A-D')
  assert(sssp:min_cost('D') == 4)

  assert(sssp:shortest_path_of('E') == 'A-D-E')
  assert(sssp:min_cost('E') == 9)

  assert(sssp:shortest_path_of('F') == 'A-B-F')
  assert(sssp:min_cost('F') == 8)

  assert(sssp:shortest_path_of('G') == 'A-B-F-G')
  assert(sssp:min_cost('G') == 10)

  assert(sssp:shortest_path_of('H') == 'A-B-F-G-H')
  assert(sssp:min_cost('H') == 12)
end

local function negative_tests()
  print("ShortestPathSearch negative_tests...")
  local G = Graph:new()
  G:add('s', 'v', -1)
  local search = ShortestPathSearch:new(G, 's')
  local iterator = search:iterate()
  local ok, errmsg = pcall(iterator, search)
  assert(not ok)
  assert(string.match(errmsg, "Weight must not be negative$"))
end

basic_tests()
tim_test()
geek_test()
redblobgames_test()
algodaily_test()
scott_moura_test()
negative_tests()
