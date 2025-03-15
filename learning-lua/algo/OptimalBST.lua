local OptimalBST = {}
OptimalBST.__index = OptimalBST

local function _find_min_avg_search_time(self, from, to, depth, memory)
  if from == to then
    return self.access_freq[from] * depth
  end
  assert(from < to)
  memory[depth] = memory[depth] or {}
  memory[depth][from] = memory[depth][from] or {}
  if memory[depth][from][to] then
    return memory[depth][from][to] -- already cached.
  end
  local min_search_time = math.huge
  for i = from, to do
    local search_time = self.access_freq[i] * depth -- pick node i as the root at with the given depth.
    if from < i then -- add the min avg search time of the left subtree of node i.
      search_time = search_time + _find_min_avg_search_time(self, from, i - 1, depth + 1, memory)
    end
    if i < to then -- add the min avg search time of the right subtree of node i.
      search_time = search_time + _find_min_avg_search_time(self, i + 1, to, depth + 1, memory)
    end
    min_search_time = search_time < min_search_time and search_time or min_search_time
  end
  
  memory[depth][from][to] = min_search_time -- cache it.
  return min_search_time
end

---Finds the binary search tree with the minimal search time on average,
---based on access frequencies of individual values.
---@return number min_avg_search_time minimal search time on average.
---@return table memory that can be used to reconstruct the optimal binary search tree.
function OptimalBST:find_best()
  local memory = {}
  return _find_min_avg_search_time(self, 1, #self.access_freq, 1, memory), memory
end

local function _reconstruct_optimal_depths(self, memory, bst, from, to, depth)
  if from == to then
    bst[from] = depth
    return
  end
  local min_search_time = memory[depth][from][to]
  for i = from, to do
    local search_time = self.access_freq[i] * depth
    if search_time <= min_search_time then
      if from < i then
        if from == i - 1 then
          search_time = search_time + self.access_freq[from] * (depth + 1)
        else
          search_time = search_time + memory[depth + 1][from][i - 1]
        end
      end
      if search_time <= min_search_time then
        if i < to then
          if i + 1 == to then
            search_time = search_time + self.access_freq[to] * (depth + 1)
          else
            search_time = search_time + memory[depth + 1][i + 1][to]
          end
        end
        assert(search_time >= min_search_time)
        if search_time == min_search_time then
          bst[i] = depth
          if from < i then
            _reconstruct_optimal_depths(self, memory, bst, from, i - 1, depth + 1)
          end
          if i < to then
            _reconstruct_optimal_depths(self, memory, bst, i + 1, to, depth + 1)
          end
          return
        end
      end
    end
  end
  assert(false, "Should never get here.")
end

---Reconstructs the optimal binary search tree.
---@param memory table the second value previously returned from `OptimalBST:find_best()`.
---@return table optimal_depths an array of optimal depths that correspond to the elements in the original input array, `access_freq`, passed to `OptimalBST:new()`.
function OptimalBST:reconstruct_optimal_depths(memory)
  local bst = {}
  _reconstruct_optimal_depths(self, memory, bst, 1, #self.access_freq, 1)
  return bst
end

---@param access_freq table access frequencies of an array of values, presumably those values have already been sorted in ascending order.
---@return table optimalBST an instance of the OptimalBST algorithm.
function OptimalBST:new(access_freq)
  return setmetatable({access_freq = access_freq}, self)
end

return OptimalBST
