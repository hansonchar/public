local Graph = require "algo.Graph"

local G = Graph:new()

G:dump('x')

G:add('s', 'v', 1)
G:add('s', 'w', 4)
G:add('v', 'w', 2)

G:dump()

local edges = G:edges('s')
for v, weight in edges:outgoings() do
  print('s', v, weight)
end

G:dump('s')

local x = {}
setmetatable(x, x)
assert(not Graph.isGraph(x)) -- self reference metatable

assert(Graph.isGraph(G)) -- the metatable of G is Graph
assert(not Graph.isGraph{}) -- no metatable

local child = G:new() -- the metatable of the metatable of child is Graph
assert(Graph.isGraph(child))

assert(not Graph.isGraph(1))
assert(not Graph.isGraph(""))

assert(not Graph.isGraph())

os.exit()
