def _display_tasks(tasks)
  width = tasks.collect {|t| t.name_with_args.length}.max || 10
  max_column = Rake.application.truncate_output? ? Rake.application.terminal_width - 'name'.size - width - 7 : nil
  tasks.each do |t|
    printf "%-#{width}s  # %s\n",
           t.name_with_args, max_column ? Rake.application.truncate(t.comment || '', max_column) : t.comment || ''
  end
end

task :info do
  puts 'Choose one of the following:'
  puts
  _display_tasks(Rake.application.tasks_in_scope(['info']))
end


namespace :info do
  desc 'Dump environment variables and their values'
  task :environment do
    puts 'Environment variables'
    ENV.each {|key, value| puts "  #{key}=\"#{value}\""}
    puts '---------------------'
  end

  desc 'Alias for task into:environment'
  task :env => :environment

  desc 'Dumps variables and their values'
  task :variables do
    puts "BUILD_DIR = #{BUILD_DIR}"
  end

  desc 'Show all available tasks'
  task :tasks do
    puts 'All tasks:'
    puts
    Rake.application.tasks.each {|t| puts t.name}
  end

  namespace :tasks do

    desc 'Print all tasks that depends on given one'
    task :dependents, :task do |t, args|
      task_n = args[:task] || (error 'No task specified')
      task = t.application.lookup(task_n)
      puts "Task #{task_n} not defined. Forgot to call setup task?" unless task
      puts "Tasks that depend on #{task_n}:"
      t.application.tasks.each do |each_nm|
        each = t.application[each_nm]
        puts " #{each_nm}" if each.prerequisites.include? task_n
      end
    end


    desc 'Print internal state of on given task'
    task :inspect, :task do |t, args|
      task_n = args[:task] || (error 'No task specified')
      task = t.application.lookup(task_n)
      if task
        puts task.investigation
        puts 'requisited by:'
        task.application.tasks.each do |each_nm|
          each = task.application[each_nm]
          if each.prerequisites.include? task.name
            puts " #{each_nm}"
          end
        end
        puts
        puts 'actions: '
        task.actions.each do |a|
          puts "  #{a}"
        end
      else
        puts "Task #{task_n} not defined. Forgot to call setup task?"
      end
    end

    desc 'Print all prerequisites of given task topologically sorted'
    task :'prereq-all', :task do |t, args|
      task_n = args[:task] || (error 'No task specified')
      task = t.application.lookup(task_n)
      puts "task '#{task_n}'"
      task.all_prerequisites_sorted.each {|prereq| puts "  => #{prereq} "}
    end


    desc 'Show given task and its prerequisites, all tasks if task not specified.'
    task :prereq, :task do |t, args|
      task = args[:task] || nil

      task ? (tasks = [t.application.lookup(task)]) : (tasks = t.application.tasks)
      puts "task '#{task}'"

      tasks.each do |t2|
        puts t2.name
        t2.prerequisites.each {|prereq| puts "  => #{prereq} "}
      end
    end
  end # namespace :'tasks'
end

namespace :info do

  namespace :project do

    desc 'Print project name'
    task :name => :'setup:project' do
      puts project.app_name
    end

    desc 'Print project version'
    task :version => :'setup:project' do
      puts project.app_version
    end

  end


  desc 'Print current build name'
  task :buildname => :'setup:project' do
    puts BUILD_NAME
  end


  task :tasks => :'setup:tasks'

  desc 'Print info about currently selected project'
  task :project => :'setup:project' do
    Rake::Stx::Configuration::Printer.new.visit(project)
  end

  desc 'Print project packages in topological order'
  task :packages => 'setup:project' do
    puts "project #{project.name} consists of:"
    project.packages_and_application.each do |pkg|
      puts "  #{pkg.name}"
      puts "    req'd prereqs: #{pkg.prereqs(mandatory: true).join(', ')}"
      puts "    ref'd prereqs: #{pkg.prereqs(referenced: true).join(', ')}"
    end
  end

  desc 'List all available projects'
  task :projects => :'setup:projects' do
    puts ''
    puts 'Available projects:'
    names = projects.values.collect {|prj| String(prj.name)}
    names.sort!
    names.each {|nm| puts " - #{nm}"}
    puts
    puts "PROJECT_DIR = \"projects:#{File.join(ENV['HOME'], '.smalltalk', 'rakefiles', 'projects')}:#{PROJECT_DIRS}\""
    puts
  end

end

