#!/usr/bin/env ruby
require 'benchmark'

def run_hash_test(n)
  table = {}
  count = 0
  1.upto(n) do |idx|
    table[idx.to_s(16)] = idx
  end

  1.upto(n) do |idx|
    if table.has_key?(idx.to_s(10))
      count = count + 1
    end
  end
end

results = Benchmark.bmbm do |bm|
  raise "Expecting one arg - num of iterations" if ARGV.size == 0
  n = ARGV[0].to_i
  bm.report { run_hash_test(n) }
end
puts "EXECUTION TIME: #{results[0].real * 1000.0}"

