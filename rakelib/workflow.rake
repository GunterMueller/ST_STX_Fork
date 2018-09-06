# This file contains various tasks usefull for Smalltalk/X jv-branch 
# development. Currently it only supports working with Mercurial repositories,
# Honestly, there's not much one can do with CVS, we're using it only for
# packages that have not been converted to Mercurial. 

namespace :'workflow' do
  # A helper function to :push-upstream and push-staging tasks
  def hg_repositories
    project.packages_and_application.each do |pkg|
      unless pkg.nested_package?
        repo = Rake::Stx::Configuration::Repository::find(pkg.repository)
        if repo != nil and repo.type == :'hg' and (File.exists?(BUILD_DIR / pkg.directory / '.hg' / 'hgrc'))
          hg = HG::Repository.new(BUILD_DIR / pkg.directory)
          yield pkg, hg
        end
      end
    end
  end

  def push(remote, user, pass, review_only, push_bookmark)
    has_changes = false
    hg_repositories do |pkg, hg|
      opts = {
          :user => user,
          :pass => pass,
      }
      paths = hg.paths
      remote_used = remote
      if remote_used == 'upstream'
        remote_used = 'canonical' unless paths['upstream']
      elsif remote_used == 'staging'
        unless paths['staging']
          puts ''
          puts "!! repository #{hg.path} has not staging repository defined - skipping !!"
          puts ''
          return
        end
      end

      # STC and librun are special - never push them automatically
      # to upstream / canonical repo, must be done manually. This is 
      # mainly beacuse there are on separate protected repositories 
      # not accessible without a special setup. Sigh...
      if ((pkg.name == 'stx:stc') or (pkg.name == 'stx:librun')) and ((remote_used == 'upstream') or (remote_used == 'canonical'))
        if !review_only
          puts ''
          puts "== Skipping push of #{pkg.name} - you must push manually =="
          puts''
        end
      else
        if review_only
          opts[:rev] = '.'
          remote_url = hg.paths[remote_used] || remote_used
          bookmark = hg.bookmark
          hg.outgoing(remote_used, **opts) do | status, stdout |
            case status.exitstatus
            when 0          
              puts ''
              puts "== changes going to #{remote_url} =="
              STDOUT.print stdout
              puts "Will update bookmark '#{bookmark}" if push_bookmark and bookmark
              puts '===================================='
              has_changes = true
            when 1
              # nothing
            else        
              raise Exception.new("Failed to do 'outgoing' from #{remote} (exit code #{status.exitstatus})")
            end
          end
        else
          (push_bookmark && bookmark) ? (opts[:bookmarks] = ['.']) : (opts[:rev] = '.') # bookmark can be uninitialized
          hg.push(remote_used, **opts)
          has_changes = true
        end
      end
    end
    has_changes
  end

  desc 'Display changes to be pushed to upstream repositores (use it to review what workflow:push-upstream would do)'
  task :'out-upstream', :user, :pass do |t, args|
    RakeFileUtils.verbose(false) do
      has_changes = push('upstream', args[:user], args[:pass], true, false)
      puts 'No changes to be pushed to upstream repositories' unless has_changes
      exit(has_changes ? 0 : 1 )
    end
  end
  task :'out-upstream' => :'setup'

  desc 'Push currently checked out revisions to upstream repositories (to be called after all tests pass on all configurations)'
  task :'push-upstream', :user, :pass do |t, args|
    push('upstream', args[:user], args[:pass], false, false)
  end
  task :'push-upstream' => :'setup'


  desc 'Display changes to be pushed to staging repositores (use it to review what workflow:push-staging would do)'
  task :'out-staging', :user, :pass do |t, args|
    RakeFileUtils.verbose(false) do
      has_changes = push('staging', args[:user], args[:pass], true, true)
      puts 'No changes to be pushed to staging repositories' unless has_changes
      exit(has_changes ? 0 : 1 )
    end
  end
  task :'out-staging' => :'setup'

  desc 'Push currently checked out revisions to staging repositories (to be by developer to test her changes)'
  task :'push-staging', :user, :pass do |t, args|
    push('staging', args[:user], args[:pass], false, true)
  end
  task :'push-staging' => :'setup'

  desc '(Auto)merge changes (from eXept)'
  task :'merge' => :'setup' do
    unless which("hg-automerge.rb")
      info "Cannot find 'hg-automerge.rb' in PATH"
      info 'You may find it at https://bitbucket.org/janvrany/jv-scripts'
      error "Cannot find 'hg-automerge.rb' in PATH"
    end
    hg_repositories_failed_to_merge = []
    hg_repositories do |pkg, hg|
      if File.exist? (hg.path / '.hgautomerge')
        info "Merging #{hg.path}"
        sh "hg-automerge.rb --cwd #{hg.path}"
      else
        info "Not merging #{hg.path} - no merge config found."
        info "To configure run: 'hg-automerge.rb --cwd #{hg.path} --config'"
      end
    end
  end

end
