desc 'Checkout project code from repositories'
task :checkout => :'checkout:all'

namespace :checkout do

  task :all => %i(setup pre main post)
  task :pre
  task :post

  task :main => %i(buildtools packages)

  task :packages

end

desc 'Update the code'
task :update => %i(checkout update:all)

namespace :update do

  task :all => %i(setup pre main post)
  task :pre
  task :post

  task :main => %i(buildtools packages)

  task :buildtools => BUILD_DIR
  task :packages => BUILD_DIR

  directory BUILD_DIR

end


# common tasks and helpers
task :'checkout-update:setup-tasks' do

  def _checkout_or_update(proc, pkg)
    case proc.arity
      when 0
        proc.call
      when 1
        proc.call(pkg)
      when 2
        proc.call(pkg, BUILD_DIR)
      else
        error "Invalid check outer arity (#{proc}, arity #{proc.arity}"
    end
  end

  project.packages_and_application.each do |pkg|
    doit = true
    if pkg.nested_package?
      # do not checkout nor update nested packages
      doit = false
      # unless they are not in the same repo as parent package
      doit = true if pkg.property_defined?(:checkout)
    end

    if doit
      pkg_wc = File.join(BUILD_DIR, pkg.directory)
      # define checkout task
      # TODO
      task :'checkout:packages' => :"checkout:package:#{pkg.name}"

      if pkg.nested_package?
        task :"checkout:package:#{pkg.name}" => :"checkout:package:#{pkg.parent_package.name}"
      end

      task :"checkout:package:#{pkg.name}" => pkg_wc
      file pkg_wc do
        ; _checkout_or_update(pkg.checkout, pkg);
      end


      # define update task
      task :'update:packages' => :"update:package:#{pkg.name}"
      task :"update:package:#{pkg.name}" do
        File.exist?(pkg_wc) ? _checkout_or_update(pkg.update, pkg) : _checkout_or_update(pkg.checkout, pkg)
      end
    end
  end
end

task :'setup:tasks' => 'checkout-update:setup-tasks'
