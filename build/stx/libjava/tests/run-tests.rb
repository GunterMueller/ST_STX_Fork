#!/usr/bin/ruby
DOCUMENTATION = <<DOCEND
A simple script to run all tests on all supported JDKs. Use this to check
changes before pushing to upstream repository!

== Parameters ==

Following parameters are currently supported:

* STX_LIBJAVA_RELEASE ..... which Java releases to test. Defaults to
                            'JDK6, JDK7, zulu7'
* STX_LIBJAVA_ENABLE_JIT .. test with Java JIT on ("1") or off ("0").
                            Defaults to off ("0")

This script takes parameter values, compute all possible combinations
and run tests on each combination, writing results to an output directory.
Parameter values are specified as a list of comma-separated values.

== Results ==

After all tests finish, a short summay is written to the standard output.
In addition, this summary, test report in JUnit xml format as well and
tests' stdout is written to a new directory named "results-YYYY-MM-DD-HH-MM-SS"
where YYYY-MM-DD-HH-MM-SS is current date time.

== Examples ==

Run all standard tests (to be run before push!):

   ./run-tests.rb

Run basic and Mauve test suites on JDK7 in both interpreted and JIT modes:

   ./run-tests.rb -D "STX_LIBJAVA_RELEASE=JDK7" -D "STX_LIBJAVA_ENABLE_JIT=1,0"\
                  -p stx:libjava -p stx:libjava/tests/mauve


DOCEND


require 'rbconfig'
require 'fileutils'
require 'optparse'

PACKAGES = [
  'stx:libjava',
  'stx:libjava/tests/mauve',
  'stx:libjava/experiments',
  'stx:libjava/tools'
]
PARAM_NAMES=[ 'STX_LIBJAVA_ENABLE_JIT', 'STX_LIBJAVA_RELEASE' ]
PARAMS = {
  'STX_LIBJAVA_ENABLE_JIT' => [
    #'1',
    '0'
  ],
  'STX_LIBJAVA_RELEASE' => [
    'JDK6',
    'JDK7',
    'zulu7'
  ]
}

REPORT_DIR="results-#{Time.now.strftime("%Y-%m-%d-%H-%M-%S")}"


def win32?
  return (RbConfig::CONFIG['host_os'] =~ /mingw32/) != nil
end

def unix?
  if win32_wine?
    return false
  end
  return (RbConfig::CONFIG['host_os'] =~ /linux|solaris/) != nil
end

if win32?
  REPORT_RUNNER = File.join(File.dirname(__FILE__), '..', '..', 'goodies', 'builder', 'reports' , 'report-runner.bat')
else
  REPORT_RUNNER = File.join(File.dirname(__FILE__), '..', '..', 'goodies', 'builder', 'reports' , 'report-runner.sh')
end



