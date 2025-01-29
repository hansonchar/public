local Itertool = {}

local function combinationsA(a, k, chosen, pos)
  if #a - pos + 1 >= k - #chosen then -- don't bother if there aren't enough items
    if #chosen == k then
      coroutine.yield(chosen) -- n items chosen
    else
      chosen[#chosen + 1] = a[pos]
      combinationsA(a, k, chosen, pos + 1) -- include a[pos]
      table.remove(chosen)
      combinationsA(a, k, chosen, pos + 1) -- exclude a[pos]
    end
  end
end

--- Iterates through all combinations of choosing k elements from the given array.
---@param a (table) array.
---@param k (number) the number of elements to choose.
function Itertool.combinations(a, k)
  return coroutine.wrap(function()
    combinationsA(a, k, {}, 1)
  end)
end

-- Example:
-- for c in Itertool.combinations({'a', 'b', 'c', 'd', 'e'}, 3) do
--   print(table.concat(c, ","))
-- end

return Itertool