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
    return _gcd(b, a)
  else
    return _gcd(a, b)
  end
end

return Euclid

-- To check tail recursiveness:
-- $ luac -l algo/Euclid.lua | grep TAIL
