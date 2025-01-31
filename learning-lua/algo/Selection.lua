local Partition = require "algo.Partition"
local Selection = {}
Selection.__index = Selection

---Select the kth smallest/greatest element of the given array via random pivot selection.
---Currently only supports distinct values in the array.
---@param ar (table) array the input array which can get mutated as a side effect.
---@param k (number) the kth smallest/greatest.
---@param start_pos (number?) starting position; default to 1.
---@param end_pos (number?) ending position; default to the size of the array.
---@param count (number?) the number of swaps performed so far; default to zero.
---@return (any) kth_value the value of the kth smallest/largest element.
---@return (table) array the mutated array.
---@return (number) count total number of swaps performed.
function Selection:rselect(ar, k, start_pos, end_pos, count)
  local total_count = count or 0
  start_pos = start_pos or 1
  end_pos = end_pos or #ar
  assert(start_pos > 0 and start_pos <= end_pos and end_pos <= #ar)
  assert(k > 0 and k <= end_pos - start_pos + 1)
  local P <const> = self.Partition or Partition
  -- Note math.random(a, b) would fail if a == b.
  local pivot_pos <const> = start_pos < end_pos and math.random(start_pos, end_pos) or start_pos
  local pos <const>, ar, count = P:partition(pivot_pos, ar, start_pos, end_pos)
  total_count = total_count + count
  local k_pos <const> = start_pos + k - 1
  if pos == k_pos then -- so lucky!
    return ar[k_pos], ar, total_count
  elseif pos < k_pos then
    return self:rselect(ar, k_pos - pos, pos + 1, end_pos, total_count)
  else -- pos > k_pos
    return self:rselect(ar, k, start_pos, pos - 1, total_count)
  end
end

---@param comp (function?) element comparision function; optional.
---@return (table)
function Selection:new(comp)
  if not comp then
    return self -- no custom comparision function, so no need to create any instance
  end
  local o = { -- create a new instance to hold the custom function
    Partition = Partition:new(comp)
  }
  return setmetatable(o, self)
end

return Selection

-- Can check tail recursiveness via:
--  luac -l algo/Selection.lua
