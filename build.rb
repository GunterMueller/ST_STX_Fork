#!/usr/bin/ruby
DOCUMENTATION = <<DOCEND
A help script to build a Smalltalk/X jv-branch (mainly) on a Jenkins CI. 
If no TARGET is given, invokes target `jenkins:job`.

Some influential environment variables:

  BUILD_TARGET    target to build, can be also specified on a command line using 
                  --build-target option. 
  CC              C compiler command (only UNIX builds for now)
  CXX             C++ compiler command (only UNIX builds for now)

DOCEND

require 'optparse'

def run()
  optparse = OptionParser.new do | opts |
    opts.banner = "Usage: #{$0} [TARGET1 [TARGET1 [...]]\n"
    opts.on('-p', '--project PROJECT', "PROJECT to build. Overrides project specified by the environment variable.") do | value |
      ENV['PROJECT'] = value
      self.class.const_set('PROJECT', value)  
    end

    opts.on('-t', '--build-target BUILD_TARGET', "Target to build for in form of GNU target triplet (such as 'x86_64-pc-linux-gnu'). Overrides build target specified by the environment variable.") do | value |
      ENV['BUILD_TARGET'] = value
      self.class.const_set('BUILD_TARGET', value)  
    end

    opts.on(nil, '--help', "Prints this message") do
      puts DOCUMENTATION
      puts optparse.help()
      exit 0
    end
  end

  optparse.parse!

    # If run outside a Jenkins build environment (such as from a command line), 
  # define some variables to make it look more like a proper  Jenkins build 
  # environment. 
  ENV['WORKSPACE'] ||= '.'
  ENV['BUILD_NUMBER'] ||= Time.now.strftime("%Y%m%d")
  ENV['JOB_NAME'] ||= 'interactive'

  # If no target is given, run target jenkins:job
  if ARGV.size == 0 then
    ARGV << 'jenkins:job'
  end

  # Wipe out `reports` directory. This is needed for two reasons: 
  #
  # 1) There's a bug in Cobertura plugin so it does not expand 
  #    variables in .xml file pattern so the pattern cannot include
  #    BUILD_NUMBER to tell reports for particular build. 
  #    See https://issues.jenkins-ci.org/browse/JENKINS-30647
  # 2) More importantly, when additional axis is used (such as JDK
  #    or Mercurial version) then value of this axis is not reflected
  #    in report filename. So again, all files, even those from previous
  #    builds would be matches which is not what we want. 
  # 
  # A workaround is to wipe-out `reports` directory before each buld,
  # so once this script finishes, all reports there are for this build.
  # The downside is that we have to limit number of executors to 1,
  reports_dir = File.join(ENV['WORKSPACE'], 'reports')
  if File.exist? reports_dir then
    require 'fileutils'    
    FileUtils.rm_rf reports_dir
  end
  
  # When run under Jenkins, we do want to see full backtrace if something
  # fails. 
  ARGV << '--trace'

  require 'rake'
  Rake.application.run
end

run if __FILE__ == $0
