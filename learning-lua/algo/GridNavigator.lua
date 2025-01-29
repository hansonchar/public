local Grid = require "algo.Grid"
local GridNavigator = {}

-- Navigates to the next position on the grid.
---@return (any?) val the next value on the grid; or nil if out of bound.
---@return (number?) node the next node on the grid; or nil if out of bound.
function GridNavigator:next()
  self.prev_node = self.curr_node
  self.curr_node = self.dir_func(self.grid, self.curr_node, 1)
  local val = self.val_func(self.curr_node)
  return val, self.curr_node
end

-- Reverts the previous navigation via GridNavigator:next().  Note that revert() is an inverse function of itself.
---@return (number) the previous node (ie position).
function GridNavigator:revert()
  self.curr_node, self.prev_node = self.prev_node, self.curr_node
  return self.curr_node
end

--- Makes a turn by the given degree.
---@param degree (number) can be one of 90, -90, 180, -180, 270 or -270.
function GridNavigator:turn(degree)
  assert(degree > 0 and degree < 360 or degree < 0 and degree > -360)
  degree = degree > 0 and degree or 360 + degree
  assert(degree == 90 or degree == 180 or degree == 270)
  local grid = self.grid
  local func_ds = {grid.north, grid.east, grid.south, grid.west}
  local dir_func = self.dir_func
  local idx
  for i, f in ipairs(func_ds) do
    if f == dir_func then
      idx = i
      break
    end
  end
  local delta = degree / 90
  assert(delta > 0 and delta < 4)
  idx = (idx + delta - 1) % #func_ds + 1
  self.dir_func = func_ds[idx]
end

---@param grid (table) the grid to navigate.
---@param start_node (number) the starting node on the grid.
---@param dir_func (function) the starting directional function; must be one of Grid:north, east, south or west.
---@param val_func (function) a value function that returns the value of a given node.
function GridNavigator:new(grid, start_node, dir_func, val_func)
  assert(Grid.isGrid(grid), "A grid must be specified")
  assert(dir_func == grid.north or dir_func == grid.east or dir_func == grid.south or dir_func == grid.west,
    "The directional function must be one of Grid.north, Grid.east, Grid.south or Grid.west")
  assert(val_func and type(val_func) == "function",
    "A function to retrieve the value of a given position must be specified")
  local o = {
    grid = grid,
    curr_node = start_node,
    dir_func = dir_func,
    val_func = val_func
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

return GridNavigator
