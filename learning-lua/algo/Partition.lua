local DEBUG = require "algo.Debug":new(false)
local debugf, concat = DEBUG.debugf, DEBUG.concat

local Partition = {}
Partition.comp = function(a, b) -- default comparision function
  return a < b
end
Partition.__index = Partition

-- Courtesy of Algorithms Illuminated Part 1 by Tim Roughgarden.
-- Currently only supports array of distinct values.
---@param pivot_pos (number) position of the pivot in the array.
---@param ar (table) array of distinct values.
---@param start_pos (number?) starting position; default to 1.
---@param end_pos (number?) ending position; default to the size of the array.
---@return (number) pos the position of the pivot after the partition.
---@return (table) array partitioned by the pivot.
---@return (number) count the number of swaps performed.
function Partition:partition(pivot_pos, ar, start_pos, end_pos)
  debugf("partition: pivot_pos=%d, start_pos=%d, end_pos=%d, %s", pivot_pos, start_pos, end_pos,
    concat(ar, ","))
  local count = 0 -- number of swaps
  local pivot = ar[pivot_pos]
  start_pos = start_pos or 1
  end_pos = end_pos or #ar
  assert(start_pos > 0 and end_pos <= #ar)
  assert(pivot_pos >= start_pos and pivot_pos <= end_pos)
  if pivot_pos ~= start_pos then
    ar[start_pos], ar[pivot_pos] = ar[pivot_pos], ar[start_pos] -- move to the front
    count = count + 1
    debugf("swapped %d-%d: %s", start_pos, pivot_pos, concat(ar, ","))
  end
  -- Invariants:
  -- 1. anything between start_pos and i are less than pivot;
  -- 2. anything between i and j are greater than pivot;
  -- 3. anything greater than j (and up to end_pos) are unpartitioned.
  local pos = start_pos
  for j = start_pos + 1, end_pos do
    assert(pos <= j)
    if self.comp(ar[j], pivot) then
      pos = pos + 1
      if pos < j then
        ar[pos], ar[j] = ar[j], ar[pos]
        count = count + 1
        debugf("swapped %d-%d: %s", pos, j, concat(ar, ","))
      end
    end
  end -- endfor
  if pos > start_pos then
    ar[start_pos], ar[pos] = ar[pos], ar[start_pos]
    count = count + 1
    debugf("swapped %d-%d: %s", start_pos, pos, concat(ar, ","))
  end
  return pos, ar, count
end

---@param comp (function?) element comparision function; optional.
---@return table
function Partition:new(comp)
  if not comp then
    return self
  end

  return setmetatable({
    comp = comp
  }, self)
end

return Partition
