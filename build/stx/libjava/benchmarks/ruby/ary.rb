#!/usr/bin/env ruby
require 'benchmark'

def ary(x,y,n)
  (n - 1).downto(1) do |i|
    y[i] = y[i] + x[i] 
  end
end

results = Benchmark.bmbm do |bm|
  raise "Expecting one arg - size of arrays" if ARGV.size == 0
  n = ARGV[0].to_i
  x = (0...n).to_a
  y = Array.new(n) { 0 }

  bm.report do 
    1000.times { ary(x, y, n) }
  end
end
puts "EXECUTION TIME: #{results[0].real * 1000.0}"
