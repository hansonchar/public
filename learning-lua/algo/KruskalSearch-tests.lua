local KruskalSearch = require "algo.KruskalSearch"
local Graph = require "algo.Graph"
local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

local function load_input(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add(from, to, cost)
  end
  return G
end

local function assertNext(it, u_expected, v_expected, weight_expected)
  local u, v, weight = it()
  assert(u == u_expected and v == v_expected and weight == weight_expected)
end

-- Algorithms Illuminated Part 3 Example 15.2.1 by Time Roughgarden.
local function tim_test()
  print("Testing Tim MST ...")
  local G = load_input {'a-b=1', 'b-d=2', 'a-d=3', 'a-c=4', 'c-d=5'}
  local ks = KruskalSearch:new(G)
  local it = ks:iterate()
  assertNext(it, 'a', 'b', 1)
  assertNext(it, 'b', 'd', 2)
  assertNext(it, 'a', 'c', 4)
end

-- https://www.geeksforgeeks.org/kruskals-minimum-spanning-tree-algorithm-greedy-algo-2/
local function g4g_test()
  print("Testing geeksforgeeks MST ...")
  local G = load_input {
    '0-1=4', '0-7=8',
    '1-2=8', '1-7=11',
    '2-3=7', '2-5=4', '2-8=2',
    '3-4=9', '3-5=14',
    '4-5=10', '5-6=2',
    '6-7=1', '6-8=6', '7-8=7'
  }
  local ks = KruskalSearch:new(G)
  local total_weight = 0
  for u, v, weight in ks:iterate() do
    debugf("MST %s-%s: %s", u, v, weight)
    total_weight = total_weight + weight
  end
  assert(total_weight == 37)
end

tim_test()
g4g_test()
os.exit()
