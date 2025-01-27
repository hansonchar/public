local Queue = {}

function Queue:new()
  local q = {
    next = 1,
    last = 1
  }
  setmetatable(q, self)
  self.__index = self
  return q
end

function Queue:enqueue(...)
  local count = 0
  for _, item in ipairs({...}) do
    assert(item, "nil not allowed")
    count = count + 1
    self[self.next] = item
    self.next = self.next + 1
  end
  assert(count > 0, "empty enqueue not allowed")
end

function Queue:dequeue()
  if self.last < self.next then
    local item = self[self.last]
    self[self.last] = nil
    self.last = self.last + 1
    if self:empty() then
      self.last, self.next = 1, 1 -- nice to have but not strictly necessary
    end
    return item
  end
end

function Queue:size()
  return self.next - self.last
end

function Queue:empty()
  return self:size() == 0
end

function Queue:clear()
  local i = self.last
  local j<const> = self.next
  while i < j do
    self[i] = nil
    i = i + 1
  end
  self.last, self.next = 1, 1
end

function Queue.__tostring(q)
  local a = {}
  for i = q.last, q.next - 1 do
    a[#a + 1] = q[i]
  end
  return table.concat(a, ",")
end

return Queue
