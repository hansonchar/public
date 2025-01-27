local Stack = {}

function Stack:new()
  local stack = {}
  setmetatable(stack, self)
  self.__index = self
  return stack
end

function Stack:push(...)
  local count = 0
  for _, item in ipairs({...}) do
    assert(item, "nil not allowed")
    count = count + 1
    self[#self + 1] = item
  end
  assert(count > 0, "empty push not allowed")
end

function Stack:pop()
  if #self > 0 then
    local item = self[#self]
    self[#self] = nil
    return item
  end
end

function Stack:peek()
  return self[#self]
end

function Stack:size()
  return #self
end

function Stack:empty()
  return self:size() == 0
end

function Stack:clear()
  for i = 1, #self do
    self[i] = nil
  end
end

function Stack.__tostring(self)
  return table.concat(self, ",")
end

return Stack
