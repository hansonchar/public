-- Reference: https://opendatastructures.org
-- Courtesy of https://en.wikipedia.org/wiki/J._W._J._Williams
local BinaryHeap = {}

--- Maintain the heap invariant by repeatedly swapping with the parent if necessary.
---@param i (number) the starting position; default to the last element.
function BinaryHeap:bubble_up(i)
  i = i or #self
  local a, comp = self, self.comp
  while i > 1 do
    local p = i >> 1 -- parent
    if comp(a[p], a[i]) then -- value stored at index i is not smaller than that of its parent
      return
    end
    a[i], a[p] = a[p], a[i] -- swap value with parent
    i = p -- repeatedly
  end
end

--- Maintain the heap invariant as necessary by repeatedly
--- swapping with the smallest/largest of the two children.
---@param i (number) the starting position; default to the root.
function BinaryHeap:trickle_down(i)
  i = i or 1
  local left, a, comp = i << 1, self, self.comp
  while left <= #a do
    local right = left + 1
    local right = right <= #a and right or left -- 'right' is out of bound
    local child = comp(a[left], a[right]) and left or right
    if comp(a[i], a[child]) then
      return
    end
    a[i], a[child] = a[child], a[i]
    i = child
    left = i << 1
  end
end

--- Move the last element to the root, and then maintain the heap invariant as necessary by repeatedly
--- swapping with the smallest/largest of the two children.
function BinaryHeap:remove()
  local a = self
  local root = a[1]
  if #a == 1 then
    a[1] = nil
  else
    a[1], a[#a] = a[#a], nil
    a:trickle_down()
  end
  return root
end

--- Append the given value to the internal array, and then maintain the heap invariant by
--- repeatedly swapping with the parent if necessary.
---@param x any the value to be added to the heap
function BinaryHeap:add(x)
  local a = self
  a[#a + 1] = x
  a:bubble_up()
  return a
end

function BinaryHeap:class(t, comp)
  t = t or {}
  local mt = { -- used to store the heap instance specific comparision function
    comp = comp or function(a, b) -- default to min heap
      return a <= b
    end
  }
  setmetatable(mt, self)
  self.__index = self

  setmetatable(t, mt)
  mt.__index = mt
  return t
end

--- Build a heap from the given array.
--- Starting from the lowest level and moving upwards, sift the root of each subtree downward
--- as in the deletion algorithm until the heap property is restored.
--- Courtesy of https://en.wikipedia.org/wiki/Robert_W._Floyd
---@param a (table) an array of elements in arbitrary order
function BinaryHeap:heapify()
  local a = self
  local parent = #a >> 1
  local left = parent << 1
  while parent > 0 do
    a:trickle_down(parent)
    left = left - 2
    parent = left >> 1
  end
  return a
end

function BinaryHeap:new(a, comp)
  a = a or {}
  return self:class(a, comp):heapify()
end

function BinaryHeap:newMaxHeap(a) -- a convenient method to build a max heap
  return self:new(a, function(x, y)
    return x >= y
  end)
end

function BinaryHeap:size()
  return #self
end

function BinaryHeap:dump() -- debugging
  return table.concat(self, ",")
end

function BinaryHeap:verify() -- debugging: verify the heap invariant holds
  local a, comp = self, self.comp
  for i = 1, #a do
    local left = i << 1
    if left > #a then
      return
    end
    local right = left + 1
    right = right > #a and left or right
    local child = comp(a[left], a[right]) and left or right
    assert(comp(a[i], a[child]))
  end
end
return BinaryHeap
