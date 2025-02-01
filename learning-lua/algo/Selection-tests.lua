local Selection = require "algo.Selection"
local DEBUG = require "algo.Debug":new(false)
local debugf, concat = DEBUG.debugf, DEBUG.concat
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
