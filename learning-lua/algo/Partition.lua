local DEBUG = require "algo.Debug":new(false)
local debugf, concat = DEBUG.debugf, DEBUG.concat

local Partition = {}
Partition.comp = function(a, b) -- default comparision function.
  return a <= b -- support non-distinct values.
end
Partition.__index = Partition

-- Courtesy of Algorithms Illuminated Part 1 by Tim Roughgarden.
---@param pivot_pos (number) position of the pivot in the array.
---@param ar (table) array of distinct values.
---@param start_pos (number?) starting position; default to 1.
---@param end_pos (number?) ending position; default to the size of the array.
---@return (number) i the position of the pivot after the partition.
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
  -- 1. anything between start_pos and i are less than or equal to pivot;
  -- 2. anything between i and j are greater than pivot;
  -- 3. anything greater than j (and up to end_pos) are unpartitioned.
  local i = start_pos
  for j = start_pos + 1, end_pos do -- advance the new frontier
    assert(i <= j)
    -- If the new element is greater than the pivot, we keep going as it is naturally
    -- left with the big guys on the right.
    if self.comp(ar[j], pivot) then
      -- Otherwise, we want to move it to the next slot for the small guys on the left.
      i = i + 1
      -- If i == j, then there is no big guys yet; so we are good.
      if i < j then
        -- Otherwise, the element at i must be a big guy.
        -- So we swap them to maintain the invariants.
        ar[i], ar[j] = ar[j], ar[i]
        count = count + 1
        debugf("swapped %d-%d: %s", i, j, concat(ar, ","))
      end
    end
  end -- endfor
  -- Now that we've grouped all the small and big guys, we
  -- can swap the pivot to it's rightful position and call it a day.
  if i > start_pos then
    ar[start_pos], ar[i] = ar[i], ar[start_pos] -- last swap
    count = count + 1
    debugf("swapped %d-%d: %s", start_pos, i, concat(ar, ","))
  end
  return i, ar, count
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
