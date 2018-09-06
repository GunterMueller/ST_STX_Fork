$:.push('.')
require 'rakelib/support.rb'

import 'rakelib/info.rake'
import 'rakelib/setup.rake'
import 'rakelib/checkout.rake'
import 'rakelib/compile.rake'
import 'rakelib/test.rake'
import 'rakelib/install.rake'
import 'rakelib/dist-jv.rake'
import 'rakelib/clean.rake'
import 'rakelib/workflow.rake'

# Automatically perform task :'setup' to create and define
# tasks based on current spec. This allows user to invoke
# generated tasks manually without having to manually run
# task `setup`
Rake.application.load_imports()
Rake::Task[:'setup'].invoke()


desc "Fetch sources and compiles project (default task)"
task :'default' => [ :'setup', :'checkout', :'compile' ]

task :'pre'

task :'post'                  

task :'jenkins:job' => [ :'setup', :'checkout', :'update', :'compile', :'test', :'lint', :'artifacts' ]

desc "Run interactive Ruby shell with project loaded and all tasks defined"
task :'shell' => [:'setup' ] do 
  begin
    require 'pry'
    begin
      require 'pry-byebug'
    rescue LoadError
      warn("`pry-byebug` not installed, run `gem install pry-byebug` to install it")
    end
    binding.pry
  rescue LoadError 
    error("`pry` not installed, run `gem install pry` to install it")
  end
end
