local Partition = require "algo.Partition"
local Selection = {}
Selection.__index = Selection

local DEBUG = require "algo.Debug":new(false)
local debug, debugf, concat = DEBUG.debug, DEBUG.debugf, DEBUG.concat

---Returns the median of the given five or less number of values.
---@param a any
---@param b any?
---@param c any?
---@param d any?
---@param e any?
---@return any median the median value.
---@return any pos position of the median value in the input.
function Selection.median_of_5(a, b, c, d, e, ...)
  assert(not ..., "At most five arguments")
  if not b then
    assert(not c and not d and not e)
    return assert(a, "At least one argument")
  elseif not c then
    assert(not d and not e)
    if a < b then
      return a, 1
    else
      return b, 2
    end
  elseif not d then
    assert(not e)
    d = d or -math.huge
    e = math.huge
  else
    e = e or -math.huge
  end
  local min, min2, min3 = math.huge, math.huge, math.huge
  local min_pos, min2_pos, min3_pos
  for pos, val in pairs {a, b, c, d, e} do
    if val < min then
      min3, min2, min = min2, min, val
      min3_pos, min2_pos, min_pos = min2_pos, min_pos, pos
    elseif val < min2 then
      min3, min2 = min2, val
      min3_pos, min2_pos = min2_pos, pos
    elseif val < min3 then
      min3, min3_pos = val, pos
    end
  end
  return min3, min3_pos
end

-- local function min(a, b)
--   return a < b and a or b
-- end

---Returns the median of the medians of group of at most 5 elements, recursively.
---@param ar (table) array of elements.
---@return (any) median the median of the medians of group of at most 5 elements, recursively.
---@return (number) position the position of the median of the medians in 'ar'.
function Selection.median_of_medians(ar)
  assert(#ar > 0)
  local ar_pos = {}
  -- array of medians, and their respective positions in the original input array.
  local medians, medians_pos = {}, {}
  repeat
    local groups_of_5 = math.ceil(#ar / 5)
    local start_pos, end_pos = 1, 5
    for _ = 1, groups_of_5 do
      end_pos = end_pos < #ar and end_pos or #ar
      local median, pos_1to5 = Selection.median_of_5(table.unpack(ar, start_pos, end_pos))
      medians[#medians + 1] = median
      local pos = pos_1to5 + start_pos - 1 -- from relative to absolute position in 'ar'.
      -- 'median_pos' is the position of 'median' in the original input array.
      local median_pos = ar_pos[pos] or pos -- the 'or' is applicable only during the first 'repeat' loop
      medians_pos[#medians_pos + 1] = median_pos
      debugf("median:%d of %s", medians[#medians], concat(ar, ",", start_pos, end_pos))
      start_pos, end_pos = start_pos + 5, end_pos + 5
    end
    debug()
    ar, ar_pos = medians, medians_pos
    medians, medians_pos = {}, {}
  until #ar == 1
  return ar[1], ar_pos[1]
end

---Select the kth smallest/greatest element of the given array via random pivot selection.
---This method currently assumes distinct values in the input array.
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
