#!/usr/bin/env ruby
require 'benchmark'

class Integer
  def ackermann(n)
    return n + 1 if self == 0

    if n == 0
      (self - 1).ackermann(1)
    else
      (self - 1).ackermann(ackermann(n - 1))
    end
  end
end

results = Benchmark.bmbm do |bm|
  raise "Expecting one arg - second ackermann param" if ARGV.size == 0
  n = ARGV[0].to_i
  bm.report { 10.times { 3.ackermann(n) } }
end
puts "EXECUTION TIME: #{results[0].real * 1000.0}"

