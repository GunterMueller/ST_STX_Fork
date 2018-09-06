task :'dist:jv' => %i(dist:jv:pre dist:jv:main dist:jv:post)

app_version = nil
version = nil

install_dir = nil
bin_dir = nil
pkg_dir = nil
lib_dir = nil
include_dir = nil
libexec_dir = nil
rc_dir = win32? ? bin_dir : lib_dir

install_dir_doc = nil
doc_dir = nil


namespace :'dist:jv' do
  task :variables do
    app_name = project.app_name || (raise Exception.new('No app_name property specified'))
    app_version = project.app_version || (raise Exception.new('No app_version property specified'))
    version = app_version.split('_').first

    install_dir = ARTIFACTS_DIR / BUILD_NAME
    bin_dir = install_dir / 'bin'
    pkg_dir = install_dir / 'lib' / 'smalltalkx' / version / 'packages'
    lib_dir = install_dir / 'lib' / 'smalltalkx' / version / 'lib'
    include_dir = install_dir / 'lib' / 'smalltalkx' / version / 'include'
    rc_dir = win32? ? bin_dir : lib_dir
    libexec_dir = install_dir / 'lib' / 'smalltalkx' / version / 'bin'

    # install_dir_doc = ARTIFACTS_DIR / 'docs' / "#{app_name}-#{app_version}_docs"
    # doc_dir = install_dir_doc / 'share' / 'doc' / 'smalltalkx' / version

    install_dir_doc = install_dir
    doc_dir = install_dir / 'lib' / 'smalltalkx' / version

    # HACK to make dirs globally available in 'post' rules...
    $install_jv_dirs = {
        :install_dir => install_dir,
        :bin_dir => bin_dir,
        :doc_dir => doc_dir,
        :pkg_dir => pkg_dir,
        :lib_dir => lib_dir,
        :include_dir => include_dir,
        :rc_dir => rc_dir,
        :libexec_dir => libexec_dir
    }

  end

  task :all => %i(pre main post)

  task :pre
  task :post

  task :main => %i(setup binaries scripts librun packages resources doc)

  task :binaries => :variables do
    mkdir_p bin_dir
    mkdir_p libexec_dir

    install STC, bin_dir
    install STC, libexec_dir
    case
      when win32?
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk' / 'stx.exe', libexec_dir
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk' / 'stx.com', libexec_dir
      when unix?
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk' / 'stx', libexec_dir
        mv libexec_dir / 'stx', libexec_dir / 'stx-bin'
      else
        error_unsupported_platform
    end
  end

  task :resources => :variables do
    %w(stx/goodies/bitmaps
       stx/doc/online/english/credits.html
    ).each do |resource|
      mkdir_p pkg_dir / File.dirname(resource)
      cp_r BUILD_DIR / resource, pkg_dir / File.dirname(resource)
    end

    rm_rf pkg_dir / 'stx' / 'include'
    cp_r_dereference BUILD_DIR / 'stx' / 'include', include_dir
  end

  task :scripts => :variables do
    mkdir_p bin_dir
    mkdir_p lib_dir
    mkdir_p lib_dir / 'rc.d'

    rc_files = %w{display.rc host.rc keyboard.rc smalltalk_r.rc smalltalk.rc private.rc patches}
    if win32?
      rc_files << 'd_win32.rc'
    else
      #rc_files << 'd_xfree.rc'
      #rc_files << 'd_xorg.rc'
    end

    rc_files.each {|rc_file| install BUILD_DIR / 'stx' / 'projects' / 'smalltalk' / rc_file, rc_dir}
    install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ '*.wsp', lib_dir
    install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'rc.d' / '*', lib_dir / 'rc.d'

    case
      when win32?
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'smalltalk.bat', bin_dir / 'stx.bat'
        sed "SET stx_version=\"!stx_version_default!\"", "SET stx_version=#{version}", bin_dir / 'stx.bat', true
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'smalltalk.ps1', bin_dir / 'smalltalk.ps1'
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'smalltalk.cfg', bin_dir / 'smalltalk.cfg'
      when unix?
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'smalltalkx.desktop', bin_dir / 'stx'
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'smalltalkx.svg', bin_dir / 'stx'
        install BUILD_DIR / 'stx' / 'projects' / 'smalltalk'/ 'smalltalk', bin_dir / 'stx'
        sed 'STX_VERSION=$STX_VERSION_DEFAULT', "STX_VERSION=#{version}", bin_dir / 'stx', true
      else
        error_unsupported_platform
    end

  end

  task :librun => :variables do
    case
      when unix?
        mkdir_p lib_dir / 'lib'
        install BUILD_DIR / 'stx' / 'librun' / 'librun.so', lib_dir / 'lib'
      when win32?
        install BUILD_DIR / 'stx' / 'librun' / OBJ_DIR / 'librun.dll', bin_dir
      else
        error_unsupported_platform
    end
  end

  task :packages => :variables do
    mkdir_p lib_dir / 'lib'
    pkgs = project.packages.clone
    pkgs.push(project.application)
    # Sort here by size of package. This forces nested packaged
    # to be installed after their 'super' package. Fixes
    # libjava#25
    pkgs.sort! {|a, b| a.name.size <=> b.name.size}

    pkgs.each do |pkg|
      rm_rf pkg_dir / pkg.directory if File.exist? pkg_dir / pkg.directory
      mkdir_p pkg_dir / pkg.directory
      #cp_rx BUILD_DIR / pkg.directory / '.' , pkg_dir / pkg.directory do | fname |
      #  /\.svn|CVS|\.cvsignore|objbc|\.H$|\.STH$|\.SC$|\.sc$|\.o/.match(fname) == nil
      #end
      install BUILD_DIR / pkg.directory / '*.st', pkg_dir / pkg.directory
      install BUILD_DIR / pkg.directory / 'abbrev.stc', pkg_dir / pkg.directory if File.exist? BUILD_DIR / pkg.directory / 'abbrev.stc'
      if File.exist? BUILD_DIR / pkg.directory / pkg.dll_name
        install BUILD_DIR / pkg.directory / '*.so', pkg_dir / pkg.directory
      end
      %w(resources bitmaps styles java).each do |subdir|
        if File.exist? BUILD_DIR / pkg.directory / subdir
          cp_rx BUILD_DIR / pkg.directory / subdir, pkg_dir / pkg.directory do |fname|
            # fname is full path!!!
            /\.svn|CVS|\.cvsignore|tests/.match(fname).nil?
          end
        end
      end
      #Put SVN identification...
      if File.exist? BUILD_DIR / pkg.directory / '.svn'
        chdir BUILD_DIR / pkg.directory do
          sh "svn info > \"#{pkg_dir / pkg.directory / '.svn.info'}\""
        end
      end

      if unix?
        (pkg_dir / pkg.directory / '**').each do |file|
          chmod 0644, file if File.file? file
          chmod 0755, file if File.directory? file
        end

        unless pkg.application?
          (pkg_dir / pkg.directory / '*.so').each do |dll_name|
            # make the DLL executable
            chmod 0777, dll_name
            # symlink the dll
            chdir lib_dir / 'lib' do
              rm File.basename(dll_name) if File.exist? File.basename(dll_name)
              ln_s File.join('..', '..', 'packages', pkg.directory, File.basename(dll_name)), File.basename(dll_name)
            end
          end
        end
      end

      if win32?
        if pkg.application?
          install BUILD_DIR / pkg.directory / '*.dll', bin_dir
          install BUILD_DIR / pkg.directory / '*.exe', bin_dir
          install BUILD_DIR / pkg.directory / '*.com', bin_dir
          install BUILD_DIR / pkg.directory / 'symbols.stc', bin_dir
          install BUILD_DIR / pkg.directory / 'modules.stx', bin_dir
          mv bin_dir / 'stx.exe', bin_dir / 'stx-bin.exe'
          mv bin_dir / 'stx.com', bin_dir / 'stx-bin.com'
        else
          rm pkg_dir / pkg.directory / '*.dll'
        end
      end
    end
  end

  task :doc => :variables do
    mkdir_p doc_dir
    puts BUILD_DIR / 'stx' / 'doc'
    cp_rx BUILD_DIR / 'stx' / 'doc', doc_dir do |fname|
      # fname is full path!!!
      /\.svn|CVS|\.cvsignore|books|not_delivered/.match(fname).nil?
    end
  end
end # namespace :'dist:jv'

task :'dist:jv:docs' => %i(dist:jv:docs:pre dist:jv:docs:main dist:jv:docs:post)

namespace :'dist:jv:docs' do
  task :pre
  task :post
  task :main => %i(setup files)

  task :setup => %i(dist:jv:variables)

  task :files => :setup do
    raise Exception.new('Not yet implemented')
  end

end # namespace :'dist:jv:docs'
