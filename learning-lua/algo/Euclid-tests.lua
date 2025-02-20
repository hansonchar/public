local gcd = require "algo.Euclid".gcd

local function negative_test(a, b)
  assert(a < 0 or b < 0)
  local ok, err = pcall(gcd, a, b)
  assert(not ok)
  assert(string.find(err, "input numbers must not be negative"))
end

-- edge cases
assert(gcd(0, 0) == 0)
assert(gcd(1, 0) == 1)
assert(gcd(0, 1) == 1)

-- negative is not allowed
negative_test(0, -1)
negative_test(-1, 0)

-- positive tests
assert(gcd(123, 54) == 3)
assert(gcd(54, 123) == 3)
