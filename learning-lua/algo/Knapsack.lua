local Knapsack = {}
Knapsack.__index = Knapsack

local function _find_max(self, C, n, memory)
  if C == 0 or n == 0 then
    return 0, memory
  end
  if memory[C] and memory[C][n] then
    return memory[C][n], memory
  end
  local val_exclude = _find_max(self, C, n - 1, memory) -- exclude item n.
  local item = self.items[n]
  local val_include = 0
  if item.size <= C then -- include item n, if the capacity permits.
    val_include = _find_max(self, C - item.size, n - 1, memory) + item.val
  end
  -- memoize the result for the current configuration.
  memory[C] = memory[C] or {}
  if val_include > val_exclude then
    memory[C][n] = val_include
    return val_include, memory
  else
    memory[C][n] = val_exclude
    return val_exclude, memory
  end
end

---@return number maximum maximum value of items that can be put into the knapsack.
---@return table memory maximum value of each specific configuration of capacity, and the number of items.
function Knapsack:find_max()
  return _find_max(self, self.capacity, #self.items, {})
end

-- Reconstruct the set of items selected from the memory of thee max value
-- attained given a specific configuration.
---@param memory table previously returned as the second parameter from running `Knapsack:find_max()`.
---@return table selected items in the knapsack that result in the maximum value.
function Knapsack:reconstruct_items(memory)
  local selected = {}
  local C, n = self.capacity, #self.items
  while C > 0 and n > 0 do
    local max_val = memory[C][n]
    local val_exclude_n = memory[C][n - 1] or 0
    if max_val == val_exclude_n then -- item n was excluded
    else -- item n was included
      selected[#selected + 1] = n
      C = C - self.items[n].size
    end
    n = n - 1
  end
  return selected
end

---Creates a new knapsack.
---@param capacity number total capacity of the knapsack.
---@param items table an array of items each has a `val` and `size`.
---@return table knapsack.
function Knapsack:new(capacity, items)
  return setmetatable({capacity = capacity, items = items}, self)
end

return Knapsack
