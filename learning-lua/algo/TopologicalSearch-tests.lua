local Graph = require "algo.Graph"
local TopologicalSearch = require "algo.TopologicalSearch"

local E = {}

local function debug(...)
  -- print(...)
end

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

local function reversed(a)
  local j = #a
  for i = 1, #a do
    if i >= j then
      break
    end
    a[i], a[j] = a[j], a[i]
    j = j - 1
  end
  return a
end

local function a2ordering(a)
  local ordering = {}
  for i, node in ipairs(a) do
    ordering[node] = i
  end
  return ordering
end

local function verify_scott_order(a)
  -- print(table.concat(a, "-"))
  local ordering = a2ordering(reversed(a))
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
  local ordering = a2ordering(reversed(a))
  assert(ordering.a == 1)
  assert(ordering.d < ordering.e)
end

local function verify_wiki_order(a)
  -- print(table.concat(a, "-"))
  local ordering = a2ordering(reversed(a))
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

local function topo_test(G, nav_spec, src, src_spec)
  local topo, a = TopologicalSearch:new(G, nav_spec, src_spec), {}
  for v in topo:iterate(src) do -- nodes in descending topological order
    a[#a + 1] = v
  end
  debug(table.concat(a, " <- "))
  return a
end

local function verify_lowest_topo_ele_in_1st_scc(G)
  local src_spec
  for i = 1, 11 do
    src_spec = {}
    for j = i, i + 11 do
      src_spec[#src_spec + 1] = tostring((j - 1) % 11 + 1)
    end
    local a = topo_test(G, nil, nil, src_spec)
    local is_part_of_1st_scc = false
    for _, v in ipairs {'1', '3', '5'} do
      if v == a[11] then
        is_part_of_1st_scc = true
        break
      end
    end
    assert(is_part_of_1st_scc, "Element of lowest topological order must be part of the 1st SCC")
  end
end

local function verify_lowest_topo_ele_on_transpose(G)
  assert(not G:is_transposed())
  G:transpose()
  assert(G:is_transposed())
  local src_spec
  for i = 1, 11 do
    src_spec = {}
    for j = i, i + 11 do
      src_spec[#src_spec + 1] = tostring((j - 1) % 11 + 1)
    end
    local a = topo_test(G, nil, nil, src_spec)
    local is_part_of_sink_scc = false
    for _, v in ipairs {'6', '8', '10'} do
      if v == a[11] then
        is_part_of_sink_scc = true
        break
      end
    end
    assert(is_part_of_sink_scc, "Element of lowest topological order after transpose must be part of the sink SCC")
  end
  G:transpose()
  assert(not G:is_transposed())
end

-- Algorithms Illuminated Part 2 by Prof. Tim Roughgarden
print("Testing descending topological iteration from Tim ...")
local G = load_edges {'1-3', '3-5', '5-1', '3-11', '5-9', '5-7', '11-6', '11-8', '8-6', '6-10', '10-8', '9-2', '9-4',
                      '2-4', '2-10', '4-7', '7-9'}
local nav_spec = { -- navigation preference
  ['3'] = {'5', '11'}, -- visit (3, 5) before (3, 11)
  ['5'] = {'7', '9'}, -- visit (5, 7) before (5, 9)
  ['9'] = {'4', '2', '8'} -- visit (9, 4) before (9, 2) before (9, 8)
}
topo_test(G, nav_spec) -- for the entire graph
topo_test(G, nav_spec, next(G)) -- for a single arbitrary source vertex only
local a = topo_test(G, nav_spec, '1') -- for a single specific source vertex
assert(table.concat(reversed(a), "-") == "1-3-11-5-7-9-2-10-8-6-4") -- ascending topological order

-- Equivalent, navigation order.
local nav_spec = { -- navigation preference
  ['3'] = {'5'}, -- visit (3, 5) before other edges
  ['5'] = {'7'}, -- visit (5, 7) before other edges
  ['9'] = {'4', '2'} -- visit (9, 4) before (9, 2) before other edges
}

local a = topo_test(G, nav_spec, '1') -- for a single specific source vertex
assert(table.concat(reversed(a), "-") == "1-3-11-5-7-9-2-10-8-6-4") -- ascending topological order

print("\nDFS from source vertices in ascending order on Tim's Figure 8.16 ...")
local src_spec = {}
for i = 1, 11 do
  src_spec[#src_spec + 1] = tostring(i)
end
local a = reversed(topo_test(G, nav_spec, nil, src_spec))
local s = table.concat(a, "-")
debug(s)
assert(s == "1-3-11-5-7-9-2-10-8-6-4")
print()

print("\nDFS from source vertices in descending order on Tim's Figure 8.16 ...")
local nav_spec = { -- navigation preference
  ['11'] = {'6', '8'}, -- visit (11, 6) before (11, 8)
  ['9'] = {'2', '4'} -- visit (9, 2) before (9, 4)
}

local a = reversed(topo_test(G, nav_spec, nil, reversed(src_spec)))
local s = table.concat(a, "-")
debug(s)
assert(s == "5-1-3-9-2-4-7-11-6-10-8")
print()

print("Verify the element of the lowest topological order must always be part of the 1st SCC ...")
verify_lowest_topo_ele_in_1st_scc(G)

print("\nVerify the element of the lowest topological order after tranpose ...")
assert(not G:is_ingress_built())
verify_lowest_topo_ele_on_transpose(G)
assert(G:is_ingress_built())

print("\nOther DFS tests on Tim's graph ...")
nav_spec = nil
local G = load_edges {'s-v', 's-w', 'v-w', 'v-t', 'w-t'}
local src = 's'
local a = topo_test(G, nav_spec, src)
assert(table.concat(reversed(a), "-") == "s-v-w-t")

print("Testing topological sorting example from Scott ...")
-- https://ecal.studentorg.berkeley.edu/files/ce191/CH05-DynamicProgramming.pdf by Prof. Scott Moura
local G = load_edges {'A-B', 'A-C', 'A-D', 'B-F', 'C-F', 'C-E', 'C-D', 'D-E', 'D-H', 'E-G', 'E-H', 'F-H', 'F-G', 'F-E',
                      'G-H'}
local src = 'A'
verify_scott_order(topo_test(G, nav_spec, src))

local G = load_edges {'a-b', 'a-c', 'a-d', 'd-e'}
local src = 'a'
verify_star_order(topo_test(G, nav_spec, src))

print("Testing topological sorting example from wikipedia ...")
-- https://en.wikipedia.org/wiki/Topological_sorting
local G = load_edges {'5-11', '7-11', '7-8', '11-2', '11-9', '11-10', '8-9', '3-8', '3-10'}
verify_wiki_order(topo_test(G))

local G = load_edges {'5-11', '7-11', '7-8', '11-2', '11-9', '11-10', '8-9', '3-8', '3-10'}
local nav_spec = {
  ['11'] = {'2', '9'}
}
local src_spec = {'5', '7', '3'}
verify_wiki_order(topo_test(G, nav_spec, nil, src_spec))
os.exit()
