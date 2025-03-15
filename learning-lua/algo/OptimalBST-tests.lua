local OptimalBST = require "algo.OptimalBST"
local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

local function test_case1()
  local freq = {.8, .1, .1}
  local optimalBst = OptimalBST:new(freq)
  local min_search_time, memory = optimalBst:find_best()
  debugf("min average search time: %s", min_search_time)
  assert(min_search_time == 1.3)

  local depths = optimalBst:reconstruct_optimal_depths(memory)
  assert("1,2,3" == table.concat(depths, ","))
end

-- Programming Problem 17.8: Optimal Binary Search Trees
-- at https://www.algorithmsilluminated.org/
local function problem17_8()
  local access_counts = {2, 8, 2, 5, 5, 2, 8, 3, 6, 1, 1, 6, 3, 2, 6, 7, 4, 63, 2, 9, 10, 1, 60, 5, 2, 7, 34, 11, 31, 76, 21, 6, 8, 1, 81, 37, 15, 6, 8, 24, 12, 18, 42, 8, 51, 21, 8, 6, 5, 7}
  -- local a_sorted = {}
  local freq = {}

  -- Sum all access counts.
  local total_access_count = 0
  for i, v in ipairs(access_counts) do
    -- a_sorted[i] = i
    total_access_count = total_access_count + v
  end

  -- Derive the access frequency for each value.
  for i, v in ipairs(access_counts) do
    freq[i] = v / total_access_count
  end

  -- Verify that all frequencies sum to 1.
  local total_freq = 0
  for i, v in ipairs(freq) do
    total_freq = total_freq + v
  end
  assert(total_freq == 1)

  local optimalBst = OptimalBST:new(freq)
  local min_avg_search_time, memory = optimalBst:find_best()
  debugf("total number of accesses: %s", total_access_count) -- total number of accesses: 767
  debugf("min average search time: %s", min_avg_search_time) -- min average search time: 3.6245110821382
  debugf("min total search time: %s", total_access_count * min_avg_search_time) -- min total search time: 2780.0
  assert(total_access_count * min_avg_search_time == 2780)
  local depths = optimalBst:reconstruct_optimal_depths(memory)

  local total_search_time = 0
  for i, depth in ipairs(depths) do
    total_search_time = total_search_time + depth * access_counts[i]
  end
  debugf("total_search_time: %s", total_search_time)
  assert(total_access_count * min_avg_search_time == total_search_time)
  assert(table.concat(depths, ",") ==
    "7,6,7,5,6,7,4,7,6,7,8,5,8,9,7,6,7,3,5,4,5,6,2,6,7,5,4,6,5,3,4,6,5,6,1,4,5,7,6,3,5,4,2,4,3,4,6,5,7,6")
  -- The BST looks like:
  --                                                                     1
  --                                             2                                       2
  --                                   3                       3                   3         3
  --             4                         4             4       4         4           4   4   4
  --       5               5             5   5         5     5       5       5       5             5
  --   6     6       6             6           6   6       6       6   6         6               6     6
  -- 7   7     7   7   7         7   7               7                          7                    7
  --                     8    8
  --                            9
end

test_case1()
debug()
problem17_8()

os.exit()
