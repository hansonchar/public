local Selection = require "algo.Selection"
local DEBUG = require "algo.Debug":new(false)
local debug, debugf, concat = DEBUG.debug, DEBUG.debugf, DEBUG.concat
local S = Selection:new()

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

local ar = {5, 2, 1, 4, 3}
local median = S.median_of_5(table.unpack(ar))
debugf("Median of %s: %d", concat(ar, ","), median)
assert(median == 3)

local ar = {5, 2, 1, 4}
local median = S.median_of_5(table.unpack(ar))
debugf("Median of %s: %d", concat(ar, ","), median)
assert(median == 2)

local ar = {5, 3, 1, 2}
local median = S.median_of_5(table.unpack(ar))
debugf("Median of %s: %d", concat(ar, ","), median)
assert(median == 2)

local ar = {5, 1, 2}
local median = S.median_of_5(table.unpack(ar))
debugf("Median of %s: %d", concat(ar, ","), median)
assert(median == 2)

local ar = {5, 1}
local median = S.median_of_5(table.unpack(ar))
debugf("Median of %s: %d", concat(ar, ","), median)
assert(median == 1)

local ok, err = pcall(S.median_of_5)
assert(not ok)
assert(err:match("At least one argument"))
debug(err)

local ok, err = pcall(S.median_of_5, 1, 2, 3, 4, 5, 6)
assert(not ok)
assert(err:match("At most five arguments"))
debug(err)
