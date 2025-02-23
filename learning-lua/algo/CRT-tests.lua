local chinese_remainder = require "algo.CRT".chinese_remainder

-- https://en.wikipedia.org/wiki/Chinese_remainder_theorem
local x, n = chinese_remainder(2, 3, 3, 5, 2, 7)
assert(x % 3 == 2)
assert(x % 5 == 3)
assert(x % 7 == 2)
assert(x == 23)
assert(n == 3 * 5 * 7)

-- https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Elementary_Number_Theory_(Barrus_and_Clark)/01%3A_Chapters/1.23%3A_Chinese_Remainder_Theorem
x, n = chinese_remainder(2, 3, 1, 4, 7, 11)
assert(x % 3 == 2)
assert(x % 4 == 1)
assert(x % 11 == 7)
assert(x == 29)
assert(n == 3 * 4 * 11)

x, n = chinese_remainder(6, 7, 8, 9, 4, 11, 8, 13)
assert(x % 7 == 6)
assert(x % 9 == 8)
assert(x % 11 == 4)
assert(x % 13 == 8)
assert(x == 125)
assert(n == 7 * 9 * 11 * 13)

-- negative test
local ok, err = pcall(chinese_remainder, 3, 4, 0, 6)
assert(not ok)
assert(string.find(err, 'n1 and n2 must be co%-prime'))

-- https://math.stackexchange.com/questions/73532/a-number-when-successively-divided-by-9-11-and-13-leaves-remainders-8
x, n = chinese_remainder(8, 9, 9, 11, 8, 13)
assert(x % 9 == 8)
assert(x % 11 == 9)
assert(x % 13 == 8)
assert(x == 944)
assert(n == 9 * 11 * 13)

-- Trivial case
x, n = chinese_remainder(0, 9, 0, 11, 0, 13)
assert(x == 0)
assert(n == 9 * 11 * 13)
