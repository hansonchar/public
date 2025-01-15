local Grid = require "algo.Grid"
local GridNavigator = require "algo.GridNavigator"

local function load_grid_vals()
  -- Source: Advant of Code 2024 Day 6
  local input = {"....#.....", ".........#", "..........", "..#.......", ".......#..", "..........", ".#..^.....",
                 "........#.", "#.........", "......#..."}

  local height = #input
  local width = #input[1]
  local y, x
  for i, line in ipairs(input) do
    local pos = line:find('%^')
    if pos then
      y, x = i, pos
    end
  end
  local grid = Grid:new(width, height)
  return input, grid, grid:node(y, x)
end

local function test_navigation()
  local count, obstacles = 0, 0
  local input, g, start_node = load_grid_vals()
  -- print(string.format("Starting at (%d,%d)", g:coord(start_node)))
  local nav = GridNavigator:new(g, start_node, g.north, function(node)
    if node then
      local y, x = g:coord(node)
      return string.sub(input[y], x, x)
    end
  end)
  local val, node = nav:next()
  while val do
    local y, x = g:coord(node)
    -- print(string.format("(%d,%d):%s", y, x, val))
    if val == '#' then
      obstacles = obstacles + 1
      node = nav:revert()
      nav:turn(90)
    else
      count = count + 1
    end
    val, node = nav:next()
  end

  -- print(string.format("obstacles: %d, tiles: %d", obstacles, count))
  assert(obstacles == 10)
  assert(count == 44)
end

test_navigation()

os.exit()
