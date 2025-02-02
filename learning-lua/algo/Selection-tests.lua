local Selection = require "algo.Selection"
local DEBUG = require "algo.Debug":new(false)
local debug, debugf, concat = DEBUG.debug, DEBUG.debugf, DEBUG.concat
local S = Selection:new()

local function rselect_tests()
  print("Running rselect_tests ...")
  local ar = {6, 8, 9, 2}
  local val, ar_o, count = S:rselect(ar, 2)
  assert(val == 6, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)

  local ar = {6, 8, 9, 2}
  local val, ar_o, count = S:rselect(ar, 3)
  assert(val == 8, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)

  local ar = {3, 8, 2, 5, 1, 4, 7, 6}
  local val, ar_o, count = S:rselect(ar, #ar >> 1)
  assert(val == 4, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)

  local ar = {3, 8, 2, 5, 1, 4, 7, 6}
  local val, ar_o, count = S:rselect(ar, #ar >> 1)
  assert(val == 4, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)
end

local function median_of_5_tests()
  print("Running median_of_5_tests ...")
  local ar = {5, 2, 1, 4, 3}
  local median, pos = S.median_of_5(table.unpack(ar))
  debugf("Median of %s: %d", concat(ar, ","), median)
  assert(median == 3 and pos == #ar)

  local ar = {5, 2, 1, 4}
  local median, pos = S.median_of_5(table.unpack(ar))
  debugf("Median of %s: %d", concat(ar, ","), median)
  assert(median == 2 and pos == 2)

  local ar = {5, 3, 1, 2}
  local median, pos = S.median_of_5(table.unpack(ar))
  debugf("Median of %s: %d", concat(ar, ","), median)
  assert(median == 2 and pos == #ar)

  local ar = {5, 1, 2}
  local median, pos = S.median_of_5(table.unpack(ar))
  debugf("Median of %s: %d", concat(ar, ","), median)
  assert(median == 2 and pos == #ar)

  local ar = {5, 1}
  local median, pos = S.median_of_5(table.unpack(ar))
  debugf("Median of %s: %d", concat(ar, ","), median)
  assert(median == 1 and pos == #ar)

  local ok, err = pcall(S.median_of_5)
  assert(not ok)
  assert(err:match("At least one argument"))
  debug(err)

  local ok, err = pcall(S.median_of_5, 1, 2, 3, 4, 5, 6)
  assert(not ok)
  assert(err:match("At most five arguments"))
  debug(err)
end

local function median_of_medians_tests()
  print("Running median_of_medians_tests ...")
  local mom = S.median_of_medians({1, 3, 6})
  assert(mom == 3)

  local ar = {3, 8, 2, 5, 1, 4, 7, 6}
  local median = S.median_of_medians(ar)
  assert(median == 3)

  local ar = {11, 6, 10, 2, 15, 8, 1, 7, 14, 3, 9, 12, 4, 5, 13}
  local median, pos = S.median_of_medians(ar)
  assert(median == 9 and pos == 11)

  local ar = {11, 6, 10, 2, 15, 8, 1, 7, 14, 3, 9, 12, 4, 5, 13}
  local median, pos = S.median_of_medians(ar, #ar >> 1)
  assert(median == 5 and pos == 14)

  local ar = {12, 15, 11, 2, 9, 5, 0, 7, 3, 21, 44, 40, 1, 18, 20, 32, 19, 35, 37, 39,
    13, 16, 14, 8, 10, 26, 6, 33, 4, 27, 49, 46, 52, 25, 51, 34, 43, 56, 72, 79,
    17, 23, 24, 28, 29, 30, 31, 36, 42, 47, 50, 55, 58, 60, 63, 65, 66, 67, 81, 83,
    22, 45, 38, 53, 61, 41, 62, 82, 54, 48, 59, 57, 71, 78, 64, 80, 70, 76, 85, 87,
    96, 95, 94, 86, 89, 69, 68, 97, 73, 92, 74, 88, 99, 84, 75, 90, 77, 93, 98, 91,
  }
  local median, pos = S.median_of_medians(ar)
  assert(median == 36 and pos == 48)
end

local function dselect_tests()
  print("Running dselect_tests ...")
  local ar = {6, 8, 9, 2}
  local val, ar_o, count = S:dselect(ar, 2)
  assert(val == 6, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)

  local ar = {6, 8, 9, 2}
  local val, ar_o, count = S:dselect(ar, 3)
  assert(val == 8, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)

  local ar = {3, 8, 2, 5, 1, 4, 7, 6}
  local val, ar_o, count = S:dselect(ar, #ar >> 1)
  assert(val == 4, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)

  local ar = {3, 8, 2, 5, 1, 4, 7, 6}
  local val, ar_o, count = S:dselect(ar, #ar >> 1)
  assert(val == 4, val)
  debugf("Resultant array: %s, swaps: %d", concat(ar_o, ","), count)
end


rselect_tests()
median_of_5_tests()
median_of_medians_tests()
dselect_tests()
