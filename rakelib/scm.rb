require 'rakelib/hglib'

module Rake
end

module Rake::StX
end

# Cross-platform way of finding an executable in the $PATH.
#
#   which('ruby') #=> /usr/bin/ruby
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

cvs_rsh_set = false

module Rake::Stx::SCM
  # Not quite sure why following code
  #
  #     include RakeFileUtils
  #
  # does not make extra methods (like `sh`) defined in `extensions.rb`
  # visible here. To workaround, define them here. Ugly...
  module_function

  def sh(cmd, cwd: Dir.pwd, &block)
    begin
      return RakeFileUtils::sh(cmd, cwd: cwd, &block)
    rescue
      return false
    end
  end

  # Make sure CVS_RSH environment variable is properly set. Prefer MSYS2 ssh.exe
  # over plink.exe. For details, see `hglib.rb`, method `sshconf()`  
  module_function

  def ensure_cvs_rsh_set
    return if @cvs_rsh_set
    ssh = nil
    ssh_configured = ENV['CVS_RSH']
    ssh_in_path = which('ssh') ? true : false
    plink_in_path = which('plink') ? true : false
    if Gem.win_platform?
      # If CVS_RSH is not set or is set to plink.exe, try to change to 
      # MSYS2 ssh.exe as it gives better performance on (fast) LANs.      
      if /^.*[pP]link(\.exe)?"?\s*(-ssh)?\s*(-2)?$/ =~ ssh_configured
        ssh_in_path ? (ssh = 'ssh') : (ssh = %q{"c:\msys64\usr\bin\ssh.exe"} if File.exist? %q{c:\msys64\usr\bin\ssh.exe})

        # Sigh, we should not tamper with SSH configuration wildly. User may have
        # her ssh and mercurial properly configured to use `plink.exe` and `pageant`.
        # If we just start using `ssh.exe` clone/pull might not work beause
        # `ssh.exe` cannot talk to `pageant`. So, if we don't find OpenSSH's 
        # style of agent, don't use `ssh.exe` event if available.
        if ssh
          if ENV['SSH_AUTH_SOCK']
            # Good, OpenSSH agent running but still, be nice and  tell the 
            # user SSH configuration has been tampered wirh. 
            info("Setting CVS_RSH=\"#{ssh}\" for faster transfers")
          else
            # No agent, no fun. Be nice and give user a hit
            warn("Not using CVS_RSH=\"#{ssh}\" option because SSH agent is not running")
            warn("For faster CVS checkout over LAN, consider using ssh-agent or ssh-pageant (if you want to use PuTTY's pageant)")
            ssh = nil
          end
        end
      end
    else
      ssh = 'ssh' unless ssh_configured
    end
    ENV['CVS_RSH'] = ssh if ssh
    cvs_rsh_set = true
  end


  public

  class CheckoutException < Exception
  end # class CheckoutException


  def self._check_type(type)
    raise CheckoutException.new("Unknown version control system type (#{type})") if type != :cvs and type != :svn and type != :git and type != :hg
  end

  def self.update(repository, directory, **kwargs)
    type = repository.type
    url = repository.canonical
    self._check_type(type)
    root = kwargs[:root] || BUILD_DIR
    branch = kwargs[:branch]
    if branch.nil?
      if type == :svn
        branch = 'trunk'
      elsif type == :hg
        branch = 'default'
      end
    end

    wc = root / directory
    unless File.exist? wc
      self.checkout(repository, directory, **kwargs)
      return
    end

    case type
      when :svn
        _update_svn(repository, directory, branch, root, **kwargs)
      when :cvs
        _update_cvs(repository, directory, branch, root, **kwargs)
      when :git
        _update_git(repository, directory, branch, root, **kwargs)
      when :hg
        _update_hg(repository, directory, branch, root, **kwargs)
      else
        error("Type #{type} not found")
    end
  end

  def self._update_hg(repository, directory, branch, root, **kwargs)

    wc = root / directory
    separator = kwargs[:separator] || '.'
    revision = kwargs[:revision]
    url = "#{repository.canonical}/#{directory.gsub('/', separator)}" unless directory.nil?
    hg = HG::Repository.new(wc)
    begin
      paths = hg.paths
      if repository.staging
        unless paths.has_key? 'staging'
          paths['staging'] = "#{repository.staging}/#{directory.gsub('/', separator)}"
          hg.paths = paths
        end
        hg.pull('staging')
      end
      if repository.upstream
        unless paths.has_key? 'upstream'
          paths['upstream'] = "#{repository.upstream}/#{directory.gsub('/', separator)}"
          hg.paths = paths
        end
        hg.pull('upstream')
      end
      unless paths.has_key? 'canonical'
        paths['canonical'] = "#{repository.canonical}/#{directory.gsub('/', separator)}"
        hg.paths = paths
      end
      hg.pull('canonical')
      # If revision is not specified, then look for an active bookmark
      # and update to it. If no bookmark is active, then look for bookmark
      # `master`. If it exist, then update to `master`. If it
      # does not, then update to tip or throw an error.
      # The error is thrown if there's no bookmark `master` and
      # branch has multiple heads since it's not clear which
      # head rev to use.
      unless revision
        revision = hg.bookmark
        unless revision
          bookmarks = hg.bookmarks(branch)
          if bookmarks.has_key? 'master'
            revision = 'master'
          else
            if hg.heads(branch, include_secret: false).size > 1
              raise CheckoutException.new("HG: Cannot checkout #{directory}: directory. The ->#{branch}<- branch has multiple heads but no bookmark named 'master'! (All other branches are ignored)")
            end
          end
        end
      end
      hg.update(revision || branch)
    rescue Exception => ex
      raise CheckoutException.new("HG: Cannot update #{wc}: #{ex.message}")
    end
  end


  def self._update_svn(repository, directory, branch, root, **kwargs)
    wc = root / directory
    raise CheckoutException.new("SVN: Cannot update #{wc}") unless (sh %W{svn --non-interactive --trust-server-cert update}, cwd: wc)
  end

  def self._update_cvs(repository, directory, branch, root, **kwargs)
    ensure_cvs_rsh_set
    wc = root / directory
    if File.directory? wc
      raise CheckoutException.new("CVS: Cannot update #{wc}") unless (sh %W{cvs -z 9 update -A -d}, cwd: wc)
    else
      raise CheckoutException.new("CVS: Cannot update #{wc}") unless (sh %W{cvs -z 9 update -A #{File.basename(wc)}}, cwd: File.dirname(wc))
    end
  end

  def self.checkout(repository, directory, **kwargs)
    type = repository.type
    url = repository.canonical
    self._check_type(type)

    root = kwargs[:root] || BUILD_DIR
    branch = kwargs[:branch]
    if branch.nil?
      if type == :svn
        branch = 'trunk'
      elsif type == :hg
        branch = 'default'
      end
    end

    wc = root / directory
    if File.exist? wc
      self.update(repository, directory, **kwargs)
      return
    end


    unless File.exists? File.dirname(wc)
      begin
        FileUtils.mkdir_p(File.dirname(wc))
      rescue => ex
        raise CheckoutException.new("Cannot create directory for working copy (#{ex})")
      end
    end
    case type
      when :svn
        _checkout_svn(repository, directory, branch, root, **kwargs)
      when :cvs
        _checkout_cvs(repository, directory, branch, root, **kwargs)
      when :git
        _checkout_git(repository, directory, branch, root, **kwargs)
      when :hg
        _checkout_hg(repository, directory, branch, root, **kwargs)
      else
        error("Type #{type} not found")
    end

  end

  def self._checkout_svn(repository, directory, branch, root, **kwargs)
    url = "#{repository.canonical}/#{directory}/#{branch}"
    raise CheckoutException.new("SVN: Cannot checkout from #{url}") unless (sh %W{svn --non-interactive --trust-server-cert co #{url} #{directory}}, cwd: root)
  end

  def self._checkout_hg(repository, directory, branch, root, **kwargs)
    separator = kwargs[:separator] || '.'
    revision = kwargs[:revision]

    paths = {}
    if repository.canonical
      paths['canonical'] = "#{repository.canonical}/#{directory.gsub('/', separator)}"
    else
      raise Exception.new("Repository named #{repository.name} does not define mandatory canonical repository URL")
    end
    if repository.upstream
      paths['upstream'] = "#{repository.upstream}/#{directory.gsub('/', separator)}"
    end
    if repository.staging
      paths['staging'] = "#{repository.staging}/#{directory.gsub('/', separator)}"
    end
    paths['default'] = paths['staging'] || paths['upstream'] || paths['canonical']

    begin
      hg = HG::Repository.init(root / directory)
      # Configure path aliases.
      #
      # Set the repository as non-publishing, This way when cloning from a staging
      # repo changes in draft phase would remain drafs. This is  essential to
      # employ evolve extension and being able to fix & evolve changes in clones
      # (on a CI server, for instance) and being able to push back without need to
      # fiddle around phases.
      #
      # The downside is that we cannot do an `uncompressed` pull. This is the price
      # we have to pay.
      hg.config_set(
          phases: {'publish' => 'false'},
          paths: paths
      )

      hg.pull('staging') if repository.staging
      hg.pull('upstream') if repository.upstream
      hg.pull('canonical') if repository.canonical
      # If revision is not specified, then look for bookmark
      # `master`. If it exist, then check out `master`. If it
      # does not, then checkout tip or throw an error.
      # The error is thrown if there's no bookmark `master` and
      # branch has multiple heads since it's not clear which
      # head rev to use.
      unless revision
        bookmarks = hg.bookmarks(branch)
        if bookmarks.has_key? 'master'
          revision = 'master'
        else
          if hg.heads(branch).size > 1
            raise CheckoutException.new("HG: Cannot checkout #{directory}: branch #{branch} has multiple heads but no bookmark named 'master'!")
          end
        end
      end

      hg.update(revision || branch)
      #rescue Exception => e
      #  raise CheckoutException.new("HG: Cannot clone from #{url}: #{e.message}")
    end
  end

  def self._checkout_cvs(repository, directory, branch, root, **kwargs)
    revision = kwargs[:revision] || nil
    revision_arg = ''
    if revision
      raise Exception.new('CVS only support date spec as revision: option (YYYY-MM-DD)') unless revision.match(/^\d{4}-([0]\d|[1][012])-([012]\d|[3][01])$/)
      revision_arg = " -D #{revision}"
    end
    ensure_cvs_rsh_set
    unless sh "cvs -z 9 -d #{repository.canonical} co #{revision_arg} #{directory}", cwd: root
      raise CheckoutException.new("CVS: Cannot checkout #{directory}from #{repository.url}")
    end
  end

end # module Rake::Stx::SCM

def checkout(repo_name, directory, **kwargs)
  # repository should be symbolic name
  repo = Rake::Stx::Configuration::Repository::find(repo_name)
  error("checkout: No repository found (#{repo_name})") unless repo
  kwargs[:separator] = repo.separator
  Rake::Stx::SCM.checkout(repo, directory, **kwargs)
end

def update(repo_name, directory, **kwargs)
  # repository should be symbolic name
  repo = Rake::Stx::Configuration::Repository::find(repo_name)
  error("update: No repository found (#{repo_name})") unless repo
  kwargs[:separator] = repo.separator
  Rake::Stx::SCM.update(repo, directory, **kwargs)
end

def cvs(url, directory, **kwargs)
  repo = Rake::Stx::Configuration::Repository.new(:type => :cvs, :url => url)
  Rake::Stx::SCM.checkout(repo, directory, **kwargs)
end

def svn(url, directory, **kwargs)
  repo = Rake::Stx::Configuration::Repository.new(:type => :svn, :url => url)
  Rake::Stx::SCM.checkout(repo, directory, **kwargs)
end

def hg(url, directory, **kwargs)
  repo = Rake::Stx::Configuration::Repository.new(:type => :hg, :url => url)
  Rake::Stx::SCM.checkout(repo, directory, **kwargs)
end

def git(url, directory, **kwargs)
  repo = Rake::Stx::Configuration::Repository.new(:type => :git, :url => url)
  Rake::Stx::SCM.checkout(repo, directory, **kwargs)
end

