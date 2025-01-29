local GraphSearch = require "algo.GraphSearch"
local Graph = require "algo.Graph"
local Stack = require "algo.Stack"
local TarjanNorecur = GraphSearch:class()
local E = {}

local function debug(...)
  -- print(...)
end

local function min(a, b)
  return a < b and a or b
end

local function node_info(node, info)
  info[node] = info[node] or {
    label = node
  }
  return info[node]
end

-- If v is a root node, pop the stack and generate an SCC.
local function post_successors(v, S)
  if v.lowlink == v.index then
    -- Start a new SCC
    local count = 0
    repeat
      local w = S:pop()
      w.onStack = false
      count = count + 1
      -- yield a member of SCC, it's SCC id and the number of members so far in this SCC
      coroutine.yield(w.label, v.lowlink, count)
    until w == v
  end
end

local function push_to_S(self, v, S, unvisited)
  -- Set the depth index for v to the smallest unused index
  v.index, v.lowlink = self._index, self._index
  self._index = self._index + 1
  S:push(v)
  unvisited[v.label] = nil -- a vertex is considered visited once pushed to S
  v.onStack = true
end

local strongconnect -- forward declaration

local function post_strongconnect(self, v, w, S, G, info, executions, unvisited, w_set)
  v.lowlink = min(v.lowlink, w.lowlink)

  for w in pairs(w_set) do
    w_set[w] = nil -- deletion is fine during iteration
    if w.index then
      if w.onStack then
        -- Successor w is in stack S and hence in the current SCC
        -- If w is not on stack, then (v, w) is an edge pointing to an SCC already found and must be ignored
        v.lowlink = min(v.lowlink, w.index)
      end
    else -- w.index is undefined
      executions:push(function ()
        post_strongconnect(self, v, w, S, G, info, executions, unvisited, w_set)
      end)
      return strongconnect(self, v, w, S, G, info, executions, unvisited, w_set)
    end
  end
end

strongconnect = function (self, u, v, S, G, info, executions, unvisited)
  push_to_S(self, v, S, unvisited)
  executions:push(function ()
    post_successors(v, S)
  end)
  -- Consider successors of v
  local w_set = {}
  for label in G:vertex(v.label):outgoings() do
    local w = node_info(label, info)
    if w.index then
      if w.onStack then
        -- Successor w is in stack S and hence in the current SCC
        -- If w is not on stack, then (v, w) is an edge pointing to an SCC already found and must be ignored
        v.lowlink = min(v.lowlink, w.index)
      end
    else -- w.index is undefined
      w_set[w] = true
    end
  end -- end for
  local w = next(w_set)
  if not w then
    return
  end
  w_set[w] = nil
  executions:push(function ()
    post_strongconnect(self, v, w, S, G, info, executions, unvisited, w_set)
  end)
  return strongconnect(self, v, w, S, G, info, executions, unvisited) -- tail recursion
end

-- https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm
local function _iterate(self)
  local unvisited, info = {}, {}
  local G = self.graph
  local S = Stack:new()
  local executions = Stack:new()
  for label in G:vertices() do
    unvisited[label] = true
  end
  self._index = 0
  local src = next(unvisited) -- arbitrarily pick a source vertex
  while src do
    local v = node_info(src, info)
    strongconnect(self, nil, v, S, G, info, executions, unvisited)
    local f = executions:pop()
    while f do
      f()
      f = executions:pop()
    end
    assert(S:empty())
    src = next(unvisited) -- arbitrarily pick another source vertex
  end
end

---@param G (table) graph
function TarjanNorecur:new(G)
  return getmetatable(TarjanNorecur):new(G, _iterate)
end

return TarjanNorecur
