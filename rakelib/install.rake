desc 'Install project into INSTALL_DIR'
task :install => %i(compile
                    install:pre
                    install:main
                    install:post)

namespace :install do
  task :pre
  task :post
  task :main
end

desc 'Create build artifacts, e.g., deployable archives & packages'
task :artifacts => %i(install
                      artifacts:pre
                      artifacts:main
                      artifacts:post)


namespace :'artifacts' do
  task :pre
  task :post
  task :main => :setup do
    (zip ARTIFACTS_DIR / BUILD_NAME, remove: true) if File.exist? ARTIFACTS_DIR / BUILD_NAME
  end

  task :'prebuilt-stc' do
    archive = ARTIFACTS_DIR / "#{project.app_name}-#{project.app_version}_#{BUILD_TARGET}_prebuilt-stc.zip"
    mkdir_p ARTIFACTS_DIR
    zip BUILD_DIR / 'stx' / 'stc' , archive: archive, include: STC_BINARY_FILES
  end

  task :'prebuilt-librun' do
    archive = ARTIFACTS_DIR / "#{project.app_name}-#{project.app_version}_#{BUILD_TARGET}_prebuilt-librun.zip"
    mkdir_p ARTIFACTS_DIR
    zip BUILD_DIR / 'stx' / 'librun' , archive: archive, include: LIBRUN_BINARY_FILES
  end  

  desc 'Create source archive'
  task :'source' => :checkout do
    archive = ARTIFACTS_DIR / "#{project.app_name}-#{project.app_version}_sources.tar.gz"
    mkdir_p ARTIFACTS_DIR
    zip ".", archive: archive, exclude: %w(CVS .svn .git .hg *.obj *.o *.dll *.so *.debug *.H *.STH *Init.c *-Test.xml artifacts tmp)
  end
end