def run_package(package, params = {})
  ident = []
  setup = 'Stdin close'
  params.keys.sort.each do | name |
    value = params[name]
    ident.push("#{name}=#{value}")
    ENV[name] = value
  end
  if ident.size > 0 then
    logf = File.join(REPORT_DIR, "#{package.tr(':/', '__')}-#{ident.join('-')}-Test.out")
    ident = "#{ident.join('-')}"
    cmd = %W[#{REPORT_RUNNER} -S #{setup} -D #{REPORT_DIR} -i #{ident} -r Builder::TestReport -p #{package}]
    #cmd = %W[#{REPORT_RUNNER} -S #{setup} -D #{REPORT_DIR} -i #{ident} -r Builder::TestReport ]
  else
    logf = File.join(REPORT_DIR, "#{package.tr(':/', '__')}-Test.out")
    ident = ''
    cmd = %W[#{REPORT_RUNNER} -S #{setup}  -D #{REPORT_DIR} -r Builder::TestReport -p #{package}]
  end

  puts "Running #{package} {#{ident}}"
  puts cmd.join()
  pattern = /SUMMARY: (?<run>\d+) run, (?<passed>\d+) passed, (?<skipped>\d+) skipped, (?<failed>\d+) failed, (?<error>\d+) error/
  result = {
            'run' => '?',
            'passed' => '?',
            'skipped' => '?',
            'failed' => '?',
            'error' => '?'
          }
  IO.popen(cmd + [ :err => [:child, :out]]) do | out |
    File.open(logf, "w") do | log |
      out.each do | line |
        log.puts line
        puts line
        match = pattern.match (line)
        if match then
          result = {
            'run' => match['run'],
            'passed' => match['passed'],
            'skipped' => match['skipped'],
            'failed' => match['failed'],
            'error' => match['error']
          }
        end
      end
    end
  end
  result['ident'] = ident
  result['package'] = package
  result['params'] = params
  return result
end

def combine(params, bound = {}, &block)
  if bound.size == params.size then
    yield bound
  else
    params_to_combine = params.keys.sort.select { | p | not bound.key? p }
    param = params_to_combine.to_a().first()
    values = params[param]
    values.each do | value |
      combined = bound.clone()
      combined[param] = value
      combine(params, combined, &block)
    end
  end
end


def write_results_txt_to_file(filename, results)
  File.open(filename, "a+") do |file|
    write_results_txt(file, results)
  end
end


def write_results_txt(file, results)
    file.write("\n")
    file.write(Time.now.to_s)
    file.write("\n")
    params = PARAMS.keys.sort
    values = [[ "Package"] + params + ['result', 'run', 'passed', 'skipped' , 'failed' , 'error']]
    results.each do | result |
      param_values = params.collect { | p | result['params'][p] }
      result_text = '?'
      if result['run'] != '0' then
        if result['error'] != '0' then
          result_text = 'ERROR'
        elsif result['failed'] != '0' then
          result_text = 'FAILED'
        else
          result_text = 'passed'
        end
      end

      row = [ result['package'] ] + param_values + [ result_text, result['run'], result['passed'], result['skipped'], result['failed'], result['error'] ]
      values.push(row)
    end
    max_lengths = values[0].map { |val| val.length }
    values.each do |row|
      row.each_with_index do |elem, index|
        elem_size = elem.size
        max_lengths[index] = elem_size if elem_size > max_lengths[index]
      end
    end
    values.each do |val|
      format = max_lengths.map { |length| "%#{length}s" }.join(" " * 3)
      file.write(format % val)
      file.write("\n")
    end
    file.write("--\n")

end


def main()

  FileUtils.mkdir_p REPORT_DIR
  results = []
  packages = []
  params = {}
  runs = 1

  optparse = OptionParser.new do | opts |
    opts.banner = "Usage: run-tests.rb [-D NAME=VALUE [-D...]] [-p PACKAGE [-p ...]]"
    opts.on('-D', '--define NAME=VALUES', "Define a parameter NAME with VALUES") do | define |
      name , value = define.split("=")
      params[name] = value.split(",").collect { | e | e.strip }
    end

    opts.on('-N', '--runs NUMBER', "Run tests NUMBER times") do | number |
      runs = number.to_i
    end	

    opts.on('-p', '--package PACKAGE', "Run tests for PACKAGE") do | package |
      packages << package
    end


    opts.on(nil, '--help', "Prints this message") do
      puts DOCUMENTATION
      puts optparse.help()
      exit 0
    end
  end

  optparse.parse!

  # Validate parameters
  params.each do | name, values |
    if not PARAM_NAMES.include? name then
      puts "ERROR: Invalid parameter name: #{name}"
      puts DOCUMENTATION
      puts optparse.help()
      exit 1
    end
  end

  if (runs < 1)
    puts "ERROR: Invalid number of runs"
    exit 2
  end

  PARAMS.each do | name, values |
    if not params.has_key? name then
      params[name] = values
    end
  end

  if packages.size == 0 then
    packages = PACKAGES
  end

  runs.times do 
    combine(params) do | bound |
      packages.each do | package |
        results.push(run_package(package, bound))
      end
    end
  end

  write_results_txt_to_file(File.join(REPORT_DIR, 'results.txt'), results)
  write_results_txt(STDOUT, results)
end

main()


