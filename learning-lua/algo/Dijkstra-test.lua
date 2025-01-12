local Dijkstra = require "algo.Dijkstra"
local Graph = require "algo.Graph"

print("\nBasic tests...")
local G = Graph:new()
G:add('s', 'v', 1)
G:add('s', 'w', 4)
G:add('v', 'w', 2)
G:add('v', 't', 6)
G:add('w', 't', 3)

local d = Dijkstra:new(G, "s")
local sssp = d:shortest_paths()
local vertices = sssp.vertices
assert(sssp:min_cost('s') == 0)
assert(not vertices['s'].from)

assert(sssp:min_cost('t') == 6)
assert(vertices['t'].from == 'w')

assert(sssp:min_cost('v') == 1)
assert(vertices['v'].from == 's')

assert(sssp:min_cost('w') == 3)
assert(vertices['w'].from == 'v')

sssp:dump()

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
  print("\ntim_test...")
  local input<const> = {'s-v=1', 's-w=4', 'v-w=2', 'v-t=6', 'w-t=3'}
  local source<const> = 's'

  local G = load_input(input)
  local d = Dijkstra:new(G, source)
  local sssp = d:shortest_paths()
  sssp:dump()

  assert(sssp:shortest_path_of('s') == 's')
  assert(sssp:min_cost(source) == 0)

  assert(sssp:shortest_path_of('v') == 's-v')
  assert(sssp:min_cost('v') == 1)

  assert(sssp:shortest_path_of('w') == 's-v-w')
  assert(sssp:min_cost('w') == 3)

  assert(sssp:shortest_path_of('t') == 's-v-w-t')
  assert(sssp:min_cost('t') == 6)
end

-- Example from https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
local function geek_test()
  print("\ngeek_test...")
  local input<const> = {'0-1=4', '1-0=4', '0-7=8', '7-0=8', '1-2=8', '2-1=8', '1-7=11', '7-1=11', '2-3=7', '3-1=7',
                        '2-5=4', '5-2=4', '2-8=2', '8-2=2', '3-4=9', '4-3=9', '3-5=14', '5-3=14', '4-5=10', '5-4=10',
                        '5-6=2', '6-5=2', '6-7=1', '7-6=1', '6-8=6', '8-6=6', '7-8=7', '8-7=7'}
  local source<const> = '0'
  local G = load_input(input)
  local d = Dijkstra:new(G, source)
  local sssp = d:shortest_paths()
  sssp:dump()

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

tim_test()
geek_test()

local G = Graph:new()
G:add('s', 'v', -1)
local d = Dijkstra:new(G, 's')
local ok, errmsg = pcall(d.shortest_paths, d)
assert(not ok)
assert(string.match(errmsg, "Weight must not be negative$"))

os.exit()
