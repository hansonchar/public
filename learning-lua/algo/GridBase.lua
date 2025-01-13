local Grid = {}

local function move_y(grid, y, x, dy)
  local y1 = y + dy
  if y1 > 0 and y1 <= grid.height then
    return grid:node(y1, x)
  end
end

local function move_x(grid, y, x, dx)
  local x1 = x + dx
  if x1 > 0 and x1 <= grid.width then
    return grid:node(y, x1)
  end
end

function Grid:up(y, x, dy)
  dy = dy or 1
  assert(dy > 0)
  return move_y(self, y, x, -dy)
end

function Grid:north(node, dy)
  local y, x = self:coord(node)
  return self:up(y, x, dy)
end

function Grid:down(y, x, dy)
  dy = dy or 1
  assert(dy > 0)
  return move_y(self, y, x, dy)
end

function Grid:south(node, dy)
  local y, x = self:coord(node)
  return self:down(y, x, dy)
end

function Grid:left(y, x, dx)
  dx = dx or 1
  assert(dx > 0)
  return move_x(self, y, x, -dx)
end

function Grid:west(node, dx)
  local y, x = self:coord(node)
  return self:left(y, x, dx)
end

function Grid:right(y, x, dx)
  dx = dx or 1
  assert(dx > 0)
  return move_x(self, y, x, dx)
end

function Grid:east(node, dx)
  local y, x = self:coord(node)
  return self:right(y, x, dx)
end

function Grid:manhattan_dist_coord(y1, x1, y2, x2)
  return math.abs(y1 - y2) + math.abs(x1 - x2)
end

return Grid
