package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class FREM {
    public double one = 1.0f;
    
    @Test
    public void test_01() { 
        // Have to do it this way because compiler folds constant
        // arithmetic expressions
        double a = 1.2f * one;
        double b = 3.4f * one;
        assertEquals(a % b, 1.2f, 0.001f);
    }

}
