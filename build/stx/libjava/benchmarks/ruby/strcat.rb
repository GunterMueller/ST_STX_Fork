#!/usr/bin/env ruby
require 'benchmark'

results = Benchmark.bmbm do |bm|
  raise "Expecting one arg - num of iterations" if ARGV.size == 0
  n = ARGV[0].to_i
  hello = "hello\n"
  result = ""
  10.times { result << hello }
  bm.report { n.times { result << hello } }
end
puts "EXECUTION TIME: #{results[0].real * 1000.0}"

