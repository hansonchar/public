local TarjanNorecur = require "algo.TarjanNorecur"
local Graph = require "algo.Graph"

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

local function sccs_of(G)
  local scc_count, sccs = 0, {}
  local scc_id
  for scc, id, count in TarjanNorecur:new(G):iterate() do
    debug(scc, id, count)
    if scc_id ~= id then
      scc_id = id
      scc_count = scc_count + 1
    end
    sccs[scc_count] = sccs[scc_count] or {}
    sccs[scc_count][scc] = true
  end
  return sccs
end

-- Depth-first search and linear graph algorithms by Tarjan, R.E.
print("Testing 1st SCC from Tarjan ...")
assert(#sccs_of(load_edges { 'A-B', 'B-C', 'C-D', 'D-E', 'E-F', 'E-H', 'F-A', 'F-G', 'G-D', 'G-B', 'H-A', 'H-C' }) == 1)

print("Testing 2nd SCC from Tarjan ...")
assert(#sccs_of(load_edges { "1-2", "2-3", "2-8", "3-4", "3-7", "4-5", "5-3", "5-6", "7-4", "7-6", "8-1", "8-7" }) == 3)

-- A strong-connectivity algorithm and its applications in data flow analysis by Micha Sharir.
print("Testing SCC from Micha ...")
assert(#sccs_of(load_edges { 'a-b', 'b-c', 'b-d', 'c-b', 'd-e', 'e-d', 'e-f', 'e-g', 'f-b', 'g-h', 'g-j', 'h-i', 'i-h',
  'i-l', 'j-i', 'j-k', 'k-j', 'l-i', 'l-k' }) == 4)

-- Introduction to Algorithms by Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, and Clifford Stein.
print("Testing SCC from CLRS ...")
assert(#sccs_of(load_edges { 'a-b', 'b-c', 'b-e', 'b-f', 'c-d', 'c-g', 'd-c', 'd-h', 'e-a', 'e-f', 'f-g', 'g-f', 'g-h',
  'h-h' }) == 4)

-- https://www.geeksforgeeks.org/strongly-connected-components/
print("Testing SCC from geeksforgeeks ...")
assert(#sccs_of(load_edges { '1-2', '2-3', '2-4', '3-4', '3-6', '4-1', '4-5', '5-6', '6-7', '7-5' }) == 2)

-- https://cseweb.ucsd.edu/classes/fa18/cse101-b/lec4.pdf by Miles Jones
print("Testing 1st SCC from Miles ...")
assert(#sccs_of(load_edges { 'A-B', 'B-C', 'B-F', 'D-A', 'D-E', 'E-B', 'E-C', 'E-H', 'G-E', 'H-F' }) == 8)

print("Testing 2nd SCC from Miles ...")
assert(#sccs_of(load_edges { 'A-B', 'A-F', 'B-C', 'C-F', 'C-I', 'D-C', 'D-G', 'E-H', 'E-K', 'F-B', 'G-D', 'H-B', 'H-I',
  'I-F', 'J-G', 'J-L', 'K-J', 'L-M', 'M-K' }) == 6)
print("Testing 3rd SCC from Miles ...")
assert(#sccs_of(load_edges { 'A-B', 'A-C', 'B-G', 'C-E', 'D-C', 'E-D', 'F-A', 'G-F' }) == 2)

-- https://cp-algorithms.com/graph/strongly-connected-components.html
print("Testing SCC from cp-algorithms ...")
assert(#sccs_of(load_edges { '0-1', '0-7', '1-2', '1-1', '2-1', '2-5', '3-2', '3-4', '4-9', '5-3', '5-6', '5-9', '6-2',
  '7-0', '7-6', '7-8', '8-6', '8-9', '9-4' }) == 4)

-- https://en.wikipedia.org/wiki/Strongly_connected_component
print("Testing SCC from wikipedia ...")
assert(#sccs_of(load_edges { 'a-b', 'b-c', 'b-f', 'b-e', 'c-d', 'c-g', 'd-c', 'd-h', 'e-a', 'e-f', 'f-g', 'g-f', 'h-d',
  'h-g' }) == 3)

print("Testing a linear SCC graph ...")
assert(#sccs_of(load_edges { "a-b", "b-c", "c-d", "d-e" }) == 5)

-- Algorithms Illuminated Part 2 by Prof. Tim Roughgarden
print("Testing SCC using Graph of Figure 8.16 by Tim ...")

assert(#sccs_of(load_edges { '1-3', '2-4', '2-10', '3-5', '3-11', '4-7', '5-1', '5-7', '5-9', '6-10', '7-9', '8-6',
  '9-2', '9-4', '9-8', '10-8', '11-6', '11-8' }) == 4)
