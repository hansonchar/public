local gcd = require "algo.Euclid".gcd
local xgcd = require "algo.Euclid".xgcd

local DEBUG = require "algo.Debug":new(false)
local debugf = DEBUG.debugf


local function negative_test(f, a, b)
  assert(a < 0 or b < 0)
  local ok, err = pcall(f, a, b)
  assert(not ok)
  assert(string.find(err, "input numbers must not be negative"))
end

local function verify_xgcd(a, b, d, s, t)
  debugf("%d * %d + %d * %d = %d", s, a, t, b, d)
  assert(s * a + t * b == d)
end

-- gcd edge cases
assert(gcd(0, 0) == 0)
assert(gcd(1, 0) == 1)
assert(gcd(0, 1) == 1)

-- negative is not allowed for gcd
negative_test(gcd, 0, -1)
negative_test(gcd, -1, 0)

-- gcd positive tests
assert(gcd(123, 54) == 3)
assert(gcd(54, 123) == 3)

-- negative is not allowed for xgcd
negative_test(xgcd, 0, -1)
negative_test(xgcd, -1, 0)

-- xgcd edge cases
local d, m, n = xgcd(0, 0)
verify_xgcd(0, 0, d, m, n)
assert(d == 0 and m == 0 and n == 0)

verify_xgcd(1, 0, xgcd(1, 0))
verify_xgcd(0, 1, xgcd(0, 1))

-- xgcd positive tests
verify_xgcd(240, 46, xgcd(240, 46))
verify_xgcd(46, 240, xgcd(46, 240))
verify_xgcd(123, 54, xgcd(123, 54))
verify_xgcd(54, 123, xgcd(54, 123))

verify_xgcd(84, 33, xgcd(84, 33))
verify_xgcd(270, 192, xgcd(270, 192))
