unless defined? BUILD_DIR;     BUILD_DIR = 'build'; end
unless defined? BUILD_ID;      BUILD_ID = (ENV['BUILD_NUMBER'] ? "build#{ENV['BUILD_NUMBER']}" : "#{Time.now.strftime('%Y%m%d')}"); end
unless defined? ARTIFACTS_DIR; ARTIFACTS_DIR = 'artifacts'; end
unless defined? REPORT_DIR;    REPORT_DIR = 'reports'; end
unless defined? TMP_DIR;       TMP_DIR = 'tmp'; end
unless defined? DEBUG;         DEBUG = nil; end

load BUILD_DIR / 'stx-config.rake' if File.exist?(BUILD_DIR / 'stx-config.rake')

unless defined? PROJECT;       PROJECT = 'stx:jv-branch'; end



# Guess the value of BUILD_TARGET for system on which we're currently 
# running in form of GNU target triplet, such as `x86_64-pc-linux-gnu`.
# Essentially a wrapper for config.guess used with autotools. 
def build_target_guess()
  return `./config.guess`.chop()
end

unless defined? BUILD_TARGET; BUILD_TARGET = ENV['BUILD_TARGET'] || build_target_guess(); end

unless defined? TOOLCHAIN
  if ENV.has_key? 'TOOLCHAIN'
    TOOLCHAIN = ENV['TOOLCHAIN']
  else
    if unix?
      TOOLCHAIN='gcc'
    elsif win32?    
      if /x86_64/ =~ BUILD_TARGET
        TOOLCHAIN='mingw64'
      else
        TOOLCHAIN='mingw32'
      end
    else
      raise Exception.new('Unsupported operating system')
    end
  end
end

unless File.exist? BUILD_DIR / 'stx-config.rake'
  if defined? PROJECT
    mkdir_p BUILD_DIR
    File.open(BUILD_DIR / 'stx-config.rake', 'w') do | f |
      f.puts <<COMMENT
# This file contans a default build configuration. It is created automatically
# when `rake` is called for the very first time. You may still override values
# on command line, i.e., 
#
#     rake PROJECT=some-other-project 
#
# This file SHOULD NOT be checked in a repository. 
#
COMMENT
      f.puts "unless defined? PROJECT; PROJECT='#{PROJECT}'; end"
      f.puts "unless defined? BUILD_TARGET; BUILD_TARGET = '#{BUILD_TARGET}'; end"      
      if defined? PROJECT_DIRS
        f.puts "unless defined? PROJECT_DIRS; PROJECT_DIRS='#{PROJECT_DIRS}'; end"
      end
    end
  end
end

unless defined? PROJECT_DIRS; PROJECT_DIRS = ''; end

case TOOLCHAIN
  when 'gcc'
    OBJ_DIR = '.'
    OBJ_SUFFIX = 'o'
    MAKE='make'

  when 'bcc'
    OBJ_DIR = 'objbc'
    OBJ_SUFFIX = 'obj'
    MAKE='bmake.bat -DUSEBC'

  when 'mingw64'
    if File.exist? 'C:\mingw64\bin'
      ENV['MINGW_DIR'] ='C:\MINGW64'
      ENV['USEMINGW_ARG'] = '-DUSEMINGW64'
    elsif File.exist? 'C:\MSYS64\MINGW64\bin\gcc.exe'
      ENV['MINGW_DIR'] ='C:\MSYS64\MINGW64'
      ENV['USEMINGW_ARG'] = '-DUSEMINGW64'
    else
      raise Exception.new(%q{MINGW64 nor MSYS2 found in C:\MinGW64 nor C:\MSYS64!})
    end
    ENV['MINGW'] = '__MINGW64__'
    OBJ_DIR = 'objmingw'
    OBJ_SUFFIX = 'obj'
    MAKE='mingwmake.bat'
    ENV['PATH'] = "#{ENV['PATH']};#{ENV['MINGW_DIR']}\\bin"

  when 'mingw32'
    if File.exist? 'C:\mingw\bin'
      ENV['MINGW_DIR'] ='C:\MINGW'
      ENV['USEMINGW_ARG'] = '-DUSEMINGW32'
    elsif File.exist? 'C:\MSYS64\MINGW32\bin\gcc.exe'
      ENV['MINGW_DIR'] ='C:\MSYS64\MINGW32'
      ENV['USEMINGW_ARG'] = '-DUSEMINGW32'
      system 'set'
    elsif File.exist? 'C:\MSYS\MINGW32\bin\gcc.exe'
      ENV['MINGW_DIR'] ='C:\MSYS\MINGW32'
      ENV['USEMINGW_ARG'] = '-DUSEMINGW32'
    else
      raise Exception.new(%q{MINGW32 nor MSYS2 found in C:\MinGW nor C:\MSYS64 nor C:\MSYS!})
    end
    ENV['MINGW'] = '__MINGW32__'
    OBJ_DIR = 'objmingw'
    OBJ_SUFFIX = 'obj'
    MAKE='mingwmake.bat'
    ENV['PATH'] = "#{ENV['PATH']};#{ENV['MINGW_DIR']}\\bin"

  else
    raise Exception.new("Unsupported toolchain: #{TOOLCHAIN}")
