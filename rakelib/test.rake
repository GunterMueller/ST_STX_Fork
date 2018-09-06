TESTREPORT_CLASS = 'Builder::TestReport'
LINTREPORT_CLASS = 'Builder::LintReport'


# A helper class to keep a summary of a test report
class TestReportSummary
  SUMMARIES = []
  PATTERN = /tests=\"(?<run>\d+)\".+failures=\"(?<failed>\d+)\" errors=\"(?<errors>\d+)\" skipped=\"(?<skipped>\d+)\"/

  attr_reader :pkg, :run, :failed, :errors, :skipped

  def passed
    @run - @failed - @errors - @skipped
  end

  def outcome
    (@failed > 0 or @errors > 0) ? 'FAILED' : 'PASSED'
  end

  # Creates a new summary for given package and report file.
  def initialize(pkg_name, report_file)
    raise Exception.new("Report file does not exist! #{report_file}") unless File.exist? report_file
    @pkg = pkg_name
    matches = PATTERN.match(IO.read(report_file, 512))

    # Maybe the buffer is too small? Try to read up more
    # data....
    raise Exception.new(%q{Cannot "parse" report file!}) unless matches
    @run = matches['run'].to_i
    @failed = matches['failed'].to_i
    @errors = matches['errors'].to_i
    @skipped = matches['skipped'].to_i
  end
end

desc 'Run tests'
task :test => :'test:all'

desc 'Run tests (alias for target test)'
task :tests => :'test'


task :'setup:tasks' => :'setup:tasks:test'

def run_report(app, packages, report, global_opts = '', report_opts = '')
  #run_report_st = BUILD_DIR / 'stx' / 'goodies' / 'builder' / 'reports' / 'report-runner-old.st'
  run_report_st = BUILD_DIR / 'stx' / 'goodies' / 'builder' / 'reports' / 'report-runner.st'
  coveragerportformat_dot_st = BUILD_DIR / 'stx' / 'goodies' / 'builder' / 'reports' / 'Builder__CoverageReportFormat.st'

  report_dir = File.expand_path(REPORT_DIR)
  tmp_dir = File.expand_path(TMP_DIR)

  # Set STX_TMPDIR environment to make sure all temporary files created by
  # Smalltalk/X goes to a local tmp directory (which should be discarded
  # regularly). This helps to avoid garbage to heap up on Windows slaves
  # assuming workspaces is thrown away often.
  ENV['STX_TMPDIR'] = tmp_dir

  if app
    exe_dir = BUILD_DIR / app.directory
    win32? ? (exe = "#{app.executable}.com") : (exe = "./#{app.executable}")
  else
    exe_dir = BUILD_DIR / 'stx' / 'projects' / 'smalltalk'
    win32? ? (exe = 'stx.com') : (exe = './stx')
  end

  (mkdir_p tmp_dir) unless File.directory?(tmp_dir)
  chdir exe_dir do
    packages_args = ''
    packages.each {|p| packages_args += " -p #{p}"}

    File.exist?(coveragerportformat_dot_st) ? (runner_opts = "--abortOnSEGV --abortOnInternalError -I --execute #{run_report_st}") : (runner_opts = "-I -f #{run_report_st}")
    sh "#{exe} #{runner_opts} #{global_opts} -i \"#{BUILD_ID}\" -D \"#{report_dir}\" -r #{report} #{report_opts} #{packages_args}"
  end
  # No, do not remove tmp_dir here. If a test fails,
  # then temp dir may contain valuable files to debug/reproduce
  # (bad image files, outputs and so on). 
  # Depend on some other external process to wipe out temp directory
  # once not needed (full CI build cycle should do that)
  #
  # rm_rf tmp_dir
end

task :'setup:tasks:test' do
  $__testresults__ = []
  app = project.application
  project.packages.each do |pkg|
    if pkg.test
      task "test:package:#{pkg.name}:pre"
      task "test:package:#{pkg.name}:post"
      task "test:package:#{pkg.name}:main" => ['stx:goodies/builder/reports', REPORT_DIR] do
        report_file = File.expand_path(REPORT_DIR) / "#{pkg.name_components.join('_')}-#{BUILD_ID}-Test.xml"
        # Sigh, sigh. On CI server, sometimes it happen that tests are simply not run.
        # I was not able to debug the issue anyhow, any attempt to attach a debugger,
        # add a debug print or run it manually failed as the problem did not manifest.
        #
        # This is a feeble and horrible attempt to just cover up the problem by
        # trying multiple times. I don't want to spend more time chasing issues
        # like this. Sorry.
        #
        # Let's see if it helps.
        5.times do #for i in 1..5 do
          pkg.coverage ? run_report(app, [pkg.name], TESTREPORT_CLASS, '', '--coverage') : run_report(app, [pkg.name], TESTREPORT_CLASS)
          # Extract summary from XML report and keep it. Yeah, parsing XML
          # using regexps is a bad thing, but it's quick and lot less code!
          break if File.exist?(report_file)
        end
        report_summary = TestReportSummary.new(pkg.name, report_file)
        TestReportSummary::SUMMARIES << report_summary
      end

      task "test:package:#{pkg.name}" => [ "test:package:#{pkg.name}:pre",
                                           "test:package:#{pkg.name}:main",
                                           "test:package:#{pkg.name}:post" ]
      task :'test:packages' => "test:package:#{pkg.name}"
      task "#{pkg.name}:test" => "test:package:#{pkg.name}"
    end

    if pkg.lint
      task "lint:package:#{pkg.name}" => %W(stx:goodies/builder/reports REPORT_DIR) do
        #puts "LINT DISABLED (because of some bug in recent SmallLint - runs out of memory)"
        run_report(app, [pkg.name], LINTREPORT_CLASS)
      end
      task :'lint:packages' => "lint:package:#{pkg.name}"
    end
  end
end

task :'setup:tasks' => :'setup:tasks:test'
task :'test:setup' => :setup
task :'lint:setup' => :setup

namespace :test do
  task :all => %i(setup pre main post)
  task :pre
  task :post

  directory REPORT_DIR

  task :setup => :'setup:dependencies'

  task :main => %i(setup packages summary)

  task :packages

  task :summary do
    outcome = 'PASSED'
    puts
    puts 'OVERALL SUMMARY'
    puts
    TestReportSummary::SUMMARIES.each do |test_summary|
      puts "%-20s %s - %d run, %d passed, %d skipped, %d failed, %d errors" % [
        test_summary.pkg,
        test_summary.outcome,
        test_summary.run,
        test_summary.passed,
        test_summary.skipped,
        test_summary.failed,
        test_summary.errors
      ]
      outcome = 'FAILED' if test_summary.failed > 0 or test_summary.errors > 0
    end
    puts
    puts outcome
  end
end

desc 'Run static analysis on the code (SmallLint)'
task :lint => :'lint:all'


namespace :lint do
  task :all => %i(setup pre main post)
  task :pre
  task :post

  directory REPORT_DIR

  task :setup

  task :main => %i(setup packages)

  task :packages
end
