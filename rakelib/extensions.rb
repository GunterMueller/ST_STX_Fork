require 'rake'
require 'rbconfig'
require 'pathname'
require 'find'

class String
  rake_extension('/') do
    def / (arg)            
      r = File.join(File.expand_path(self), arg.to_s)
      if win32? && r.size >= 260 then        
        halt
        r = "\\\\?\\#{r}" if not r.start_with?('\\\\?\\')
      end
      if arg.to_s.include? ?* or arg.to_s.include? ??
        r = Dir.glob(r)
        r.reject! {|f| (f =~ /\^.svn|^CVS|^\.hg|^\.git/i) != nil}
      end
      return r
    end
  end
end


(defined? VERBOSE) || (VERBOSE = nil)

class Object
  rake_extension('halt') do
    def halt
      begin
        require 'pry'
      rescue LoadError
        error('`pry` not installed, run `gem install pry` to install it')
      end
      begin
        require 'pry-byebug'
      rescue LoadError
        error('`pry-byebug` not installed, run `gem install pry-byebug` to install it')
      end
      binding.pry
    end
  end

  rake_extension('info') do
    def info(message, details = nil)
      unless VERBOSE.nil?
        $stderr.puts "[INFO] #{message}"
        $stderr.puts "      #{details}" if details
      end
    end
  end

  rake_extension('warn') do
    def warn(message, details = nil)
      unless VERBOSE.nil?
        $stderr.puts "[WARN] #{message}"
        $stderr.puts "      #{details}" if details
      end
    end
  end


  rake_extension('error') do
    def error(message)
      raise Exception.new(message)
    end
  end

  rake_extension('error_unsupported_platform') do
    def error_unsupported_platform
      error("Unsupported platform (#{RbConfig::CONFIG['host_os']})")
    end
  end

  rake_extension('win32?') do
    def win32?
      return true if win32_wine?
      return (RbConfig::CONFIG['host_os'] =~ /mingw32/) != nil
    end
  end

  rake_extension('win32_wine?') do
    def win32_wine?
      return ENV['CROSSCOMPILE'] == 'wine'
    end
  end


  rake_extension('unix?') do
    def unix?
      return false if win32_wine?
      return (RbConfig::CONFIG['host_os'] =~ /linux|solaris/) != nil
    end
  end

  rake_extension('linux?') do
    def linux?
      return false if win32_wine?
      return (RbConfig::CONFIG['host_os'] =~ /linux/i) != nil
    end
  end

  rake_extension('x86_64?') do
    def x86_64?
      return RbConfig::CONFIG['host_cpu'] == 'x86_64'
    end
  end

  rake_extension('i386?') do
    def i386?
      return RbConfig::CONFIG['host_cpu'] == 'i386'
    end
  end

  rake_extension('redefine') do
    def redefine(*args, &block)
      task_name, arg_names, deps = Rake.application.resolve_args(args)
      task = Rake.application.lookup(task_name)
      error "task #{task_name} not defined ant thus cannot be redefined" unless task
      info "Redefining task #{task.name}"
      task.clear
      task.set_arg_names(arg_names)
      task.enhance(deps, &block)
    end
  end

  rake_extension('clear') do
    def clear(*args, &block)
      error 'Block has no meaning when clearing task prereqs' if block_given?
      task_name, arg_names, deps = Rake.application.resolve_args(args)
      deps = deps.collect {|each| each.to_s}
      task = Rake.application.lookup(task_name)
      return nil unless task
      info "Clearing dependencies of task #{task.name} (#{deps.join(", ")})"
      task.prerequisites.reject! {|each| deps.include? each.to_s}
      return task
    end
  end

  class << self
    alias :__const_missing__ :const_missing
  end

  def self.const_missing(name)
    ENV[name.to_s] ? (return ENV[name.to_s]) : (return __const_missing__(name))
  end
end

