package stx.libjava.tests;

import static org.junit.Assert.*;

import org.junit.Test;

import groovy.lang.Binding;
import stx.libjava.groovy.GroovyShell;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class GroovyShellTests {

    @Test
    public void test_imports_01() {
        GroovyShell shell = new GroovyShell();
        shell.evaluate("import stx.libjava.tests.mocks.b.*;");
        shell.evaluate("new B()");        
    }
    
    @Test
    public void test_regression_01() {
        GroovyShell shell = new GroovyShell();
        assertEquals(shell.evaluate("System.getProperty(\"java.classpath\")"),
                    System.getProperty("java.classpath"));
    }
    
    @Test
    public void test_this_01() {
    	Binding binding = new Binding();
    	binding.setVariable("self", this);    	
        GroovyShell shell = new GroovyShell(binding);
        assertEquals(shell.evaluate("def getThis() { return this; }; getThis();"), this);
    }

}
