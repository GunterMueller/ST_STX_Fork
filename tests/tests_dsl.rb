require File.join(File.dirname(__FILE__), '..' , 'rakelib' , 'dsl')
require 'test/unit'

module Rake::StX::DSL
  class ObjectTests < Test::Unit::TestCase

    class A < Object
      property :bar
      property :baz, :default => false, :values => [true, false]
      property :qux, :default => (Proc.new do 
                                   :qux
                                 end)      
    end
    
    def test_01           
      f = A.new()
      assert f.bar == nil
      f.bar "baz"
      assert f.bar == "baz"
      f.bar = "qux"
      assert f.bar == "qux"
    end

    def test_02
      f = A.new()     
      assert f.baz == false
      f.baz true
      assert f.baz == true
      gote = false
      begin
        f.baz "String"
      rescue Exception 
        gote = true
      end
      assert gote
      
    end
    
    def test_03
      f = A.new()
      assert f.qux.kind_of?  Proc        
      assert f.qux.call() == :qux      
    end
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(Rake::StX::DSL::ObjectTests)
end