local Alignment = {}
Alignment.__index = Alignment

local function _find_min_penalty(self, sz_x, sz_y, memory)
  if sz_x == 0 then
    return sz_y * self.penalties.gap_x
  elseif sz_y == 0 then
    return sz_x * self.penalties.gap_y
  end
  memory[sz_x] = memory[sz_x] or {}
  local min_penalty = memory[sz_x][sz_y]
  if min_penalty then
    return min_penalty
  end
  local x, y = self.X:sub(sz_x, sz_x), self.Y:sub(sz_y, sz_y)
  local p_match
  if x == y then
    p_match = _find_min_penalty(self, sz_x - 1, sz_y - 1, memory)
  else
    p_match = _find_min_penalty(self, sz_x - 1, sz_y - 1, memory) + self.penalties.mismatch
  end
  local p_gap_y = _find_min_penalty(self, sz_x - 1, sz_y, memory) +
    self.penalties.gap_y -- consume the last char in X against a gap in Y
  local p_gap_x = _find_min_penalty(self, sz_x, sz_y - 1, memory) +
    self.penalties.gap_x -- consume the last char in Y against a gap in X
  min_penalty = math.min(p_match, p_gap_y, p_gap_x)
  memory[sz_x][sz_y] = min_penalty
  return min_penalty
end

-- Finds the best sequence alignment by minimizing the Needleman-Wunsch score.
function Alignment:find_best()
  local memory = {}
  local min_penalty = _find_min_penalty(self, #self.X, #self.Y, memory)
  return min_penalty, memory
end

function Alignment:reconstruct_best_alignment(memory)
  local X_best, Y_best = {}, {}
  local sz_x, sz_y = #self.X, #self.Y
  while sz_x + sz_y > 0 do
    if sz_x == 0 then
      X_best[#X_best + 1] = '-'
      Y_best[#Y_best + 1] = self.Y:sub(sz_y, sz_y)
      sz_y = sz_y - 1
    elseif sz_y == 0 then
      X_best[#X_best + 1] = self.X:sub(sz_x, sz_x)
      Y_best[#Y_best + 1] = '-'
      sz_x = sz_x - 1
    else
      local p1 = memory[sz_x][sz_y]
      local p2 = (memory[sz_x - 1] or {})[sz_y] or sz_y
      local p3 = memory[sz_x][sz_y - 1] or sz_x
      if p1 < p2 and p1 < p3 then
        X_best[#X_best + 1] = self.X:sub(sz_x, sz_x)
        Y_best[#Y_best + 1] = self.Y:sub(sz_y, sz_y)
        sz_x = sz_x - 1
        sz_y = sz_y - 1
      elseif p2 < p3 then
        X_best[#X_best + 1] = self.X:sub(sz_x, sz_x)
        Y_best[#Y_best + 1] = '-'
        sz_x = sz_x - 1
      else
        X_best[#X_best + 1] = '-'
        Y_best[#Y_best + 1] = self.Y:sub(sz_y, sz_y)
        sz_y = sz_y - 1
      end
    end
  end
  return table.concat(X_best):reverse(), table.concat(Y_best):reverse()
end

---@param X string sequence X
---@param Y string sequence Y
---@param penalties table must contain three fields: "mismatch" for the mismatch penaltiy, "gap_x" for the penalty of having a gap in the X sequence, and likewise "gap_y" for the Y sequence.
---@return table
function Alignment:new(X, Y, penalties)
  return setmetatable({X = X, Y = Y, penalties = penalties}, self)
end

return Alignment
