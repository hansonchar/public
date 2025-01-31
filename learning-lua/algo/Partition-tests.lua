local Partition = require "algo.Partition"
local P = Partition:new()
local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

local pos, a, count = P:partition(4, {3, 8, 2, 5, 1, 4, 7, 6}, 2, 7)
local s = table.concat(a, ",")
assert(pos == 5)
assert(s == '3,4,2,1,5,8,7,6')
assert(count == 4)
debugf("pos: %d, a: %s, count: %s", pos, s, count)

local pos, a, count = P:partition(1, {5})
local s = table.concat(a, ",")
assert(pos == 1)
assert(s == '5', s)
assert(count == 0)

local pos, a, count = P:partition(1, {3, 8, 2, 5, 1, 4, 7, 6})
local s = table.concat(a, ",")
assert(pos == 3)
assert(s == '1,2,3,5,8,4,7,6', s)
assert(count == 3)

local pos, a, count = P:partition(2, {3, 8, 2, 5, 1, 4, 7, 6})
local s = table.concat(a, ",")
assert(pos == 8)
assert(s == '6,3,2,5,1,4,7,8', s)
assert(count == 2)

local pos, a, count = P:partition(1, {3, 4, 5, 6, 7, 8, 1, 2})
local s = table.concat(a, ",")
assert(pos == 3)
assert(s == '2,1,3,6,7,8,4,5', s)
assert(count == 3)

for i = 1, 8 do
  local a = {1, 2, 3, 4, 5, 6, 7, 8}
  local pos, a, count = P:partition(i, a)
  local s = table.concat(a, ",")
  debug(i .. ':', s, 'count: ' .. count, 'pivot pos: ' .. pos)
  assert(pos == i)
end

for i = 1, 8 do
  local a = {8, 7, 6, 5, 4, 3, 2, 1}
  local pos, a, count = P:partition(i, a)
  local s = table.concat(a, ",")
  debug(i .. ':', s, 'count: ' .. count, 'pivot pos: ' .. pos)
  assert(pos == 8 - i + 1)
end

-- Worst case:
local pos, a, count = P:partition(2, {8, 7, 6, 5, 4, 3, 2, 1})
local s = table.concat(a, ",")
assert(pos == 7)
assert(s == '1,6,5,4,3,2,7,8', s)
assert(count == 8)

return Partition
