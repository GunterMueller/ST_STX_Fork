package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class CHECKCAST_and_INSTANCEOF {
    
    public static interface Aable {
        public void foo();
    }
    
    public static class A implements Aable {
        public void foo() {}
    }
    
    public Object test_01_get_array_of_A() {
        return new A[10];
    }

    /*
     * Regression, there used to be a bug in VM that
     * passed element type to the JavaVM>>_CHECKCAST:_: instead
     * of the array type.
     */
    @Test
    public void test_regression_01_c() {
        Aable[] a = (Aable[])test_01_get_array_of_A();
        a[1] = new A();
    }
    
    @Test
    public void test_regression_01_i() {
        assertTrue(test_01_get_array_of_A() instanceof Aable[]);        
    }


}
