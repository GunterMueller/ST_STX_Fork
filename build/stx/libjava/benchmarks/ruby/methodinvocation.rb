#!/usr/bin/env ruby
require 'benchmark'

class MethodInvocation
  def do_smth
    self
  end
end

results = Benchmark.bmbm do |bm|
  raise "Expecting one arg - num of invocations" if ARGV.size == 0
  n = ARGV[0].to_i
  inst = MethodInvocation.new

  bm.report do 
    n.times { inst.do_smth }
  end
end
puts "EXECUTION TIME: #{results[0].real * 1000.0}"

