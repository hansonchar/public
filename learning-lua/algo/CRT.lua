local CRT = {}
local xgcd = require "algo.Euclid".xgcd

---Given the remainders `a1` and `a2` of the respective Euclidean division of an integer n by `n1` and `n2`,
---returns the remainder of the division of n by the product `n1 * n2`, under the condition that `n1` and `n2`
---are coprime.
---
---See Chinese Remainder Theorem: https://en.wikipedia.org/wiki/Chinese_remainder_theorem.
---@param a1 number where `a1 = n % n1`
---@param n1 number an integer coprime with `n2`
---@param a2 number where `a2 = n % n2`
---@param n2 number an integer coprime with `n1`
---@return number x such that `x = n % (n1 * n2)`
---@return number n1*n2
local function solve(a1, n1, a2, n2)
  local d, m1, m2 = xgcd(n1, n2)
  assert(d == 1, "n1 and n2 must be co-prime")
  local x = a1 * m2 * n2 + a2 * m1 * n1
  return x % (n1 * n2), n1 * n2
end

---Returns the Chinese remainder of the given list of (remainder, divisor) pairs.  A Chinese remainder is the smallest non-negative integer that would result in the same remainder when divided by the corresponding divisor for every (remainder, divisors) specified in the input, under the condition that all divisors are coprime.
---@param ... ... a list of numbers grouped in (remainder, divisor) pairs.  All divisors in the list must be pairwise co-prime.  At least 4 numbers ie 2 pairs.
---@return number r a unique non-negative integer less than `product` such that when `r` is divided by a divisor it would result in the correspoinding remainder for every (remainder, divisor) specified in the input.
---@return number product product of all the divisors given.
function CRT.chinese_remainder(...)
  local count = select("#", ...)
  assert(count >= 4 and count % 2 == 0, "Invalid parameters")
  local processed = 4
  local r, product = solve(...)
  while processed < count do
    ---@diagnostic disable-next-line: missing-parameter
    r, product = solve(r, product, select(processed + 1, ...))
    processed = processed + 2
  end
  return r, product
end

return CRT
