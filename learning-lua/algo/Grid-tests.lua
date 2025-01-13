local grid = require "algo.Grid"

-- Tests west, north, east, south
local g = grid:new(10, 10)
local u = g:node(1, 1)
assert(not g:west(u))
assert(not g:north(u))
assert(g:east(u) == g:node(1, 2))
assert(g:east(u, 9) == g:node(1, 10))
assert(not g:east(u, 10))
assert(g:south(u) == g:node(2, 1))
assert(g:south(u, 9) == g:node(10, 1))
assert(not g:south(u, 10))

local u = g:node(10, 10)
assert(not g:east(u))
assert(not g:south(u))
assert(g:west(u) == g:node(10, 9))
assert(g:west(u, 9) == g:node(10, 1))
assert(not g:west(u, 10))
assert(g:north(u) == g:node(9, 10))
assert(g:north(u, 9) == g:node(1, 10))
assert(not g:north(u, 10))

-- Negative test with dy or dx is non-positive
local u = g:node(5, 5)
for _, f in ipairs {g.west, g.north, g.east, g.south} do
  assert(pcall(f, g, u, 2))
  assert(not pcall(f, g, u, 0))
  assert(not pcall(f, g, u, -1))
end

-- Test Grid:node() and Grid:coord()
for y = 1, g.height do
  for x = 1, g.width do
    local node = g:node(y, x)
    local y1, x1 = g:coord(node)
    assert(x == x1 and y == y1)
  end
end

os.exit()
