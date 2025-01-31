-- Reference: https://opendatastructures.org
-- Courtesy of https://en.wikipedia.org/wiki/J._W._J._Williams
local BinaryHeap = {}

local function swap(a, i, j)
  a[i], a[j] = a[j], a[i]
  a[i].pos, a[j].pos = i, j
end

--- Maintain the heap invariant by repeatedly swapping with the parent if necessary.
---@param self (table) the binary heap
---@param i (number?) the starting position; default to the last element.
local function bubble_up(self, i)
  i = i or #self
  local a, comp = self, self.comp
  while i > 1 do
    local p = i >> 1 -- parent
    if comp(a[p].val, a[i].val) then -- value stored at index i is not smaller than that of its parent
      return
    end
    swap(a, i, p) -- swap with parent
    i = p -- repeatedly
  end
end

--- Maintain the heap invariant as necessary by repeatedly
--- swapping with the smallest/largest of the two children.
---@param self (table) the binary heap
---@param i (number) the starting position; default to the root.
local function trickle_down(self, i)
  i = i or 1
  local left, a, comp = i << 1, self, self.comp
  while left <= #a do
    local right = left + 1
    local right = right <= #a and right or left -- 'right' is out of bound
    local child = comp(a[left].val, a[right].val) and left or right
    if comp(a[i].val, a[child].val) then
      return
    end
    swap(a, i, child)
    i = child
    left = i << 1
  end
end

--- Move the last element to the root, and then maintain the heap invariant as necessary by repeatedly
--- swapping with the smallest/largest of the two children.
function BinaryHeap:remove(i)
  if not i then
    if self:empty() then
      return
    else
      i = 1
    end
  end
  local a = self
  assert(0 < i and i <= #a, "index out of bound")
  local root = a[i]
  if #a == i then
    a[i] = nil
  else
    a[i], a[#a] = a[#a], nil
    a[i].pos = i
    trickle_down(a, i)
  end
  return root.val
end

function BinaryHeap:top()
  return self[1].val
end

--- Append the given value to the internal array, and then maintain the heap invariant by
--- repeatedly swapping with the parent if necessary.
---@param x any the value to be added to the heap
---@return (table) a reference to the entry added
function BinaryHeap:add(x)
  assert(x, "nil not allowed")
  local a = self
  local pos = #a + 1
  local entry = {
    pos = pos,
    val = x
  }
  a[pos] = entry
  bubble_up(a)
  return entry
end

--- Build a heap from the given array.
--- Starting from the lowest level and moving upwards, sift the root of each subtree downward
--- as in the deletion algorithm until the heap property is restored.
--- Courtesy of https://en.wikipedia.org/wiki/Robert_W._Floyd
---@param self (table) the binary heap but with an array of elements in arbitrary order
local function heapify(self)
  local a = self
  local parent = #a >> 1
  local left = parent << 1
  while parent > 0 do
    trickle_down(a, parent)
    left = left - 2
    parent = left >> 1
  end
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

function BinaryHeap:new(a, comp)
  a = a or {}
  for i, val in ipairs(a) do
    a[i] = {
      pos = i,
      val = a[i]
    }
  end
  return heapify(self:class(a, comp))
end

function BinaryHeap:newMaxHeap(a) -- a convenient method to build a max heap
  return self:new(a, function(x, y)
    return x >= y
  end)
end

function BinaryHeap:size()
  return #self
end

function BinaryHeap:empty()
  return #self == 0
end

function BinaryHeap:dump() -- debugging
  local a = {}
  for i, ele in ipairs(self) do
    a[i] = ele.val
    assert(ele.pos == i)
  end
  return table.concat(a, ",")
end

function BinaryHeap:verify() -- debugging: verify the heap invariant holds
  local a, comp = self, self.comp
  for i = 1, #a do
    assert(a[i].pos == i)
    local left = i << 1
    if left > #a then
      return
    end
    assert(a[left].pos == left)
    local right = left + 1
    right = right > #a and left or right
    assert(a[right].pos == right)
    local child = comp(a[left].val, a[right].val) and left or right
    assert(comp(a[i].val, a[child].val))
  end
end

return BinaryHeap

-- Interesting:
-- https://github.com/TheAlgorithms/Lua/blob/main/src/data_structures/heap.lua
-- https://web.archive.org/web/20240102194253/http://lua-users.org/wiki/ObjectOrientationTutorial
