package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

/** 
 * Tests for INVOKESPECIAL instructions. 
 * 
 * Note: for JIT-compiled code there are two code-paths:
 * (i) method reference is already resolved, then the 
 * method is directly dispatched
 * (ii) method references is not yet resolved and JIT code
 * invokes helper method JavaVM>>_INVOKEVIRTUAL_R: 
 * 
 * To test both code patch, each test has 2 variants ('a' and
 * 'b') where the latter one executes the first one. This ensures
 * that the first method is executed once with reference unresolved
 * and second time with all references resolved.
 *
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 */
@stx.libjava.annotation.Package("stx:libjava/tests")
public class INVOKESPECIALX {
    
    @Test 
    public void test_invoke_int_a() {   
        SpecialInt s;
        int r;
        
        s = new SpecialInt(1); r = s.r;;
        assertEquals(1, r);
        
        s = new SpecialInt(1,1); r = s.r;
        assertEquals(2, r);
        
        s = new SpecialInt(1,1,1); r = s.r;
        assertEquals(3, r);

        s = new SpecialInt(1,1,1,1); r = s.r;
        assertEquals(4, r);
        
        s = new SpecialInt(1,1,1,1,1); r = s.r;
        assertEquals(5, r);
        
        s = new SpecialInt(1,1,1,1,1,1); r = s.r;
        assertEquals(6, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1); r = s.r;
        assertEquals(7, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(8, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(9, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(10, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(11, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(12, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(13, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(14, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(15, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(16, r);
        
        s = new SpecialInt(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(17, r);                
    }

    @Test 
    public void test_invoke_int_b() {
        test_invoke_int_a();
    }
    
    @Test 
    public void test_invoke_double_a() {
        SpecialDouble s;
        double r;
        
        s = new SpecialDouble(1); r = s.r;
        assertEquals(1.0, r, 0.001);
        
        s = new SpecialDouble(1,1); r = s.r;
        assertEquals(2.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1); r = s.r;
        assertEquals(3.0, r, 0.001);

        s = new SpecialDouble(1,1,1,1); r = s.r;
        assertEquals(4.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1); r = s.r;
        assertEquals(5.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1); r = s.r;
        assertEquals(6.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1); r = s.r;
        assertEquals(7.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(8.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(9.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(10.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(11.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(12.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(13.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(14.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(15.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(16.0, r, 0.001);
        
        s = new SpecialDouble(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1); r = s.r;
        assertEquals(17.0, r, 0.001);                
    }

    @Test 
    public void test_invoke_double_b() {
        test_invoke_double_a();
    }
    
    @Test 
    public void test_invoke_Object_a() {
        SpecialObject s;
        Object o1 = new Object();
        Object o2 = new Object();
        Object[] r;
        
        s = new SpecialObject(o1); r = s.r;
        assertTrue(o1 == r[0]);
        
                
        s = new SpecialObject(o1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[1]);
        
        s = new SpecialObject(o1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[2]);
        
        s = new SpecialObject(o1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[3]);
                
        s = new SpecialObject(o1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[4]);
                
        s = new SpecialObject(o1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[5]);
                
        s = new SpecialObject(o1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[6]);
             
        s = new SpecialObject(o1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[7]);
                
        s = new SpecialObject(o1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[8]);
                
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[9]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[10]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[11]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[12]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[13]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[14]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[15]);
        
        s = new SpecialObject(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2); r = s.r;
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[16]);

                        
    }

    @Test 
    public void test_invoke_Object_b() {
        test_invoke_Object_a();
    }
      
    public static class SpecialInt {
        public int r = -1;
        
        public SpecialInt(int i1) {
            r = 1; 
        }
        public SpecialInt(int i1, int i2) {
            r = 1 + i2;
        }
        public SpecialInt(int i1, int i2, int i3) {
            r = 1 + i2 + i3;
        }
        public SpecialInt(int i1, int i2, int i3, int i4) {
            r = 1 + i2 + i3 + i4;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5) {
            r = 1 + i2 + i3 + i4 + i5;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6) {
            r = 1 + i2 + i3 + i4 + i5 + i6;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15;
        } 
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16;
        }
        public SpecialInt(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16, int i17) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17;
        }
    }

        
    public static class SpecialDouble {    
        public double r = -1;

        public SpecialDouble(double i1) {
            r = 1; 
        }
        public SpecialDouble(double i1, double i2) {
            r = 1 + i2;
        }
        public SpecialDouble(double i1, double i2, double i3) {
            r = 1 + i2 + i3;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4) {
            r = 1 + i2 + i3 + i4;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5) {
            r = 1 + i2 + i3 + i4 + i5;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6) {
            r = 1 + i2 + i3 + i4 + i5 + i6;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16;
        }
        public SpecialDouble(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16, double i17) {
            r = 1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17;
        }
        
    }
    
    public static class SpecialObject {
        public Object[] r;
        
        public SpecialObject(Object i1) {
            r = new Object[] { i1 }; 
        }
        public SpecialObject(Object i1, Object i2) {
            r = new Object[] { i1 , i2 };
        }
        public SpecialObject(Object i1, Object i2, Object i3) {
            r = new Object[] { i1 , i2 , i3 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4) {
            r = new Object[] { i1 , i2 , i3 , i4 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 , i16 };
        }
        public SpecialObject(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16, Object i17) {
            r = new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 , i16 , i17 };
        }        
    }
}




