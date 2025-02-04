local MSTSearch = require "algo.MSTSearch"
local Graph = require "algo.Graph"
local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

local function load_input(input)
  local G = Graph:new()
  for _, edge in ipairs(input) do
    local from, to, cost = edge:match('(%w-)%-(%w+)=(%d+)')
    G:add_undirected(from, to, cost)
  end
  return G
end

local function test_mst(G, expected_total_weight)
  for src in G:vertices() do
    local total = 0
    for u, v, weight in MSTSearch:new(G):iterate(src) do
      debugf("%s-%s: %d", u, v, weight)
      total = total + weight
    end
    assert(total == expected_total_weight)
    debug()
  end
end

-- Algorithms Illuminated Part 3 Example 15.2.1 by Time Roughgarden.
print("Testing Tim MST ...")
test_mst(load_input {'a-b=1', 'b-d=2', 'a-d=3', 'a-c=4', 'c-d=5'}, 7)

print("Testing geeksforgeeks MST ...")
-- https://www.geeksforgeeks.org/kruskals-minimum-spanning-tree-algorithm-greedy-algo-2/
test_mst(load_input {
  '0-1=4', '0-7=8',
  '1-2=8', '1-7=11',
  '2-3=7', '2-5=4', '2-8=2',
  '3-4=9', '3-5=14',
  '4-5=10', '5-6=2',
  '6-7=1', '6-8=6', '7-8=7'
}, 37)
