# This file is not a standalone script. It is a kind
# of lightweight Mercurial library used by other scripts.

require 'uri'
require 'open3'
require 'shellwords'

# Following hack is to make hglib.rb working wit both jv:scripts and
# Smalltalk/X rakefiles. 
begin
  require 'rakelib/inifile'
rescue
  begin
    require 'inifile'
  rescue LoadError => ex
    $LOGGER.error(%q{Cannot load package 'inifile'})
    $LOGGER.error(%q{Run 'gem install inifile' to install it})
    exit 1
  end
end

unless $LOGGER
  if STDOUT.tty? or win32?
    require 'logger'
    $LOGGER = Logger.new(STDOUT)

    if !VERBOSE.nil?
      $LOGGER.level = Logger::DEBUG
    else
      $LOGGER.level = Logger::INFO
    end
  else
    require 'syslog/logger'
    $LOGGER = Syslog::Logger.new($0)
  end
end

module HG
  @@config = nil

  # Cross-platform way of finding an executable in the $PATH.
  #
  #   which('ruby') #=> /usr/bin/ruby
  module_function

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

  GLOBAL_OPTIONS = %i(cwd repository noninteractive config debug debugger encoding
                      encodingmode traceback time profile version help hidden
                      )

  # Execute `hg` command with given positional arguments and
  # keyword arguments turned into command options. For example,
  #
  #     HG::hg("heads", "default", cwd: '/tmp/testrepo')
  #
  # will result in executing
  #
  #     hg --cwd '/tmp/testrepo' heads default
  #
  # In addition if block is passed, then the block is evaluate with
  # `hg` command exit status (as Process::Status) and (optionally)
  # with contents of `hg` command stdout and stderr.
  # If no block is given, an exception is raised when `hg` command
  # exit status IS NOT zero.
  def self.hg(command, *args, **options, &block)
    g_opts = []
    c_opts = []
    options.each do |k, v|
      if v != false and !v.nil?
        o = k.size == 1 ? "-#{k}" : "--#{k}"
        if GLOBAL_OPTIONS.include? k
          if v.is_a?(Array)
            v.each do |e|
              g_opts << o << (e == true ? '' : e) # bug ruby: e ? '' : e does not work correctly
            end
          else
            g_opts << o << (v == true ? '' : v)
          end
        else
          if v.is_a?(Array)
            v.each do |e|
              c_opts << o << (e == true ? '' : e)
            end
          else
            c_opts << o << (v == true ? '' : v)
          end
        end
      end
    end
    c_opts.reject! {|e| e.size == 0}
    cmd = ['hg'] + g_opts + [command] + c_opts + args
    cmd_info = cmd.shelljoin.
        gsub(/username\\=\S+/, "username\\=***").
        gsub(/password\\=\S+/, "password\\=***")
    $LOGGER.debug("executing: #{cmd_info}")
    if defined? RakeFileUtils and RakeFileUtils.verbose; puts cmd_info; end

    if block_given?
      stdout, stderr, status = Open3.capture3(*cmd)
      case block.arity
      when 1
        STDOUT.print stdout if defined? RakeFileUtils and RakeFileUtils.verbose
        STDERR.print stderr if defined? RakeFileUtils and RakeFileUtils.verbose       
        yield status
      when 2                
        STDERR.print stderr if defined? RakeFileUtils and RakeFileUtils.verbose
        yield status, stdout
      when 3        
        yield status, stdout, stderr
      else
        raise Exception.new("invalid arity of given block")
      end
    else
      raise Exception.new("command failed: #{cmd.join(' ')}") unless system(*cmd)
    end
  end

  def self.config
    if @@config.nil?
      files = Dir.glob('/etc/mercurial/hgrc.d/*.rc') +
          ['/etc/mercurial/hgrc',
           hgrc]
      if Gem.win_platform?
        hg_exe = HG::which("hg")
        hgrc_d = File.join(File.dirname(hg_exe), "hgrc.d")
        if File.directory? (hgrc_d)
          files += Dir.glob("#{hgrc_d}\\*.rc".gsub('\\', '/'))
        end
      end
      @@config = IniFile.new
      files.each do |file|
        if File.exist?(file)
          $LOGGER.debug("Loading global config from \"#{file}\"")
          @@config.merge!(IniFile.new(:filename => file))
        end
      end
    end
    return @@config
  end

  def self.hgrc
    return File.expand_path('~/.hgrc')
  end

  class Repository
    @@HOSTS_ON_LAN = {}

    attr_accessor :path, :config


    private
    # Return --ssh config string for use with passed remote url or nil
    # if no special --ssh config is needed.
    #
    # Rationale:
    #
    # On Windows, most of users tend to use TortoiseHG and hg.exe comming with
    # it. THG makes hg.exe to use (shipped) plink.exe which is bad for performance
    # since it uses 16k channel input buffer (!) leading to a pretty slow transfers
    # (a lot of iowaits...)
    # OpenSSH OTOH has 2MB input buffer which is good though on Windows bit
    # oversized as Windows TCP window size is fixed to 65k for all connections with
    # RTT less than 1ms. Still, 65k better then 16k.
    # As a workaround, look if MSYS2's OpenSSH client is installed and if so, use that
    # one - but only if `ui.ssh` config option has the default value.
    # Ugly, isn't it?
    def self.sshconf(uri_string)
      uri = URI(uri_string)
      ssh = nil
      if uri.scheme == 'ssh'
        ssh_in_path = HG::which('ssh') ? true : false
        if Gem.win_platform?
          # Running on Windows
          #
          # Mercurial uses `ssh` by default, so to use `plink.exe`, `ui.ssh`
          # config option has to be explicitly set.
          #
          # It it's set to `plink.exe`, check whether MSYS's `ssh.exe` is available
          # and if so, change it to `ssh.exe`...
          ssh_configured = HG::config['ui']['ssh']
          if /^.*[pP]link.exe"?\s*(-ssh)?\s*(-2)?$/ =~ ssh_configured
            if ssh_in_path
              ssh = 'ssh'
            else
              ssh = %q{"c:\msys64\usr\bin\ssh.exe"} if File.exist? %q{c:\msys64\usr\bin\ssh.exe}
            end
            # Sigh, we should not tamper with SSH configuration wildly. User may have
            # her ssh and mercurial properly configured to use `plink.exe` and `pageant`.
            # If we just start using `ssh.exe` clone/pull might not work beause
            # `ssh.exe` cannot talk to `pageant`. So, if we don't find OpenSSH's
            # style of agent, don't use `ssh.exe` event if available.
            if ssh
              if ENV['SSH_AUTH_SOCK']
                # Good, OpenSSH agent running but still, be nice and  tell the
                # user SSH configuration has been tampered wirh.
                $LOGGER.info("Passing --ssh \"#{ssh}\" option to 'hg' command for faster transfers")
              else
                # No agent, no fun. Be nice and give user a hit
                $LOGGER.warn("Not using -ssh \"#{ssh}\" option because SSH agent is not running")
                $LOGGER.warn("For faster clone/pull consider using ssh-agent or ssh-pageant (if you want to use PuTTY's pageant)")
                ssh = nil
              end
            end
            # Turn off SSH compression - data transferred by Mercurial are either
            # already compressed or --uncompressed was given to reduce CPU load
            # in which case passing -C would reduce it further.
            ssh += ' -C' if ssh and HG::Repository::host_on_lan?(uri.host)
          end
        else
          # Turn off SSH compression - data transferred by Mercurial are either
          # already compressed or --uncompressed was given to reduce CPU load
          # in which case passing -C would reduce it further.
          ssh = 'ssh -C' if ssh_in_path and HG::Repository::host_on_lan?(uri.host)
        end
      end
      return ssh
    end

    # Same as class method, but allows for remote aliases
    def sshconf(remote)
      HG::Repository::sshconf(self.paths[remote] || remote)
    end

    # Given a hostname, return true if the host is on local LAN, false
    # otherwise.
    #
    # Results are cached to reduce resolver queries (maybe not worth it,
    # system may cache answers anyways)
    #
    # The detection is rather simplistic - it only checks if host's address
    # is from private IP range - and only for IPv4.
    # This may cause problems when using over VPN that assigns private address
    # (the usuall case). In that case this code will treat is a local
    # which may result in transfer of uncompressed data over WAN. Not nice,
    # This should be fixed, somehow. 
    def self.host_on_lan?(hostname)
      unless @@HOSTS_ON_LAN.has_key? hostname
        require 'resolv'
        addr = Resolv.getaddress(hostname)
        # Really poor detection of LAN, but since this is an
        # optimization, getting this wrong does not hurt.
        local = (addr.start_with? '192.168.') or (addr.start_with? '10.10.')
        @@HOSTS_ON_LAN[hostname] = local
      end
      return @@HOSTS_ON_LAN[hostname]
    end

    public
    # Clone a repository from given `uri` to given `directory`.
    # Returns an `HG::Repository` instance representing the repository
    # clone.
    # If `noupdate` is true, working copy is not updated, i.e., will be
    # empty. Use this when you're going to issue `update(rev)` shortly after.
    #
    def self.clone(uri, directory, noupdate: false, publishing: false)
      uri_obj = URI(uri)
      host = uri_obj.host
      scheme = uri_obj.scheme
      # When cloning over LAN, use --uncompressed option
      # as it tends to be faster if bandwidth is good (1GB norm
      # these days) amd saves some CPU cycles.
      local = HG::Repository::host_on_lan?(URI(uri).host)
      ssh = HG::Repository::sshconf(uri)

      HG::hg('clone', uri, directory, ssh: ssh, uncompressed: local, noupdate: noupdate, config: "phases.publish=#{publishing}")
      return HG::Repository.new(directory)
    end

    # Initializes an empty repository in given directory. Returns an
    # `HG::Repository` instance representing the created (empty) repository.
    # TODO: unreachable code!!!
    def self.init(directory)
      HG::hg('init', directory)
      return HG::Repository.new(directory)
    end

    # Like HG::hg, but passes --cwd @path
    def hg(command, *args, **options, &block)
      options[:cwd] = @path
      HG::hg(command, *args, **options, &block)
    end

    def hgrc
      File.join(@path, '.hg', 'hgrc')
    end

    def initialize(directory)
      dir = File.expand_path(directory)
      if not File.exist?(File.join(dir, '.hg'))
        raise Exception.new("Not a Mercurial repository (missing .hg directory): #{dir}")
      end
      @path = dir
      initialize_config    
    end

    def initialize_config
      config_file = hgrc
      if File.exist? (config_file)
        $LOGGER.debug("Loading repository config from \"#{config_file}\"")
        @config = HG::config().merge(IniFile.new(:filename => config_file))
      else
        @config = HG::config()
      end
    end

    # Add / replace given config options and write back
    # .hg/hgrc
    def config_set(**options)
      config = IniFile.new(:filename => self.hgrc)
      options.each do |section, keys_and_values|
        keys_and_values.each {|key, value| config[section][key] = value.to_s}
      end
      config.write
      initialize_config
    end

    # Return a hashmap with defined paths (alias => uri)
    def paths
      @config['paths'].clone
    end

    # Set paths for given repository
    def paths=(paths)
      config_set(paths: paths)
    end

    def log(revset, template = "{node|short}\n")
      log = []
      hg('log', rev: revset, template: template) do |status, out|
        if status.success?
          puts out if defined? RakeFileUtils and RakeFileUtils.verbose
          log = out.split("\n")
        end
      end
      return log
    end

    def locate(revset = '.', pattern: '*')
      files = []
      hg('locate', rev: revset, include: pattern) do |status, out|
        if status.success?          
          files = out.split("\n")
        end
      end
      return files
    end

    # Return current branch name
    def branch()      
      hg('branch') do | status, out |
        if status.success?          
          return out.strip()
        end
      end
      raise Exception.new("Failed to retrieve current branch")
    end

    # Return changeset IDs of all head revisions. 
    # If `branch` is given, return only heads in given
    # branch.
    # If `secret_secret` is false, then changesets in 
    # secret phase are ignored (even if thet're heads    
    def heads(branch = nil, include_secret: true)
      revset  = "head()"
      revset += " and branch('#{branch}')" if branch
      revset += " and !secret()" if not include_secret
      return log(revset)
    end

    # Return name of an active bookmark or nil if no bookmark
    # is active
    def bookmark
      filename = File.join(@path, '.hg', 'bookmarks.current')
      if File.exist?(filename)
        file = File.open(filename, 'r')
        begin
          bookmark = file.read.chomp
        ensure
          file.close
        end
        bookmark
      else
        nil
      end
    end

    # Return a hash "bookmark => revision" of all
    # bookmarks.
    def bookmarks(branch = nil)
      revset = 'bookmark()'
      revset += " and branch('#{branch}')" if branch
      bookmarks = {}
      self.log(revset, "{bookmarks}|{node|short}\n").each do |line|
        bookmarks_per_changeset, changesetid = line.split('|')
        bookmarks_per_changeset.split(' ').each {|bookmark| bookmarks[bookmark] = changesetid}
      end
      bookmarks
    end

    # a private helper to generate auth --config options for
    # HTTP-served repositories
    protected
    def authconf(remote, user, pass)
      authconf = []
      unless pass.nil?
        raise Exception.new('Password given but not username! Use user: named param to specify username.') if user.nil?
        # If user/password is provided, make sure we don't have
        # username in remote URI. Otherwise Mercurial won't use
        # password from config!
        uri = URI.parse(self.paths[remote] || remote)
        uri.user = nil
        uri = uri.to_s
        uri_alias = self.paths.has_key? remote ? remote : 'xxx'
        authconf << "auth.#{uri_alias}.prefix=#{uri}"
        authconf << "auth.#{uri_alias}.username=#{user}"
        authconf << "auth.#{uri_alias}.password=#{pass}"
      end
      authconf
    end

    public

    def incoming(remote = 'default', user: nil, pass: nil, rev: nil)
      hg('incoming', remote, ssh: sshconf(remote), config: authconf(remote, user, pass), rev: rev) do |status, stdout|
        case status.exitstatus
          when 0
            STDOUT.print stdout
          when 1
            puts "No new changes coming from #{remote}"
          else
            raise Exception.new("Failed to do 'incoming' from #{remote} (exit code #{status.exitstatus})")
        end
      end
    end

    def pull(remote = 'default', user: nil, pass: nil, rev: nil, bookmarks: nil)
      hg('pull', remote, ssh: sshconf(remote), config: authconf(remote, user, pass), rev: rev, bookmark: bookmarks) do |status, stdout|
        STDOUT.print stdout
        case status.exitstatus
          when 0
            #nothing
          when 1
            raise Exception.new("Failed to 'pull' from #{remote} (update had unresolved conflicts)")
          else
            raise Exception.new("Failed to 'pull' from #{remote} (exit code #{status.exitstatus})")
        end
      end
    end

    def outgoing(remote = 'default', user: nil, pass: nil, rev: nil, &block)      
      if !block_given?
      hg('outgoing', remote, ssh: sshconf(remote), config: authconf(remote, user, pass), rev: rev) do |status, stdout|
        case status.exitstatus
          when 0
            STDOUT.print stdout
          when 1
            puts "No new changes going to #{remote}"
          else
            raise Exception.new("Failed to do 'outgoing' from #{remote} (exit code #{status.exitstatus})")
        end
      end
      else
        hg('outgoing', remote, ssh: sshconf(remote), config: authconf(remote, user, pass), rev: rev, &block)
      end
    end

    def push(remote = 'default', user: nil, pass: nil, rev: nil, bookmarks: [])
      hg('push', remote, ssh: sshconf(remote), config: authconf(remote, user, pass), rev: rev, bookmark: bookmarks) do |status, stdout, stderr|
        STDOUT.puts stdout
        unless status.exitstatus == 0 or status.exitstatus == 1
          STDERR.puts stderr
          raise Exception.new("Failed to 'push' from #{remote} (exit code #{status.exitstatus})")
        end
      end
    end


    # Create a shared clone in given directory, Return a new
    # HG::Repository object on the shared clone
    def share(dst, rev = nil)
      raise Exception.new("Destination file exists: #{dst}") if File.exist? dst
      rev = log('.')[0] if rev.nil?
      raise Exception.new("Revision #{rev} does not exist") unless has_revision? rev
      mkdir_p File.dirname(dst)
      HG::hg('share', path, dst, config: 'extensions.share=', noupdate: true, bookmarks: false)
      share = Repository.new(dst)
      share.update(rev)
      share
    end

    # Updates the repository's working copy to given
    # revision if given. If not, update to most-recent
    # head, as plain
    #
    #   hg update
    #
    # would do. 
    def update(rev = nil)
      if rev
        raise Exception.new("Revision #{rev} does not exist") unless has_revision? rev
        hg('update', rev: rev)
      else
        hg('update')
      end
    end

    # Merge given revision. Return true, if the merge was
    # successful, false otherwise
    def merge(rev)
      raise Exception.new("Revision #{rev} does not exist") unless has_revision? rev
      hg('merge', rev) {|status| return status.success?}
    end

    def commit(message, user='')
      user = @config['ui']['username'] unless @config['ui'].has_key? 'username'
      hg('commit', message: message, user: user)
    end

    def has_revision?(rev)
      revs = log(rev)
      revs.size > 0
    end

    # Lookup a repository in given `directory`. If found,
    # return it as instance of HG::Repository. If not,
    # `nil` is returned.
    def self.lookup(directory)
      return nil unless File.exist?(directory)
      repo_dir = directory
      until repo_dir.nil?
        return Repository.new(repo_dir) if HG::repository? repo_dir
        repo_dir_parent = File.dirname(repo_dir)
        repo_dir_parent == repo_dir ? (repo_dir = nil) : (repo_dir = repo_dir_parent)
      end
    end    

    # Initializes and empty Mercurial repository in given `directory`
    def self.init(directory)
      FileUtils.mkdir_p File.dirname(directory)
      HG::hg("init", directory)
      return Repository.new(directory)
    end
  end # class Repository 

  # Return `true` if given `directory` is a root of mercurial
  # repository, `false` otherwise.
  def self.repository?(directory)
    return File.directory? File.join(directory, '.hg')
  end

  # Enumerate all repositories in given `directory`
  def self.forest(directory, &block)
    yield Repository.new(directory) if repository? directory
    Dir.foreach(directory) do |x|
      path = File.join(directory, x)
      if File.directory? path
        if x == '.' or x == '..' or x == '.svn' or x == '.git'
          next
        elsif File.directory?(path)
          forest(path, &block)
        end
      end
    end  
  end
end # module HG
