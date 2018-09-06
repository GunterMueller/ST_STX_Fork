desc 'Clean build tree (remove all object files)'
task :clean => :'clean:all'

namespace :clean do

  task :all => %i(setup pre main post)
  task :pre
  task :post

  task :main => %i(stc librun packages)

  task :stc do
    chdir BUILD_DIR / 'stx' / 'stc' do
      ; make 'clean';
    end
  end

  task :librun do
    chdir BUILD_DIR / 'stx' / 'librun' do
      ; make 'clean';
    end
  end

  task :packages

end

desc 'Clobber build tree (remove all object files and .dll/executables)'
task :clobber => :'clobber:all'

namespace :clobber do

  task :all => %i(setup pre main post)
  task :pre
  task :post

  task :main => %i(stc librun include packages) do
    rm BUILD_DIR / 'stx-config.make'
    rm BUILD_DIR / 'stx-config.rake'
  end

  task :include do
    rm_rf BUILD_DIR / 'stx' / 'include'
  end

  task :stc do
    chdir BUILD_DIR / 'stx' / 'stc' do
      make 'clobber';
    end
  end

  task :librun do
    chdir BUILD_DIR / 'stx' / 'librun' do
      make 'clobber'
    end
  end

  task :packages

end


# common tasks and helpers
task :'clean-clobber:setup-tasks' do
  project.packages_and_application.each do |pkg|
    pkg_wc = File.join(BUILD_DIR, pkg.directory)

    task :'clean:packages' => :"clean:package:#{pkg.name}"

    task :"clean:package:#{pkg.name}" do
      #if File.exist? pkg_wc
      chdir pkg_wc do
        case
          when unix? && File.exist?('makefile')
            make 'clean'
          when win32? && File.exist?('bmake.bat')
            make 'clean'
          else
            puts %q(Unknown system. Don't know how to clean.)
        end
      end

      #end
    end

    task :'clobber:packages' => :"clobber:package:#{pkg.name}"

    task :"clobber:package:#{pkg.name}" do
      #if File.exist? pkg_wc then
      chdir pkg_wc do
        case
          when unix? && File.exist?('makefile')
            make 'clobber'
          when win32? && File.exist?('bc.mak')
            make 'clobber'
          else
            puts %q(Unknown system. Don't know how to clobber.)
        end
      end
      #end
    end
  end
end

task :'setup:tasks' => 'clean-clobber:setup-tasks'
