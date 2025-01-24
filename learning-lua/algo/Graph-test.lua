local Graph = require "algo.Graph"

local function load_input(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add(from, to, cost)
  end
  return G
end

local function basic_tests()
  print("basic_tests...")
  local G = Graph:new()

  print(G:outgoing_str('x'))

  G:add('s', 'v', 1)
  G:add('s', 'w', 4)
  G:add('v', 'w', 2)

  print(G:outgoing_str())

  local s = G:vertex('s')
  for v, weight in s:outgoings() do
    print('s', v, weight)
  end

  print(G:outgoing_str('s'))

  local x = {}
  setmetatable(x, x)
  assert(not Graph.isGraph(x)) -- self reference metatable

  assert(Graph.isGraph(G)) -- the metatable of G is Graph
  assert(not Graph.isGraph {}) -- no metatable

  local child = G:new() -- the metatable of the metatable of child is Graph
  assert(Graph.isGraph(child))

  assert(not Graph.isGraph(1))
  assert(not Graph.isGraph(""))

  assert(not Graph.isGraph())
end

local function test_build_ingress()
  print("test_build_ingress ... ")
  local input<const> = {'A-B=2', 'A-C=4', 'A-D=4', 'B-F=6', 'C-F=5', 'C-E=7', 'C-D=1', 'D-E=5', 'D-H=11', 'E-G=3',
                        'E-H=4', 'F-H=5', 'F-G=2', 'F-E=1', 'G-H=2'}
  local source<const> = 'A'
  local G = load_input(input)
  G:build_ingress()
  local incoming, count_i = G:incoming_str()
  print(incoming)
  local outgoing, count_e = G:outgoing_str()
  print(outgoing)
  assert(count_e == count_i)
  assert(G:is_arc('A', 'B') == 2)
  assert(not G:is_arc('B', 'A'))
end

local function test_transpose()
  print("test_transpose ... ")
  local input<const> = {'A-B=2', 'A-C=4', 'A-D=4', 'B-F=6', 'C-F=5', 'C-E=7', 'C-D=1', 'D-E=5', 'D-H=11', 'E-G=3',
                        'E-H=4', 'F-H=5', 'F-G=2', 'F-E=1', 'G-H=2'}
  local source<const> = 'A'
  local G = load_input(input)
  G:build_ingress()
  assert(not G:is_transposed())
  assert(not G:transpose())
  assert(G:is_transposed())
  local incoming, count_i = G:incoming_str()
  print(incoming)
  local outgoing, count_e = G:outgoing_str()
  print(outgoing)
  assert(count_e == count_i)
  assert(not G:is_arc('A', 'B'))
  assert(G:is_arc('B', 'A') == 2)
end

basic_tests()
test_build_ingress()
test_transpose()
os.exit()
