package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

/** 
 * Tests for INVOKESTATIC instructions. 
 * 
 * Note: for JIT-compiled code there are two code-paths:
 * (i) method reference is already resolved, then the 
 * method is directly dispatched
 * (ii) method references is not yet resolved and JIT code
 * invokes helper method JavaVM>>_INVOKESTATIC_R: 
 * 
 * To test both code patch, each test has 2 variants ('a' and
 * 'b') where the latter one executes the first one. This ensures
 * that the first method is executed once with reference unresolved
 * and second time with all references resolved. 
 * 
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 */
@stx.libjava.annotation.Package("stx:libjava/tests")
public class INVOKESTATICX {        

    @Test 
    public void test_invoke_int_a() {
        int r;
        
        r = Statics.staticInt01(1);
        assertEquals(1, r);
        
        r = Statics.staticInt02(1,1);
        assertEquals(2, r);
        
        r = Statics.staticInt03(1,1,1);
        assertEquals(3, r);

        r = Statics.staticInt04(1,1,1,1);
        assertEquals(4, r);
        
        r = Statics.staticInt05(1,1,1,1,1);
        assertEquals(5, r);
        
        r = Statics.staticInt06(1,1,1,1,1,1);
        assertEquals(6, r);
        
        r = Statics.staticInt07(1,1,1,1,1,1,1);
        assertEquals(7, r);
        
        r = Statics.staticInt08(1,1,1,1,1,1,1,1);
        assertEquals(8, r);
        
        r = Statics.staticInt09(1,1,1,1,1,1,1,1,1);
        assertEquals(9, r);
        
        r = Statics.staticInt10(1,1,1,1,1,1,1,1,1,1);
        assertEquals(10, r);
        
        r = Statics.staticInt11(1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(11, r);
        
        r = Statics.staticInt12(1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(12, r);
        
        r = Statics.staticInt13(1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(13, r);
        
        r = Statics.staticInt14(1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(14, r);
        
        r = Statics.staticInt15(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(15, r);
        
        r = Statics.staticInt16(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(16, r);
        
        r = Statics.staticInt17(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(17, r);                
    }

    @Test 
    public void test_invoke_int_b() {
        test_invoke_int_a();
    }
    
    @Test 
    public void test_invoke_double_a() {
        double r;
        
        r = Statics.staticDouble01(1);
        assertEquals(1.0, r, 0.001);
        
        r = Statics.staticDouble02(1,1);
        assertEquals(2.0, r, 0.001);
        
        r = Statics.staticDouble03(1,1,1);
        assertEquals(3.0, r, 0.001);

        r = Statics.staticDouble04(1,1,1,1);
        assertEquals(4.0, r, 0.001);
        
        r = Statics.staticDouble05(1,1,1,1,1);
        assertEquals(5.0, r, 0.001);
        
        r = Statics.staticDouble06(1,1,1,1,1,1);
        assertEquals(6.0, r, 0.001);
        
        r = Statics.staticDouble07(1,1,1,1,1,1,1);
        assertEquals(7.0, r, 0.001);
        
        r = Statics.staticDouble08(1,1,1,1,1,1,1,1);
        assertEquals(8.0, r, 0.001);
        
        r = Statics.staticDouble09(1,1,1,1,1,1,1,1,1);
        assertEquals(9.0, r, 0.001);
        
        r = Statics.staticDouble10(1,1,1,1,1,1,1,1,1,1);
        assertEquals(10.0, r, 0.001);
        
        r = Statics.staticDouble11(1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(11.0, r, 0.001);
        
        r = Statics.staticDouble12(1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(12.0, r, 0.001);
        
        r = Statics.staticDouble13(1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(13.0, r, 0.001);
        
        r = Statics.staticDouble14(1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(14.0, r, 0.001);
        
        r = Statics.staticDouble15(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(15.0, r, 0.001);
        
        r = Statics.staticDouble16(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(16.0, r, 0.001);
        
        r = Statics.staticDouble17(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(17.0, r, 0.001);                
    }

    @Test 
    public void test_invoke_double_b() {
        test_invoke_double_a();
    }
    
    @Test 
    public void test_invoke_Object_a() {
        Object o1 = new Object();
        Object o2 = new Object();
        Object[] r;
        
        r = Statics.staticObject01(o1);
        assertTrue(o1 == r[0]);
        
                
        r = Statics.staticObject02(o1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[1]);
        
        r = Statics.staticObject03(o1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[2]);
        
        r = Statics.staticObject04(o1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[3]);
                
        r = Statics.staticObject05(o1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[4]);
                
        r = Statics.staticObject06(o1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[5]);
                
        r = Statics.staticObject07(o1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[6]);
             
        r = Statics.staticObject08(o1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[7]);
                
        r = Statics.staticObject09(o1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[8]);
                
        r = Statics.staticObject10(o1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[9]);
        
        r = Statics.staticObject11(o1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[10]);
        
        r = Statics.staticObject12(o1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[11]);
        
        r = Statics.staticObject13(o1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[12]);
        
        r = Statics.staticObject14(o1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[13]);
        
        r = Statics.staticObject15(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[14]);
        
        r = Statics.staticObject16(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[15]);
        
        r = Statics.staticObject17(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[16]);

                        
    }

    @Test 
    public void test_invoke_Object_b() {
        test_invoke_Object_a();
    }
    

    public static class Statics {
        public static final int initialized = 12345;
        
        public static int static00() {
            return 0;
        }
       
        public static int staticInt01(int i1) {
            return i1; 
        }
        public static int staticInt02(int i1, int i2) {
            return i1 + i2;
        }
        public static int staticInt03(int i1, int i2, int i3) {
            return i1 + i2 + i3;
        }
        public static int staticInt04(int i1, int i2, int i3, int i4) {
            return i1 + i2 + i3 + i4;
        }
        public static int staticInt05(int i1, int i2, int i3, int i4, int i5) {
            return i1 + i2 + i3 + i4 + i5;
        }
        public static int staticInt06(int i1, int i2, int i3, int i4, int i5, int i6) {
            return i1 + i2 + i3 + i4 + i5 + i6;
        }
        public static int staticInt07(int i1, int i2, int i3, int i4, int i5, int i6, int i7) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7;
        }
        public static int staticInt08(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8;
        }
        public static int staticInt09(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9;
        }
        public static int staticInt10(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
        }
        public static int staticInt11(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11;
        }
        public static int staticInt12(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12;
        }
        public static int staticInt13(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13;
        }
        public static int staticInt14(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14;
        }
        public static int staticInt15(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15;
        }
        public static int staticInt16(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16;
        }
        public static int staticInt17(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16, int i17) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17;
        }


        public static double staticDouble01(int i1) {
            return i1; 
        }
        public static double staticDouble02(double i1, double i2) {
            return i1 + i2;
        }
        public static double staticDouble03(double i1, double i2, double i3) {
            return i1 + i2 + i3;
        }
        public static double staticDouble04(double i1, double i2, double i3, double i4) {
            return i1 + i2 + i3 + i4;
        }
        public static double staticDouble05(double i1, double i2, double i3, double i4, double i5) {
            return i1 + i2 + i3 + i4 + i5;
        }
        public static double staticDouble06(double i1, double i2, double i3, double i4, double i5, double i6) {
            return i1 + i2 + i3 + i4 + i5 + i6;
        }
        public static double staticDouble07(double i1, double i2, double i3, double i4, double i5, double i6, double i7) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7;
        }
        public static double staticDouble08(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8;
        }
        public static double staticDouble09(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9;
        }
        public static double staticDouble10(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
        }
        public static double staticDouble11(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11;
        }
        public static double staticDouble12(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12;
        }
        public static double staticDouble13(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13;
        }
        public static double staticDouble14(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14;
        }
        public static double staticDouble15(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15;
        }
        public static double staticDouble16(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16;
        }
        public static double staticDouble17(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16, double i17) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17;
        }
        
        public static Object[] staticObject01(Object o1) {
            return new Object[] { o1 }; 
        }
        public static Object[] staticObject02(Object i1, Object i2) {
            return new Object[] { i1 , i2 };
        }
        public static Object[] staticObject03(Object i1, Object i2, Object i3) {
            return new Object[] { i1 , i2 , i3 };
        }
        public static Object[] staticObject04(Object i1, Object i2, Object i3, Object i4) {
            return new Object[] { i1 , i2 , i3 , i4 };
        }
        public static Object[] staticObject05(Object i1, Object i2, Object i3, Object i4, Object i5) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 };
        }
        public static Object[] staticObject06(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 };
        }
        public static Object[] staticObject07(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 };
        }
        public static Object[] staticObject08(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 };
        }
        public static Object[] staticObject09(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 };
        }
        public static Object[] staticObject10(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 };
        }
        public static Object[] staticObject11(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 };
        }
        public static Object[] staticObject12(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 };
        }
        public static Object[] staticObject13(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 };
        }
        public static Object[] staticObject14(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 };
        }
        public static Object[] staticObject15(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 };
        }
        public static Object[] staticObject16(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 , i16 };
        }
        public static Object[] staticObject17(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16, Object i17) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 , i16 , i17 };
        }
        
    }
}




