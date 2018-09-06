module Rake
end

module Rake::StX
end

class Object
  def self.new_property_value(*args, &block)
    self == Object ? (return args[0]) : (return self.new(*args, &block))
  end
end

class Proc
  def self.new_property_value(*args, &block)
    # TODO: add check
    args[0]
  end
end


class Fixnum
  def self.new_property_value(*args, &block)
    # TODO: add check
    args[0]
  end
end

class Symbol
  def self.new_property_value(*args, &block)
    # TODO: add check
    args[0].to_sym
  end
end


module Rake::StX::DSL

  # Base class for DSL object that may have properties
  class Object

    # Class-instance variable to hold property definitions
    @property_definitions = {}

    attr_accessor :properties

    def self.property(name, properties = {})
      @property_definitions ||= {}
      if @property_definitions.include? name
        raise Exception.new("Property #{name} already defined for this kind of object")
      else
        prop_def_class = properties[:property_definition_class] || PropertyDefinition
        @property_definitions[name] = prop_def_class.new(name, self, properties)
      end
    end

    def self.property_defined?(name)
      @property_definitions ||= {}
      if @property_definitions.include? name
        return @property_definitions[name]
      else
        self == Rake::StX::DSL::Object ? (return nil) : (return self.superclass.property_defined?(name))
      end
    end

    def self.property_definition(name)
      prop_def = self.property_defined?(name)
      raise Exception.new("Property #{name} not defined in class #{self.class.name}") unless prop_def
      return prop_def
    end

    def _get_property(name)
      @properties ||= {}
      prop = @properties[name]
      prop ? prop.value : self.class.property_definition(name).default
    end

    def _set_property(name, source = '<unknown source>', *args, &block)
      @properties ||= {}
      prop_def = self.class.property_definition(name)
      prop = prop_def.instantiate(name, source, @properties[name], args, &block)
      @properties[name] = prop
    end

    def property_defined?(name)
      return false unless self.class.property_defined? name
      return false if @properties.nil?
      @properties.has_key? name
    end


    def _set_property_value(name, value, source = '<unknown source>')
      @properties ||= {}
      self.class.property_definition(name).validate(value)
      prop = Property.new(name, value, source, @properties[name])
      @properties[name] = prop
    end

    def clone
      c = super()
      c.properties = {}
      @properties.each {|name, prop| c.properties[name] = prop.clone}
      c
    end

    def merge(other)
      _merge_properties(other)
      self
    end

    def _merge_properties(other)
      other.properties.each {|name, prop| @properties[name] = prop.clone unless @properties.key? name}
    end

  end

  # Object


  class PropertyDefinition < Object
    attr_accessor :name, :default

    def initialize(name, owning_class, properties = {})
      @name = name
      @owning_class = owning_class
      @values = properties[:values]
      @klass = @values ? nil : (properties[:class] || String)
      @type = properties[:type] || :scalar
      properties.include? :default ? (@default = properties[:default]) : (@default = nil)
      define_getter
      define_setter
    end

    def default
      @default
    end

    def valid?(value)
      #return true
      @values ? (@values.include? value) : (value.kind_of? @klass)
    end

    def validate(value)
      raise Exception.new("Invalid value (#{value.inspect}) for property :'#{@name}' defined in #{@owning_class.name}") unless valid? value
    end

    def instantiate(name, source, previous, args, &block)
      begin
        if @values
          (!@values.include? args[0]) ? (raise Exception.new("Value #{args[0]} not allowed (not one of: #{@values.join(', ')})")) : (value = args[0])
        else
          value = @klass.new_property_value(*args, &block)
        end
        return Property.new(name, value, source, previous)
      rescue => e
        puts e.backtrace.join("\n")
        raise e.exception("Error when instantiating property :'#{name}' in class #{@owning_class.name}: #{e.message}")
      end
    end

    def define_getter
      name = @name
      @owning_class.send(:define_method, name) do |*args, &block|
        (args.empty? and !block_given?) ? (return self._get_property(name)) : (return self._set_property(name, caller[1], *args, &block))
      end
    end

    def define_setter
      name = @name
      @owning_class.send(:define_method, "#{@name}=") {|value| self._set_property_value(name, value, caller[1])}
    end

  end

  # PropertyDefinition

  class Property
    attr_reader :name, :value, :source, :overridden

    def initialize(name, value, source = '<unknown source>', overridden = nil)
      @name = name
      @value = value
      @source = source || caller(4).first
      @overridden = overridden
    end

    def clone
      case
        when @value.class == Symbol
          value = @value
        when @value.class == NilClass
          value = nil
        when (@value == true || @value == false)
          value = @value
        else
          value = @value.clone
      end
      overriden = @overriden.nil? ? nil : @overridden.clone
      self.class.new(@name, value, @source, overridden)
    end

  end # class Property

  class PropertyException < Exception
  end

  class PropertyNotFoundException < PropertyException
  end

  class InvalidPropertyValueException < PropertyException
  end


end
