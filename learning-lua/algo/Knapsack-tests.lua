local Knapsack = require "algo.Knapsack"
local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

local items <const> = {
  {val = 3, size = 4},
  {val = 2, size = 3},
  {val = 4, size = 2},
  {val = 4, size = 3}
}
local ks = Knapsack:new(6, items)

local max_val, memory = ks:find_max()
local selected = ks:reconstruct_items(memory)
debugf("max value: %d", max_val)
assert(max_val == 8)
debugf(string.format("items: %s", table.concat(selected, ",")))
assert(#selected == 2)
assert(max_val == items[selected[1]].val + items[selected[2]].val)

os.exit()