module RakeFileUtils
  # Evaluates given command using a shell. If block is given
  # then block is evaluate with status, stdout and stderr.
  # If no block is given, return true if command is successfull
  # ot thrown an exception if command fails (its exit status is non-zero)
  #
  # if cwd: keyword is specified, then working directory is changed
  # to specified directory before the command is run.  
  def sh(cmd, cwd: Dir.pwd)
    when_writing(cmd) do
      if block_given?
        chdir(cwd) do
          fu_output_message (cmd.kind_of?(Array) ? cmd.join(' ') : cmd)
          stdout, stderr, status = Open3.capture3(*cmd)
        end
        case block.arity
          when 1
            yield status
          when 2
            yield status, stdout
          when 3
            yield status, stdout, stderr
          else
            raise Exception.new('invalid arity of given block')
        end
        return status.success?
      else
        success = false
        chdir(cwd) do
          fu_output_message (cmd.kind_of?(Array) ? cmd.join(' ') : cmd)
          system(*cmd)
          success = $?.success?
        end
        raise Exception.new("command failed: #{cmd.kind_of?(Array) ? cmd.join(' ') : cmd}") unless success
      end
    end
    true
  end

  # Cross-platform way of finding an executable in the $PATH.
  # Return full path to the `cmd` or `nil` if given command
  # is not in the path. 
  #
  # Examples
  #
  #   which('ruby') #=> /usr/bin/ruby  
  #
  #   which('boguscommand') #=> nil
  #
  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each {|ext|
        exe = File.join(path, "#{cmd}#{ext}")
        return exe if File.executable?(exe) && !File.directory?(exe)
      }
    end
    nil
  end

  def make(args = '')
    if win32?
      # As of 2017-01-13, mingwmake no longer makes sure objdir exists,
      # causing mingwmake.bat to fail. To workaround that, make sure
      # objdir exists. 
      # How could eXept mess up things so badly?
      mkdir_p OBJ_DIR
      sh "#{MAKE} #{args}"
    else
      sh "#{MAKE} #{args}"
    end
  end

  # Like FileUtils::rm_r but does NOT remove files explicitly listed 
  # in `exceptions` (i.e., these files are NOT removed). Exceptions
  # are interpreted as relative paths to directory (directories) in 
  # `list`
  #
  # Examples: 
  #
  #   Completely wipe-out `build` directory except `build/stx-config.rake`
  #   and `build/stx-config.make`:
  #
  #   
  #
  def rm_r_ex(list, force: nil, noop: nil, verbose: nil, secure: nil, exceptions: [])        
    if exceptions.empty? 
      rm_r list, force: force, noop: noop, verbose: verbose, secure: secure
    else
      list = fu_list(list)
      list.each do | path |
        if File.directory? path        
          Dir.foreach(path) do | entry |            
            if (entry != '.') and (entry != '..') and !(exceptions.include? entry)                        
              entry_exceptions = exceptions.select { | each_exception | each_exception.start_with? "#{entry}/" }                          
              if entry_exceptions.empty? 
                rm_r(File.join(path , entry), force: force, noop: noop, verbose: verbose, secure: secure)
              else
                entry_exceptions = entry_exceptions.collect { | each_exception | each_exception.slice(entry.size+1..-1) }
                rm_r_ex(File.join(path , entry), force: force, noop: noop, verbose: verbose, secure: secure, exceptions: entry_exceptions)                                          
              end              
            end          
          end        
          if Dir.entries(path).size <= 2
            rmdir path
          end
        else 
          rm_r path, force: force, noop: noop, verbose: verbose, secure: secure
        end
      end
    end
  end

  # Like FileUtils::rm_rf but does NOT remove files explicitly listed 
  # in `exceptions`. See `rm_r_ex` for details
  def rm_rf_ex(list, noop: nil, verbose: nil, secure: nil, exceptions: [])
    rm_r_ex list, force: true, noop: noop, verbose: verbose, secure: secure, exceptions: exceptions
  end

  # Pretty much like sed. Replaces all occurences of `pattern` by `replacement` in given `file`.
  # If `inplace` is `true`, then the modified contents is written back to the file. Otherwise it
  # printed on `STDOUT`.
  def sed(pattern, replacement, file, inplace = false)
    contents = File.read(file)

    # Spuriously it happens the file is somehow corrupted and not propetly
    # UTF8 encoded. This would result in error like
    #
    #    `gsub': invalid byte sequence in UTF-8 (ArgumentError)
    #
    # To prevent, replace all invalid character by $?. Not a safest 
    # approach, though. 
    contents = contents.encode('UTF-8', :invalid => :replace, :replace => '?').encode('UTF-8')

    contents.gsub!(pattern, replacement)
    if inplace
      cp file, "#{file}.bak"
      File.open(file, 'w') {|f| f.puts contents}
    else
      STDOUT.puts contents
    end
  end

  # Create a compressed archive of `directory`. 
  # 
  # The archive is created in the same directory as the `directory` and
  # has the same name unless explicitily specified by `archive:` option. 
  # If `remove: true` option is set to true, the `directory` to archive is
  # removed after adding the archive. 
  #
  # If `include` is given (i.e., not `nil`), then only files within
  # `directory` are added to the archive. 
  # 
  # The type of the archive is automatically derived from `archive` name (if 
  # provided) or defaults to `.tar.bz2` on UNIXes and to `.zip` on Windows. 
  #
  # As a side-effect, it generates a SHA256 checksum in file .sha256 unless
  # option `sha256: false` is given.
  # 
  # Examples: 
  #
  # Create `somedir.bar.bz2` in `/tmp` containg contants of `/tmp/somedir`:
  #
  #     zip '/tmp/somedir'
  #
  # Create `smalltalkx.bar.bz2` on `/tmp` containg contants of `/tmp/build_dir`
  # and remove `/tmp/build_dir` afterwards:
  # 
  #     zip '/tmp/build_dir', archive: 'smalltalkx', remove: true
  #  
  def zip(directory, remove: false, archive: nil, sha256: true, include: nil, exclude: [])        
    archive = directory unless archive
    if !(archive.end_with? '.zip') && !(archive.end_with? '.tar.gz') && !(archive.end_with? '.tar.bz2')
      archive = "#{directory}#{win32? ? '.zip' : '.tar.bz2'}"
    end      
    archive = File.expand_path(archive)
    source = [ "\"#{File.basename(directory)}\"" ]
    unless include.nil?
      source = include.collect { | each | "\"#{File.join(File.basename(directory), each)}\"" }
    end
    chdir File.dirname(directory) do
      case
        when (archive.end_with? '.zip')
          if not exclude.empty? 
            raise Exception.new("zip(): exclude: parameter not supported for .zip archives")
          end         
          sh "zip -q -r #{remove ? '-T -m' : ''} \"#{archive}\" #{source.join(' ')}"
        when (archive.end_with? '.tar.bz2')
          ex = (exclude.collect { | e | "\"--exclude=#{e}\" "}).join(' ')
          sh "tar cjf \"#{archive}\" #{remove ? '--remove-files' : ''} #{ex} #{source.join(' ')}"
        when (archive.end_with? '.tar.gz')
          ex = (exclude.collect { | e | "\"--exclude=#{e}\" "}).join(' ')
          sh "tar czf \"#{archive}\" #{remove ? '--remove-files' : ''} #{ex} #{source.join(' ')}"
        else
          raise Exception.new("Unknown archive type: #{File.basename(archive)}")
      end      
    end
    if sha256
      require 'digest'
      File.open("#{archive}.sha256", 'w') do |sum|
        sum.write Digest::SHA256.file(archive).hexdigest
      end
    end
  end

  # Extract an (compressed) archive. 
  # 
  # Files are extracted to the directory that contains `archive` unless 
  # options `directory: "some/other/directory` is given. 
  # 
  # If file named `#{archive}.sha256` exists then SHA256 checksum is validated
  # against the one `.sha256` file. If differ, an `Exception` is raised.
  #
  # If option `remove: true` is given, then the archive is removed after
  # all files are extracted. 
  # 
  def unzip(archive, directory: File.dirname(archive), remove: false)
    archive = File.expand_path archive
    sha256 = "#{archive}.sha256"
    if File.exist? sha256
      require 'digest'
      actual = Digest::SHA256.file(archive).hexdigest
      expected = nil
      File.open(sha256) {|f| expected = f.read}
      if actual != expected
        raise Exception.new("SHA256 checksum for #{archive} differ (actual #{actual}, expected #{expected}")
      end
    end

    chdir directory do
      case
        when (archive.end_with? '.zip')
          sh "unzip \"#{archive}\""
        when (archive.end_with? '.tar.bz2')
          sh "tar xjf \"#{archive}\""
        when (archive.end_with? '.tar.gz')
          sh "tar xzf \"#{archive}\""
        else
          raise Exception.new("Unknown archive type: #{File.basename(archive)}")
      end
    end
    rm_f archive if remove
  end


  # Like FileUtils.cp_r, but takes a filter proc that can return false 
  # to skip a file
  #
  # Note that if the filter rejects a subdirectory then everything within that
  # subdirectory is automatically skipped as well.
  #
  # Taken from http://www.ruby-forum.com/attachment/4467/filteredCopy.rb  
  # Both of these are modified from the implementations in fileutils.rb from 
  # Ruby 1.9.1p378  
  def cp_rx(src, dest, preserve: nil, noop: nil, verbose: nil,
         dereference_root: true, remove_destination: nil, &filter)        
    fu_output_message "cp_rx -r#{preserve ? 'p' : ''}#{remove_destination ? ' --remove-destination' : ''} #{[src,dest].flatten.join ' '} " if verbose 
    return if noop
    fu_each_src_dest(src, dest) do |s, d|
      copy_entryx s, d, filter, preserve, dereference_root, remove_destination
    end
  end

  # Like FileUtils.copy_entry, but takes a filter proc that can return false to skip a file
  def copy_entryx(src, dest, filter, preserve = false, dereference_root = false, remove_destination = false)
    Entry_.new(src, nil, dereference_root).traverse do |ent|
      if filter.call(ent.path())
        destent = Entry_.new(dest, ent.rel, false)
        File.unlink destent.path if remove_destination && File.file?(destent.path)
        ent.copy destent.path
        ent.copy_metadata destent.path if nil
      end
    end
  end


  # * ruby implementation of find that follows symbolic directory links
  # * tested on ruby 1.9.3, ruby 2.0 and jruby on Fedora 20 linux
  # * you can use Find.prune
  # * detect symlinks to dirs by path "/" suffix; does nothing with files so `symlink?` method is working fine
  # * depth first order
  # * detects cycles and raises an error
  # * raises on broken links
  # * uses recursion in the `do_find` proc when directory links are met (takes a lot of nested links until SystemStackError, that's practically never)
  #
  # * use like: find_follow(".") {|f| puts f}
  #
  # Copyright (c) 2014 Red Hat inc
  #
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in
  # all copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  # THE SOFTWARE.
  def find_follow(*paths)
    block_given? or return enum_for(__method__, *paths)

    link_cache = {}
    link_resolve = lambda {|path|
      # puts "++ link_resolve: #{path}" # trace
      link_cache[path] ? (return link_cache[path]) : (return link_cache[path] = Pathname.new(path).realpath.to_s)
    }
    # this lambda should cleanup `link_cache` from unnecessary entries
    link_cache_reset = lambda {|path|
      # puts "++ link_cache_reset: #{path}" # trace
      # puts link_cache.to_s # trace
      link_cache.select! {|k, v| path == k || k == '/' || path.start_with?(k + '/')}
      # puts link_cache.to_s # trace
    }
    link_is_recursive = lambda {|path|
      # puts "++ link_is_recursive: #{path}" # trace
      # the ckeck is useless if path is not a link but not our responsibility

      # we need to check full path for link cycles
      pn_initial = Pathname.new(path)
      # can we use `expand_path` here? Any issues with links?
      pn_initial = Pathname.new(File.join(Dir.pwd, path)) unless pn_initial.absolute?

      # clear unnecessary cache
      link_cache_reset.call(pn_initial.to_s)

      link_dst = link_resolve.call(pn_initial.to_s)

      pn_initial.ascend {|pn| (return {:link => path, :dst => pn}) if pn != pn_initial && link_dst == link_resolve.call(pn.to_s)}

      return false
    }

    do_find = proc {|multi_path|
      Find.find(multi_path) do |path|
        if File.symlink?(path) && File.directory?(File.realpath(path))
          if path[-1] == '/'
            # probably hitting https://github.com/jruby/jruby/issues/1895
            yield(path.dup)
            Dir.new(path).each {|subpath|
              do_find.call(path + subpath) unless %w('.' '..').include?(subpath)
            }
          elsif is_recursive == link_is_recursive.call(path) # TODO: meaning? was =
            raise "cannot handle recursive links: #{is_recursive[:link]} => #{is_recursive[:dst]}"
          else
            do_find.call(path + '/')
          end
        else
          yield(path)
        end
      end
    }

    # DO NOT ever change = by ==, we do need an assignment
    # here into `path` which is then used in the body!
    while path = paths.shift 
      do_find.call(path)
    end
  end

  # Taken from https://gist.github.com/akostadinov/fc688feba7669a4eb784
  # based on find_follow.rb : https://gist.github.com/akostadinov/05c2a976dc16ffee9cac
  # 
  # * use like: cp_r_dereference 'src', 'dst'
  #
  # Note: if directory `src` content is copied instead of the full dir. i.e. you end up
  #                                     with `dst/*` instead of `dst/basename(src)/*`
  # 
  # Copyright (c) 2014 Red Hat inc
  # 
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  # 
  # The above copyright notice and this permission notice shall be included in
  # all copies or substantial portions of the Software.
  # 
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  # THE SOFTWARE.

  # copy recursively de-referencing symlinks
  def cp_r_dereference(src, dst)
    src_pn = Pathname.new(src)
    find_follow(src) do |path|
      relpath = Pathname.new(path).relative_path_from(src_pn).to_s
      dstpath = File.join(dst, relpath)

      if File.directory?(path) || (File.symlink?(path) && File.directory?(File.realpath(path)))
        FileUtils.mkdir_p(dstpath)
      else
        FileUtils.copy_file(path, dstpath)
      end
    end
  end
end

module FileUtils::Entry_Extensions
  def fix_long_path(p)
    if win32? && p.size >= 260 && !p.start_with?("\\\\?\\") then      
      p = "\\\\?\\#{p.gsub('/','\\')}"      
    end
    p
  end

  def path
    fix_long_path(super)    
  end

  def copy_file(dest)
    super(fix_long_path(dest))
  end

end

class FileUtils::Entry_
  prepend FileUtils::Entry_Extensions
end