end

task :setup => %i(setup:pre
                  setup:main
                  setup:post)

task :'setup:pre'
task :'setup:post'

task :'setup:main' => %i(setup:projects setup:project setup:tasks)

task :'setup:projects' do
  Rake::Stx::Configuration.read_specs(PROJECT_DIRS)
end

task :'setup:project' => :'setup:projects' do
  unless defined? PROJECT; error('PROJECT variable not defined!') end
  project! PROJECT.to_sym
  project.apply_imports
  app_name = project.app_name || 'smalltalkx'
  app_version = project.app_version || '8.0.0'

  if not defined? BUILD_NAME; 
    BUILD_NAME = "#{app_name}-#{app_version}_#{BUILD_TARGET}"    
  end  
end

task :'setup:dependencies' => :checkout do
  project.packages.each do |pkg|
    if pkg.name == 'stx:stc' or pkg.name == 'stx:librun' or File.exist? (BUILD_DIR / pkg.directory / pkg.project_definition_file_name)
      unless pkg.test_package?
        task "#{project.application.name}:dependencies" => pkg.name
        task "#{pkg.name}:dependencies" => pkg.prereqs(mandatory: true)
      end
    end
  end
end

task :'setup:tasks' => :'setup:tasks:internal'

task :'setup:tasks:internal' => :'setup:project' do

  project.tasks.each {|t| t.define!}

  # compile task
  project.application ? (task :'compile:application' => project.application.name) : (task :'compile:application')

  info 'Defining tasks for packages...'

  project.packages_and_application.each do |pkg|

    info "Defining task for package #{pkg.name}"

    if unix? #and not File.exist? BUILD_DIR / pkg.directory / 'makefile'    
      task pkg.name => [BUILD_DIR / pkg.directory / 'makefile']
      file BUILD_DIR / pkg.directory / 'makefile' do
        chdir BUILD_DIR / pkg.directory do
          raise Exception.new("Cannot run stmkmf for #{pkg.directory}") unless system "#{pkg.top / 'stx' / 'rules' / 'stmkmf'}"
        end
      end
    end

    #require 'find'
    #[ 'bitmaps', 'resources' ].each do | dir |
    #  path = BUILD_DIR / pkg.directory() / dir
    #  if File.exist?(path)
    #    Find.find(File.expand_path(path)) do | file |
    #      if FileTest.directory?(file)
    #        if (File.basename(file) == '..') || (File.basename(file) == '.')
    #          Find.prune       # Don't look any further into this directory.
    #        else
    #          if File.exists?(File.join(file, '.svn'))
    #            rm_rf File.join(file, '.svn')
    #            #Find.prune
    #          end
    #        end
    #      end
    #    end
    #  end
    #end

    task "#{pkg.name}" => [ :'setup:dependencies' , "#{pkg.name}:dependencies", "#{pkg.name}:pre", "#{pkg.name}:main", "#{pkg.name}:post" ]

    # For Smalltalk class libraries, we have to update VM symbol database
    # if changed...
    if pkg.name != 'stx:stc' && pkg.name != 'stx:librun'
      task "#{pkg.name}" => %w(stx:librun:symbols)
    end

    task "#{pkg.name}:dependencies"
    task "#{pkg.name}:pre"
    task "#{pkg.name}:post"

    task "#{pkg.name}:main" do
      make_vars = ''
      d = win32? ? '-D' : ''
      q = win32? ? '"' : "'"


      (make_vars += "STC=#{STC}") if unix?

      if pkg.application? and !win32?
        liblist=''
        libobjs=''
        link_libobjs=''
        project.packages.each do |p|
          if File.exist? (BUILD_DIR / p.directory / p.project_definition_file_name)
            if !p.application? and p.link and !p.test_package?
              liblist += "#{p.dll_name_without_suffix} "
              libobjs += "#{File.join(pkg.top, p.directory, p.dll_name)} "
              link_libobjs += "#{p.dll_name} "
            end
          end
        end
        make_vars += " #{q}#{d}LIBLIST=#{liblist}#{q}"
        make_vars += " #{q}#{d}LIBOBJS=#{libobjs}#{q}"
        make_vars += " #{q}#{d}LINK_LIBOBJS=#{link_libobjs}#{q}"
      end

      # Update stc flags,
      stc_flags = pkg.stc_flags

      (make_vars += " #{q}#{d}STC_CMD_OPT=#{stc_flags}#{q}") if stc_flags

      (rm BUILD_DIR / pkg.directory / 'GNUmakefile') if File.exist? BUILD_DIR / pkg.directory / 'GNUmakefile'

      info "Compiling #{pkg.name}..."
      make_vars = "#{make_vars} #{DEBUG}"
      chdir BUILD_DIR / pkg.directory do
        if pkg.application? and win32?
          make 'exe'
          make 'RESOURCEFILES'
        else
          if pkg.name == 'stx:stc'
            # Sigh, on UNIX makefile is generated. So if we're using
            # binary stc, we have to recreate it first.
            if unix?
              (sh "'#{STX_TOP_DIR / 'rules' / 'stmkmf'}'") unless File.exist?('makefile')
            end
            make
          elsif pkg.name == 'stx:librun'
             # A workaround for Windows 10 & ancient Borland make which 
            # tend to crash there when trying to recompile already compiled
            # librun. Sigh, we have to move away from it as soon as possible!
            (touch 'stxmain.c') if win32? and File.exist?('stxmain.c')
            make
            if !pkg.application? and win32?                            
              cp 'objmingw' / 'librun.dll',
                 pkg.top /  project.application.directory 
            end
          else
            # Somewhat stupid detection whether we run recent St/X or not
            # ('recent' mean more recent than 3 years or so)
            # TODO: Remove this hack
            if File.exist? BUILD_DIR / 'stx' / 'libbasic2' / 'Makefile.init'
              make "#{make_vars} full"
            else
              make "#{make_vars}"
            end
            # On Windows, copy the DLL application directory
            if !pkg.application? and win32?
              if !uptodate? pkg.top / project.application.directory, [ OBJ_DIR / pkg.dll_name ]
                cp OBJ_DIR / pkg.dll_name, pkg.top /  project.application.directory                
              end
              if !uptodate? pkg.top / project.application.directory, [ OBJ_DIR / "#{pkg.dll_name}.debug" ]
                cp OBJ_DIR / "#{pkg.dll_name}.debug", pkg.top /  project.application.directory                
              end
            end
          end
        end
      end

      if pkg.application? and unix?
        chdir BUILD_DIR / 'stx' / 'librun' do; make; end
      end


    end

    if pkg.application?
      if win32?
        task pkg.name => BUILD_DIR / pkg.directory / 'modules.stx'

        task BUILD_DIR / pkg.directory / 'modules.stx' do |t|
          rm t.name if File.exist? t.name
          File.open(t.name, 'w') do |f|
            project.packages.each do |p|
              if !p.application? and p.link and !p.test_package? and p.name != 'stx:stc' and p.name != 'stx:librun' and File.exist? BUILD_DIR / p.directory / OBJ_DIR / p.dll_name
                f.puts p.dll_name_without_suffix
              end
            end
          end
        end

        project.packages.each do |p|
          if !p.application? and !p.test_package?
            task pkg.name => BUILD_DIR / pkg.directory / p.dll_name

            file BUILD_DIR / pkg.directory / p.dll_name do
              if !p.application? and p.link and !p.test_package? and File.exist? BUILD_DIR / p.directory / OBJ_DIR / p.dll_name
                cp BUILD_DIR / p.directory / OBJ_DIR / p.dll_name,
                   BUILD_DIR / pkg.directory / p.dll_name
              end
            end
          end

          if win32_wine?
            file BUILD_DIR / pkg.directory / p.dll_name do
              cp BUILD_DIR / p.directory / OBJ_DIR / p.dll_name,
                 BUILD_DIR / pkg.directory / p.dll_name
            end
          end

        end
      else # UNIX
        task "#{pkg.name}:main" => BUILD_DIR / pkg.directory / 'modulList.stc'

        task BUILD_DIR / pkg.directory / 'modulList.stc' do |t|
          rm t.name if File.exist? t.name
        end

        task "#{pkg.name}:main" => BUILD_DIR / pkg.directory / 'modulList.c'

        task BUILD_DIR / pkg.directory / 'modulList.c' do |t|
          rm t.name if File.exist? t.name
        end
      end
    end
  end

end
