local Debug = {}
Debug.__index = Debug

function Debug:setDebug(is_debug)
  self.is_debug = is_debug
end

function Debug:_debug(...)
  if self.is_debug then
    print(...)
  end
end

function Debug:_debugf(...)
  if self.is_debug then
    print(string.format(...))
  end
end

function Debug:_concat(...)
  return self.is_debug and table.concat(...) or ""
end

function Debug:new(is_debug)
  local o = {
    is_debug = is_debug
  }
  o.debug = function(...)
    o:_debug(...)
  end
  o.debugf = function(...)
    o:_debugf(...)
  end
  o.concat = function(...)
    return o:_concat(...)
  end
  return setmetatable(o, self)
end

return Debug
