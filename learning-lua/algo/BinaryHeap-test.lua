local BinaryHeap = require "algo.BinaryHeap"

local h = BinaryHeap:new()

local nine = h:add('9')
assert(nine.pos == 1 and nine.val == '9')

local eight = h:add('8')
assert(eight.pos == 1 and eight.val == '8')
assert(nine.pos == 2 and nine.val == '9')

local seven = h:add('7')
assert(seven.pos == 1 and seven.val == '7')
assert(nine.pos == 2 and nine.val == '9')
assert(eight.pos == 3 and eight.val == '8')

local six = h:add('6')
assert(six.pos == 1 and six.val == '6')
assert(seven.pos == 2 and seven.val == '7')
assert(eight.pos == 3 and eight.val == '8')
assert(nine.pos == 4 and nine.val == '9')

local five = h:add('5')
assert(five.pos == 1 and five.val == '5')
assert(six.pos == 2 and six.val == '6')
assert(eight.pos ==3 and eight.val == '8')
assert(nine.pos == 4 and nine.val == '9')
assert(seven.pos == 5 and seven.val == '7')

h:verify()
assert(h:dump() == "5,6,8,9,7")
assert(h:size() == 5)
assert(h:remove() == '5')
h:verify()
assert(h:dump() == "6,7,8,9")
assert(h:size() == 4)

assert(h:remove() == '6')
h:verify()
assert(h:dump() == "7,9,8")
assert(h:size() == 3)

assert(h:remove() == '7')
h:verify()
assert(h:dump() == "8,9")
assert(h:size() == 2)

assert(h:remove() == '8')
h:verify()
assert(h:dump() == "9")
assert(h:size() == 1)

assert(h:remove() == '9')
h:verify()
assert(h:dump() == "")
assert(h:empty())

local h = BinaryHeap:new{'9', '8', '7', '6', '5'}
h:verify()
assert(h:dump() == "5,6,7,9,8")
assert(h:size() == 5)

local h = BinaryHeap:new{'9', '8', '7', '6'}
h:verify()
assert(h:dump() == "6,8,7,9")
assert(h:size() == 4)

local h = BinaryHeap:new{3, 1, 2}
h:verify()
assert(h:dump() == "1,3,2")

local h = BinaryHeap:new{1, 2, 3, 4, 5}
h:verify()
assert(h:dump() == "1,2,3,4,5")

local h = BinaryHeap:new{5, 4, 3, 2, 1}
h:verify()
assert(h:dump() == "1,2,3,5,4")

local h = BinaryHeap:new{4, 4, 4, 4}
h:verify()
assert(h:dump() == "4,4,4,4")

local h = BinaryHeap:new{3, 1, 9, 8, 4, 6, 7, 5, 2}
h:verify()
assert(h:dump() == "1,2,6,3,4,9,7,5,8")

local h = BinaryHeap:new{-1, -3, -2, -4, -5}
h:verify()
assert(h:dump() == "-5,-4,-2,-1,-3")

local h = BinaryHeap:newMaxHeap{3, 1, 9, 8, 4, 6, 7, 5, 2}
h:verify()
assert(h:dump() == "9,8,7,5,4,6,3,1,2")

local h = BinaryHeap:newMaxHeap()
local nine = h:add('9')
assert(nine.pos == 1 and nine.val == '9')

local eight = h:add('8')
assert(nine.pos == 1 and nine.val == '9')
assert(eight.pos == 2 and eight.val == '8')

local seven = h:add('7')
assert(nine.pos == 1 and nine.val == '9')
assert(eight.pos == 2 and eight.val == '8')
assert(seven.pos == 3 and seven.val == '7')

local six = h:add('6')
assert(nine.pos == 1 and nine.val == '9')
assert(eight.pos == 2 and eight.val == '8')
assert(seven.pos == 3 and seven.val == '7')
assert(six.pos == 4 and six.val == '6')

local five = h:add('5')
assert(nine.pos == 1 and nine.val == '9')
assert(eight.pos == 2 and eight.val == '8')
assert(seven.pos == 3 and seven.val == '7')
assert(six.pos == 4 and six.val == '6')
assert(five.pos == 5 and five.val == '5')

h:verify()
assert(h:dump() == "9,8,7,6,5", h:dump())
assert(h:size() == 5)
assert(h:top() == '9')
assert(h:remove() == '9')
h:verify()
assert(h:dump() == "8,6,7,5", h:dump())
assert(h:size() == 4)

assert(h:remove() == '8')
h:verify()
assert(h:dump() == "7,6,5", h:dump())
assert(h:size() == 3)

assert(h:remove() == '7', h:dump())
h:verify()
assert(h:dump() == "6,5", h:dump())
assert(h:size() == 2)

assert(h:remove() == '6')
h:verify()
assert(h:dump() == "5")
assert(h:size() == 1)

assert(h:remove() == '5')
h:verify()
assert(h:dump() == "")
assert(h:empty())

local h = BinaryHeap:new{3, 1, 9, 8, 4, 6, 7, 5, 2}
assert(h:dump() == "1,2,6,3,4,9,7,5,8")

h:remove(4)
assert(h:dump(), "1,2,6,5,4,9,7,8")
h:verify()

h:remove(1)
assert(h:dump() == "2,4,6,5,8,9,7")
h:verify()

h:remove(h:size())
assert(h:dump() == "2,4,6,5,8,9")
h:verify()

local ok, errmsg = pcall(h.remove, h, h:size() + 1)
assert(not ok)
errmsg:match(".-: index out of bound$")

h:remove(2)
assert(h:dump() == "2,5,6,9,8")
h:verify()

h:remove(h:size() - 1)
assert(h:dump() == "2,5,6,8")
h:verify()
