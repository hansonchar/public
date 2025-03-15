local Alignment = require "algo.Alignment"
local DEBUG = require "algo.Debug":new(false)
local debugf, debug = DEBUG.debugf, DEBUG.debug

local function test_case1()
  local alignment = Alignment:new("AGTACG", "ACATAG", {mismatch = 2, gap_x = 1, gap_y = 1})
  local min_penalty, memory = alignment:find_best()
  local X_best, Y_best = alignment:reconstruct_best_alignment(memory)
  debugf("min penalty: %d", min_penalty)
  debug(X_best)
  debug(Y_best)
  assert(min_penalty == 4)
  assert(X_best == "AG--TACG")
  assert(Y_best == "A-CATA-G")
end

local function test_case2()
  local alignment = Alignment:new("AGGGCT", "AGGCA", {mismatch = 2, gap_x = 1, gap_y = 1})
  local min_penalty, memory = alignment:find_best()
  local X_best, Y_best = alignment:reconstruct_best_alignment(memory)
  debugf("min penalty: %d", min_penalty)
  debug(X_best)
  debug(Y_best)
  assert(min_penalty == 3)
  assert(X_best == "AGGGCT-")
  assert(Y_best == "AGG-C-A")
end

-- Programming Problem 17.8: Sequence Alignment at https://www.algorithmsilluminated.org/
local function problem17_8nw()
  local alignment = Alignment:new(
    "ACACATGCATCATGACTATGCATGCATGACTGACTGCATGCATGCATCCATCATGCATGCATCGATGCATGCATGACCACCTGTGTGACACATGCATGCGTGTGACATGCGAGACTCACTAGCGATGCATGCATGCATGCATGCATGC",
    "ATGATCATGCATGCATGCATCACACTGTGCATCAGAGAGAGCTCTCAGCAGACCACACACACGTGTGCAGAGAGCATGCATGCATGCATGCATGCATGGTAGCTGCATGCTATGAGCATGCAG",
    {mismatch = 5, gap_x = 4, gap_y = 4})
  local min_penalty, memory = alignment:find_best()
  debugf("min penalty: %d", min_penalty)
  assert(min_penalty == 224)
  local X_best, Y_best = alignment:reconstruct_best_alignment(memory)
  debug(X_best)
  debug(Y_best)
  assert(X_best ==
    "ACACA-TGCATCATGACTATGCATGCATG-ACTGACTGCATGCATGCAT-C-C-AT-CATGCATGCATCGATGCATG-C-AT-GAC-CACCTGTGTGACA-----CATGCATGCG-TG--TGACATGCGA-GA-CTCACTAGCGATGCATGC-ATGCATGCATGCATGC")
  assert(Y_best ==
    "-----ATG-ATCATG-C-ATGCATGCAT-CAC--ACTG--TGCAT-CA-G-A-GA-G-A-GC-T-C-TC-A-GCA-GACCA-C-ACACAC--GTGTG-CAGAGAGCATGCATGC-ATGCATG-CATGC-ATG-G-T-A---GC--TGCATGCTATG-A-GCATGCA-G-")
end

test_case1()
debug()
test_case2()
debug()
problem17_8nw()

os.exit()
