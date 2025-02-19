local UnionFind = require "algo.UnionFind"

local uf = UnionFind:new()
local a_par = uf:find('a')
local b_par = uf:find('b')
assert(a_par ~= b_par)

local ab = uf:union('a', 'b')
local a_par = uf:find('a')
local b_par = uf:find('b')
assert(a_par == b_par)

local a_par = uf:find('a')
local d_par = uf:find('d')
assert(a_par ~= d_par)

local ad = uf:union('a', 'd')
local a_par = uf:find('a')
local d_par = uf:find('d')
assert(a_par == d_par)

local b_par = uf:find('b')
local d_par = uf:find('d')
assert(b_par == d_par)
