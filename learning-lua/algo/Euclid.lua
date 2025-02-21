local Euclid = {}

local function _gcd(n, d)
  if d == 0 then
    return n
  end
  return _gcd(d, n % d) -- tail recursive
end

function Euclid.gcd(a, b)
  assert(a >= 0 and b >= 0, "input numbers must not be negative")
  if a < b then
    return _gcd(b, a) -- tail recursive
  else
    return _gcd(a, b) -- tail recursive
  end
end

---(See Euclid.pdf on the idea behind this specific implementation.)
---@param n number
---@param d number
---@param npair table the pair of numbers for `n`.
---@param dpair table the pair of numbers for `d`.
---@return number d greatest common divisor of the `a` and `b` parameters passed to `Euclid.xgcd(a, b)`.
---@return number s integer such that `s*a + t*b = d`.
---@return number t integer such that `s*a + t*b = d`.
local function _xgcd(n, d, npair, dpair)
  if d == 0 then
    return n, npair[1], npair[2]
  end
  local q = math.floor(n / d)
  local r = n % d
  local dpair_1, dpair_2 = table.unpack(dpair)
  dpair[1], dpair[2] = npair[1] - q * dpair_1, npair[2] - q * dpair_2
  npair[1], npair[2] = dpair_1, dpair_2
  return _xgcd(d, r, npair, dpair) -- tail recursive
end

---Computes the greatest common divisor of `a` and `b` using Extended Euclid algorithm.
---Returns the greatest common divisor of `a` and `b`,
---and integers `s` and `t` such that `s*a + t*b = d`.
---@param a number non-negative integer.
---@param b number non-negative integer.
---@return number d greatest common divisor of `a` and `b`.
---@return number s integer such that `s*a + t*b = d`.
---@return number t integer such that `s*a + t*b = d`.
function Euclid.xgcd(a, b)
  assert(a >= 0 and b >= 0, "input numbers must not be negative")
  if a == 0 and b == 0 then
    return 0, 0, 0 -- edge case.
  end
  if a < b then
    local d, m, n = _xgcd(b, a, {1, 0}, {0, 1})
    return d, n, m
  else
    return _xgcd(a, b, {1, 0}, {0, 1}) -- tail recursive
  end
end

return Euclid

-- To check tail recursiveness:
-- $ luac -l algo/Euclid.lua | grep TAIL
