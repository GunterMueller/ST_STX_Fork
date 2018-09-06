package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class DREM {
    public double one = 1.0d;

    @Test
    public void test_01() { 
        // Have to do it this way because compiler folds constant
        // arithmetic expressions
        double a = 1.2d * one;
        double b = 3.4d * one;
        assertEquals(a % b, 1.2d, 0.001d);
    }
}
