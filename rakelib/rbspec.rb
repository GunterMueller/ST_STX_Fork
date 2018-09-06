require 'rake'
require 'tsort'
require "#{File.dirname(__FILE__)}/dsl"

module Rake
end

module Rake::DSL
end

module Rake::Stx
end

module Rake::Stx::Configuration

  def self.read_specs_from_dir(dir)
    if File.exist? dir
      info "Reading project specs from #{dir}..."
      d = Dir.new(dir)
      d.each do |file|
        if file[0] != ?. and file =~ /.*\.rbspec$/
          begin
            info "  #{file}"
            $:.push(dir)
            load dir / file
          ensure
            $:.pop
          end
        end
      end

      d.each do |file|
        if File.directory? File.join(dir, file)
          read_specs_from_dir(File.join(dir, file)) if file[0] != ?.
        end
      end
    end
  end

  def self.read_specs(project_dirs_spec)

    project_dirs = ['specs',
                    ENV['HOME'] / '.smalltalk' / 'builder'
    ]


    if win32?
      project_dirs += project_dirs_spec.split(';')
    else
      project_dirs += project_dirs_spec.split(':')
    end
    project_dirs.each do |dir|
      read_specs_from_dir(dir)
    end
  end


  class ConfigurationException < Exception
  end

  class ConfigurationObject < Rake::StX::DSL::Object

    NO_VALUE = Object.new
    attr_accessor :parent
    attr_reader :last_repository_name


    def initialize(name = nil, parent = nil)
      @name = name
      @parent = parent
      @properties = {}
    end

    def name(name = NO_VALUE)
      @name = name unless name == NO_VALUE
      @name
    end


    def group(*properties, &builder)
      g = Group.new('<group>', self)
      g._build(properties, &builder)
      g
    end

    def _build(properties, &builder)
      if properties and properties.size > 0
        properties.last.each {|name, value| self._set_property(name, caller(4).first, value)}
      end
      unless builder.nil?
        case builder.arity
          when -1
            self.instance_exec &builder
          when 0
            self.instance_exec &builder
          when 1
            self.instance_exec(self, &builder)
          else
            raise ConfigurationException.new("invalid arity of builder block (0 or 1 arguments expected, #{builder.arity} given")
        end
      end
    end


    def accept_visitor(visitor)
      raise Exception.new("Subclass responsibility (#{self.class.name}#accept_visitor")
    end

  end # class ConfigurationObject

  class Project < ConfigurationObject

    include Rake::DSL

    PROJECTS = {}

    attr_accessor :repositories, :packages, :tasks, :application
    attr_accessor :last_repository_name

    def self.named?(name)
      PROJECTS.include?(name) ? PROJECTS[name] : nil
    end

    def self.named(name)
      if PROJECTS.include?(name)
        p = PROJECTS[name]
      else
        p = self.new(name)
        PROJECTS[name] = p
      end
      p
    end

    def self.current
      defined? @@Current ? @@Current : (@@Current = nil)
      @@Current
    end

    def self.current=(project)
      @@Current = project
    end

    property :app_name
    property :app_version

    def initialize(name)
      super(name)
      @imports = []
      @packages = []
      @application = nil
      @tasks = []
      @last_repository_name = nil
    end

    def clone
      p = super
      p.repositories = @repositories.clone
      p.packages = @packages.clone
      p
    end

    def packages_and_application
      app = self.application
      app ? self.packages + [app] : self.packages
    end

    class Import
      def initialize(importee, imported)
        @importee = importee
        @imported = imported #as symbol!
        @last_repository_name = importee.last_repository_name
      end

      def apply
        p = @importee.class.named(@imported)
        p.apply_imports
        @importee.merge(p)

        #merge packages
        begin
          importee_last_repository_name = @importee.last_repository_name
          @importee.last_repository_name = @last_repository_name
          p.packages.each do |pkg|
            @importee.package?(pkg.name)? @importee.package(pkg.name).merge(pkg) : @importee.packages.push(pkg.clone)
            pkg = @importee.package(pkg.name)
            pkg.set_property(:repository, @last_repository_name) if !pkg.repository and @last_repository_name
          end
          app = p.application
          if app
            if @importee.application
              (@importee.application.parent == @importee) ? @importee.application.merge(app) : (@importee.application = app.merge(@importee.application))
            else
              @importee.application = app
            end
          end
        ensure
          @importee.last_repository_name = importee_last_repository_name
        end

        p_tasks = p.tasks.collect {|t| t.clone}
        @importee.tasks = p_tasks + @importee.tasks
        info "Importing #{@imported}"
        info "     into #{@importee.name}"
      end

    end # class Import

    def import(name)
      @imports.push(Import.new(self, name))
    end

    def apply_imports
      @imports.each {|import| import.apply}
    end

    def repository(name)
      raise Exception.new('Defining repository within package is no longer supported') if block_given?
      @last_repository_name = name
    end

    def package?(name)
      i = @packages.index {|r| r.name == name}
      i ? @packages[i] : nil
    end

    def package(name, *properties, &builder)
      unless (p = package?(name))
        p = Package.new(name, self)
        @packages.push(p)
      end
      p._build(properties, &builder)
      p.repository = @last_repository_name if !p.repository and @last_repository_name
      p
    end

    def application(name = NO_VALUE, *properties, &builder)
      return @application if name == NO_VALUE
      warn "Redefining application for project #{self.name}!" if @application
      unless (p = package?(name))
        p = Application.new(name, self)
        @application = p
      end
      p._build(properties, &builder)
      p.repository = @last_repository_name if !p.repository and @last_repository_name
      p
    end

    def tasks(*properties, &builder)
      if properties.empty? and !builder
        @tasks
      else
        t = Tasks.new
        t._build(properties, &builder)
        @tasks.push(t)
        t
      end
    end

    def accept_visitor(visitor)
      visitor.visit_project(self)
    end

  end # class Configuration

  class Tasks < ConfigurationObject
    include Rake::TaskManager

    def _build(*properties, &builder)
      super(properties) {}
      @builder = builder
    end

    def define!
      unless @builder.nil?
        case @builder.arity
          when -1
            @builder.call
          when 0
            @builder.call
          when 1
            @builder.call(self)
          else
            raise ConfigurationException.new("invalid arity of builder block (0 or 1 arguments expected, #{builder.arity} given")
        end
      end
    end

    def accept_visitor(visitor)
      visitor.visit_tasks(self)
    end

  end # class Tasks


  class Package < ConfigurationObject


    property :repository, :class => Symbol
    property :branch, :class => String
    property :revision, :class => String
    property :link, :values => [true, false], :default => true
    property :test, :values => [true, false], :default => false
    property :coverage, :values => [true, false], :default => false
    property :lint, :values => [true, false], :default => false

    property :checkout, :default => (Proc.new do |pkg|
      info "Checking out #{pkg.name}..."
      checkout pkg.repository, pkg.directory,
               :branch => pkg.branch, :revision => pkg.revision, :package => pkg, :separator => pkg._separator
    end), :class => Proc

    property :update, :default => (Proc.new do |pkg|
      info "Updating #{pkg.name}..."
      update pkg.repository, pkg.directory,
             :branch => pkg.branch, :revision => pkg.revision, :package => pkg, :separator => pkg._separator
    end), :class => Proc

    property :stc_flags, :default => '+optinline +optinline2 -optContext', :class => String

    def _separator
      (Repository::find(self.repository)).separator
    end

    def name_components
      @name_components = self.name.sub(':', '/').split('/') unless @name_components
      @name_components
    end

    def top
      # Answers relative path to top directory
      File.join(self.name_components.collect {'..'})
    end

    def directory
      File.join(*self.name_components)
    end

    def project_definition_file_name
      "#{self.directory.gsub(File::SEPARATOR, '_')}.st"
    end

    def dll_name_without_suffix
      # Sigh, a special hack for stx:librun which is NOT
      # libstx_librun.so/fll but just librun.so / librun.dll      
      # and for STC which  produces no .so / .dll
      case self.name
        when 'stx:stc'
          nil
        when 'stx:librun'
          'librun'
        else
          "lib#{self.directory.gsub(File::SEPARATOR, '_')}"
      end
    end

    def dll_name
      case
        when self.name == 'stx:stc'
          nil
        when win32?
          "#{dll_name_without_suffix}.dll"
        when unix?
          "#{dll_name_without_suffix}.so"
        else
          error_unsupported_platform
      end
    end

    def nested_package?
      project.packages.each do |each|
        return true if self.name != each.name and self.name.start_with? each.name + '/'
      end
      false
    end

    def test_package?
      ((self.name.end_with? 'tests') or (self.name.end_with? 'test'))
    end

    def parent_package
      return nil unless nested_package?
      last_slash = self.name.rindex(?/)
      return nil if last_slash.nil?
      parent_package_name = self.name.slice(0, last_slash)
      project.packages.each do |each|
        return each if each.name == parent_package_name
      end
      nil
    end

    def application?
      false
    end

    def accept_visitor(visitor)
      visitor.visit_package(self)
    end


    def prereqs(mandatory: false, referenced: false, root: nil)
      raise Exception.new(%q{Nor mandatory nor referenced prereqs asked. Must specify either `mandatory: true` or `referenced: true` or both}) unless (mandatory or referenced)

      # Special hack for stx:stc and stx:librun which are actually 
      # not a smalltalk packages. 
      return [] if @name == 'stx:stc'
      # stx:librun depends on STC
      return ['stx:stc'] if @name == 'stx:librun'

      root = BUILD_DIR if (not root && defined? BUILD_DIR)
      raise Exception.new('BUILD_DIR not defined and no package root passed to Package::prereqs()') unless root

      source_file = root / directory / project_definition_file_name
      unless File.exist? source_file
        warn "Cannot fine project definition file for #{@name}. Container for nested packages?"
        return ['stx:libbasic']
      end

      source = ''
      File.open(source_file, 'r').each {|line| source << line}

      source.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      # All packaged depends on STC - one cannot compile them without it!
      prereqs = ['stx:stc']
      prereqs += source.scan(/^mandatoryPreRequisites(.*?)!$/m).flatten.to_s.scan(/#'([^']+)'/).flatten if mandatory
      prereqs += source.scan(/^referencedPreRequisites(.*?)!$/m).flatten.to_s.scan(/#'([^']+)'/).flatten if referenced
      prereqs.uniq
    end
  end # class Package

  class Application < Package

    def executable
      c = self.name_components
      nm = c.last
      if win32?
        #JV@2011-07-22: HACK for Windows, since smalltalk.bat messes the argument list!!!
        return 'stx' if self.name == 'stx:projects/smalltalk'
      end
      nm == 'application' ? c[c.size - 2] : nm
    end

    def application?
      true
    end

    def accept_visitor(visitor)
      visitor.visit_application(self)
    end


  end # class Application


  class Group < ConfigurationObject

    def initialize(name, parent)
      super(name, parent)
      @properties_to_apply = Properties.new('<properties>', self)
      @nested_entities = []
    end

    def properties(*properties, &builder)
      @properties_to_apply._build(properties, &builder)
    end

    def _build(*properties, &builder)
      @properties_to_apply._build(properties)
      super([], &builder)
      @nested_entities.each do |each|
        @properties_to_apply.properties.each {|name, value| each.set_property(name, value, caller(2).first)}
      end
    end

    def method_missing(selector, *args, &block)
      e = parent.send(selector, *args, &block)
      @nested_entities.push(e)
      e
    end

    class Properties < ConfigurationObject
    end # class Group::Properties

  end # class Group

  class Repository < ConfigurationObject
    property :type, :class => Symbol

    # defines a canonical repossitory - this means, the one and only
    # repository that contains "official" code.
    property :canonical, :class => String

    # defines a so called upstream repository - this means the repository
    # where the code from staging repository goes once verified. If no
    # upstream repository is defined, canonical repository is taken
    # instead
    property :upstream, :class => String

    # defines staging repository
    property :staging, :class => String

    property :separator, :default => '.'


    # Keeps reference to all defined repositories
    @@DEFINED = {}

    def self.find(name)
      return @@DEFINED[name] || nil
    end

    def initialize(name, parent)
      super(name, parent)
      if Repository::find(name)
        raise Exception.new("Trying to redefine repository #{name}")
      end
      @@DEFINED[name] = self
    end

    def accept_visitor(visitor)
      visitor.visit_repository(self)
    end

  end # class Repository

  class Visitor

    def visit(object)
      object.accept_visitor(self)
    end

    def visit_project(project)
      project.repositories.each {|repo| self.visit(repo)}
      project.packages.each {|repo| self.visit(repo)}
      project.tasks.each {|repo| self.visit(repo)}
      self.visit(project.application) if project.application
    end

    def visit_tasks(tasks)

    end

    def visit_repository(tasks)

    end

    def visit_package(tasks)

    end

    def visit_application(app)
      self.visit_package(app)
    end


  end

  class Printer < Visitor

    attr_accessor :stream

    def print_property(prop, overridden = false)
      if overridden
        puts "#   overrides #{prop.value}"
        puts "#  defined at #{prop.source}"
      else
        puts "#{prop.name} #{prop.value}"
        puts "# (defined at #{prop.source})"
      end
      print_property(prop.overridden, true) if prop.overridden
    end

    def print_properties(obj)
      obj.properties.each do |name, prop|
        print_property(prop)
      end
    end

    def initialize
      @indent = 0
      @stream = $stdout
    end

    def puts(*args)
      args.each do |arg|
        @indent.times {@stream.write('  ')}
        @stream.puts(arg)
      end
    end

    def indent(increment = 1)
      @indent += increment
      yield
      @indent -= increment
    end

    def visit_repository(repo)
      puts "repository :'#{repo.name}' do"
      indent do; print_properties(repo); end
      puts 'end'
    end

    def visit_package(pkg)
      puts "#{pkg.application? ? 'application' : 'package'} \"#{pkg.name}\" do"
      if pkg.nested_package?
        puts %q{  # nested package}
        package = pkg.parent_package
        package.nil? ? (puts %q{  # OOPS, parent package not found!}) : (puts %Q{  # parent package: #{p.name}})
      end
      indent do; print_properties(pkg); end
      puts 'end'
    end

    def visit_project(project)
      puts "project :'#{project.name}' do"
      indent do
        print_properties(project)
        super(project)
      end
      puts 'end'
    end

  end


end # module Rake::StX::Configuration

# Defines a new repository
def repository(name, *properties, &builder)
  r = Rake::Stx::Configuration::Repository.new(name, nil)
  r._build(properties, &builder)
  r
end

def projects
  Rake::Stx::Configuration::Project::PROJECTS
end

def project(name = Rake::Stx::Configuration::ConfigurationObject::NO_VALUE, *properties, &builder)
  if name == Rake::Stx::Configuration::ConfigurationObject::NO_VALUE
    Rake::Stx::Configuration::Project.current
  else
    p = Rake::Stx::Configuration::Project.named(name)
    p._build(properties, &builder)
    p
  end
end

def project!(name)
  if (p = Rake::Stx::Configuration::Project.named?(name))
    Rake::Stx::Configuration::Project.current = p
    p
  else
    raise Rake::Stx::Configuration::ConfigurationException.new("No such project (#{name})")
  end
end
