local Grid = require "algo.GridBase"

function Grid:manhattan_dist(u, v)
  local y1, x1 = self:coord(u)
  local y2, x2 = self:coord(v)
  return self:manhattan_dist_coord(y1, x1, y2, x2)
end

--- Returns a unique node number as a function of the given (y,x) coorindate
--- within the grid; or nil if (y, x) is outside the grid.
---@param y (number)
---@param x (number)
---@return (number?)
function Grid:node(y, x)
  if y <= self.height and x <= self.width then
    return (y << self._intern.wbits) + x
  end
end

---Inverse of Grid:node(y, x)
---@param node (number)
---@return (number) y, (number) x
function Grid:coord(node)
  return node >> self._intern.wbits, node & self._intern.wmask
end

function Grid.isGrid(o)
  local mt
  while true do
    mt = getmetatable(o)
    if mt == Grid then
      return true
    elseif not mt or mt == o then
      return false
    else
      o = mt -- check parent metatable
    end
  end
end

function Grid:new(width, height)
  assert(width > 0 and height > 0)
  local g = {
    width = width,
    height = height
  }
  local wbits = math.ceil(math.log(width + 1, 2))
  g._intern = {
    wbits = wbits,
    wmask = (1 << wbits) - 1
  }
  setmetatable(g, self)
  self.__index = self
  return g
end

return Grid
