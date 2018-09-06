package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

import stx.libjava.tests.vm.INVOKEVIRTUALX.Virtual;

/** 
 * Tests for INVOKEVIRTUAL instructions. 
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
public class INVOKEINTERFACEX {
    
    @Test 
    public void test_invoke_int_a() {
        IVirtual v = new Virtual();
        int r;
        
        r = v.virtualInt01(1);
        assertEquals(1, r);
        
        r = v.virtualInt02(1,1);
        assertEquals(2, r);
        
        r = v.virtualInt03(1,1,1);
        assertEquals(3, r);

        r = v.virtualInt04(1,1,1,1);
        assertEquals(4, r);
        
        r = v.virtualInt05(1,1,1,1,1);
        assertEquals(5, r);
        
        r = v.virtualInt06(1,1,1,1,1,1);
        assertEquals(6, r);
        
        r = v.virtualInt07(1,1,1,1,1,1,1);
        assertEquals(7, r);
        
        r = v.virtualInt08(1,1,1,1,1,1,1,1);
        assertEquals(8, r);
        
        r = v.virtualInt09(1,1,1,1,1,1,1,1,1);
        assertEquals(9, r);
        
        r = v.virtualInt10(1,1,1,1,1,1,1,1,1,1);
        assertEquals(10, r);
        
        r = v.virtualInt11(1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(11, r);
        
        r = v.virtualInt12(1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(12, r);
        
        r = v.virtualInt13(1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(13, r);
        
        r = v.virtualInt14(1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(14, r);
        
        r = v.virtualInt15(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(15, r);
        
        r = v.virtualInt16(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(16, r);
        
        r = v.virtualInt17(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(17, r);                
    }

    @Test 
    public void test_invoke_int_b() {
        test_invoke_int_a();
    }
    
    @Test 
    public void test_invoke_double_a() {
        IVirtual v = new Virtual();
        double r;
        
        r = v.virtualDouble01(1);
        assertEquals(1.0, r, 0.001);
        
        r = v.virtualDouble02(1,1);
        assertEquals(2.0, r, 0.001);
        
        r = v.virtualDouble03(1,1,1);
        assertEquals(3.0, r, 0.001);

        r = v.virtualDouble04(1,1,1,1);
        assertEquals(4.0, r, 0.001);
        
        r = v.virtualDouble05(1,1,1,1,1);
        assertEquals(5.0, r, 0.001);
        
        r = v.virtualDouble06(1,1,1,1,1,1);
        assertEquals(6.0, r, 0.001);
        
        r = v.virtualDouble07(1,1,1,1,1,1,1);
        assertEquals(7.0, r, 0.001);
        
        r = v.virtualDouble08(1,1,1,1,1,1,1,1);
        assertEquals(8.0, r, 0.001);
        
        r = v.virtualDouble09(1,1,1,1,1,1,1,1,1);
        assertEquals(9.0, r, 0.001);
        
        r = v.virtualDouble10(1,1,1,1,1,1,1,1,1,1);
        assertEquals(10.0, r, 0.001);
        
        r = v.virtualDouble11(1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(11.0, r, 0.001);
        
        r = v.virtualDouble12(1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(12.0, r, 0.001);
        
        r = v.virtualDouble13(1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(13.0, r, 0.001);
        
        r = v.virtualDouble14(1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(14.0, r, 0.001);
        
        r = v.virtualDouble15(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(15.0, r, 0.001);
        
        r = v.virtualDouble16(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(16.0, r, 0.001);
        
        r = v.virtualDouble17(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
        assertEquals(17.0, r, 0.001);                
    }

    @Test 
    public void test_invoke_double_b() {
        test_invoke_double_a();
    }
    
    @Test 
    public void test_invoke_Object_a() {
        IVirtual v = new Virtual();
        Object o1 = new Object();
        Object o2 = new Object();
        Object[] r;
        
        r = v.virtualObject01(o1);
        assertTrue(o1 == r[0]);
        
                
        r = v.virtualObject02(o1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[1]);
        
        r = v.virtualObject03(o1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[2]);
        
        r = v.virtualObject04(o1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[3]);
                
        r = v.virtualObject05(o1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[4]);
                
        r = v.virtualObject06(o1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[5]);
                
        r = v.virtualObject07(o1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[6]);
             
        r = v.virtualObject08(o1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[7]);
                
        r = v.virtualObject09(o1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[8]);
                
        r = v.virtualObject10(o1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[9]);
        
        r = v.virtualObject11(o1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[10]);
        
        r = v.virtualObject12(o1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[11]);
        
        r = v.virtualObject13(o1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[12]);
        
        r = v.virtualObject14(o1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[13]);
        
        r = v.virtualObject15(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[14]);
        
        r = v.virtualObject16(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[15]);
        
        r = v.virtualObject17(o1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,o2);
        assertTrue(o1 == r[0]);
        assertTrue(o2 == r[16]);

                        
    }

    @Test 
    public void test_invoke_Object_b() {
        test_invoke_Object_a();
    }
        
    // Tests for NULL receives
    
    
    public void invokeVirtualIn01(IVirtual v, int i1) {
        v.virtualInt01(i1);
    }
    
    @Test    
    public void test_int_01a_NULL() {
        try {
            Virtual v = null;
            invokeVirtualIn01(v, 1);
            assertTrue(false);
        } catch (NullPointerException npe) {
            
        }        
    }
    @Test
    public void test_int_01b_NULL() {
        test_int_01a_NULL();
    }
    

    public void invokeVirtualDouble05(IVirtual v, double i1, double i2,double i3,double i4,double i5) {
        v.virtualDouble05(i1, i2, i3, i4, i5);
    }
    @Test    
    public void test_double_05a_NULL() {
        try {
            Virtual v = null;
            invokeVirtualDouble05(v, 1,1,1,1,1);
            assertTrue(false);
        } catch (NullPointerException npe) {
            
        }        
    }
    @Test
    public void test_double_05b_NULL() {
        test_int_01a_NULL();
    }

    
    public void invokeVirtualDouble10(IVirtual v, double i1, double i2,double i3,double i4,double i5, double i6, double i7, double i8, double i9, double i10) {
        v.virtualDouble10(i1, i2, i3, i4, i5, i6, i7, i8, i9, i10);
    }    
    @Test
    public void test_double_10a_NULL() {
        try {
            Virtual v = null; 
            invokeVirtualDouble10(v, 1,1,1,1,1,1,1,1,1,1);
            assertTrue(false);
        } catch (NullPointerException npe) {
            
        }        
    }
    @Test
    public void test_double_10b_NULL() {
        test_double_10a_NULL();
    }
    
    
    public void invokeVirtualObject03(IVirtual v, Object i1, Object i2, Object i3) {
        v.virtualObject03(i1, i2, i3);
    }    
    @Test
    public void test_Object_03a_NULL() {
        try {
            Virtual v = null;  
            invokeVirtualObject03(v, 1,1,1);
            assertTrue(false);
        } catch (NullPointerException npe) {
            
        }        
    }
    @Test
    public void test_Objecte_03b_NULL() {
        test_Object_03a_NULL();
    }
    
    
    public static interface IVirtual {        
        public  int virtual00();
       
        public  int virtualInt01(int i1);
        public  int virtualInt02(int i1, int i2);
            
        
        public  int virtualInt03(int i1, int i2, int i3);
            
        
        public  int virtualInt04(int i1, int i2, int i3, int i4);
            
        
        public  int virtualInt05(int i1, int i2, int i3, int i4, int i5);
            
        
        public  int virtualInt06(int i1, int i2, int i3, int i4, int i5, int i6);
            
        
        public  int virtualInt07(int i1, int i2, int i3, int i4, int i5, int i6, int i7);
            
        
        public  int virtualInt08(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8);
            
        
        public  int virtualInt09(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9);
            
        
        public  int virtualInt10(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10);
            
        
        public  int virtualInt11(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11);
            
        
        public  int virtualInt12(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12);
            
        
        public  int virtualInt13(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13);
            
        
        public  int virtualInt14(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14);
            
        
        public  int virtualInt15(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15);
            
         
        public  int virtualInt16(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16);
            
        
        public  int virtualInt17(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16, int i17);
            
        


        public  double virtualDouble01(int i1);
             
        
        public  double virtualDouble02(double i1, double i2);
            
        
        public  double virtualDouble03(double i1, double i2, double i3);
            
        
        public  double virtualDouble04(double i1, double i2, double i3, double i4);
            
        
        public  double virtualDouble05(double i1, double i2, double i3, double i4, double i5);
            
        
        public  double virtualDouble06(double i1, double i2, double i3, double i4, double i5, double i6);
            
        
        public  double virtualDouble07(double i1, double i2, double i3, double i4, double i5, double i6, double i7);
            
        
        public  double virtualDouble08(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8);
            
        
        public  double virtualDouble09(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9);
            
        
        public  double virtualDouble10(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10);
            
        
        public  double virtualDouble11(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11);
            
        
        public  double virtualDouble12(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12);
            
        
        public  double virtualDouble13(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13);
            
        
        public  double virtualDouble14(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14);
            
        
        public  double virtualDouble15(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15);
            
        
        public  double virtualDouble16(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16);
            
        
        public  double virtualDouble17(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16, double i17);
            
        
        
        public  Object[] virtualObject01(Object i1);
             
        
        public  Object[] virtualObject02(Object i1, Object i2);
            
        
        public  Object[] virtualObject03(Object i1, Object i2, Object i3);
            
        
        public  Object[] virtualObject04(Object i1, Object i2, Object i3, Object i4);
            
        
        public  Object[] virtualObject05(Object i1, Object i2, Object i3, Object i4, Object i5);
            
        
        public  Object[] virtualObject06(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6);
            
        
        public  Object[] virtualObject07(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7);
            
        
        public  Object[] virtualObject08(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8);
            
        
        public  Object[] virtualObject09(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9);
            
        
        public  Object[] virtualObject10(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10);
            
        
        public  Object[] virtualObject11(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11);
            
        
        public  Object[] virtualObject12(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12);
            
        
        public  Object[] virtualObject13(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13);
            
        
        public  Object[] virtualObject14(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14);
            
        
        public  Object[] virtualObject15(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15);
            
        
        public  Object[] virtualObject16(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16);
            
        
        public  Object[] virtualObject17(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16, Object i17);
            
        
        
    }
    
    
    
    public static class Virtual implements IVirtual {
        public static final int initialized = 12345;
        
        public  int virtual00() {
            return 0;
        }
       
        public  int virtualInt01(int i1) {
            return i1; 
        }
        public  int virtualInt02(int i1, int i2) {
            return i1 + i2;
        }
        public  int virtualInt03(int i1, int i2, int i3) {
            return i1 + i2 + i3;
        }
        public  int virtualInt04(int i1, int i2, int i3, int i4) {
            return i1 + i2 + i3 + i4;
        }
        public  int virtualInt05(int i1, int i2, int i3, int i4, int i5) {
            return i1 + i2 + i3 + i4 + i5;
        }
        public  int virtualInt06(int i1, int i2, int i3, int i4, int i5, int i6) {
            return i1 + i2 + i3 + i4 + i5 + i6;
        }
        public  int virtualInt07(int i1, int i2, int i3, int i4, int i5, int i6, int i7) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7;
        }
        public  int virtualInt08(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8;
        }
        public  int virtualInt09(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9;
        }
        public  int virtualInt10(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
        }
        public  int virtualInt11(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11;
        }
        public  int virtualInt12(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12;
        }
        public  int virtualInt13(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13;
        }
        public  int virtualInt14(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14;
        }
        public  int virtualInt15(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15;
        } 
        public  int virtualInt16(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16;
        }
        public  int virtualInt17(int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8, int i9, int i10, int i11, int i12, int i13, int i14, int i15, int i16, int i17) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17;
        }


        public  double virtualDouble01(int i1) {
            return i1; 
        }
        public  double virtualDouble02(double i1, double i2) {
            return i1 + i2;
        }
        public  double virtualDouble03(double i1, double i2, double i3) {
            return i1 + i2 + i3;
        }
        public  double virtualDouble04(double i1, double i2, double i3, double i4) {
            return i1 + i2 + i3 + i4;
        }
        public  double virtualDouble05(double i1, double i2, double i3, double i4, double i5) {
            return i1 + i2 + i3 + i4 + i5;
        }
        public  double virtualDouble06(double i1, double i2, double i3, double i4, double i5, double i6) {
            return i1 + i2 + i3 + i4 + i5 + i6;
        }
        public  double virtualDouble07(double i1, double i2, double i3, double i4, double i5, double i6, double i7) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7;
        }
        public  double virtualDouble08(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8;
        }
        public  double virtualDouble09(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9;
        }
        public  double virtualDouble10(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10;
        }
        public  double virtualDouble11(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11;
        }
        public  double virtualDouble12(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12;
        }
        public  double virtualDouble13(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13;
        }
        public  double virtualDouble14(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14;
        }
        public  double virtualDouble15(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15;
        }
        public  double virtualDouble16(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16;
        }
        public  double virtualDouble17(double i1, double i2, double i3, double i4, double i5, double i6, double i7, double i8, double i9, double i10, double i11, double i12, double i13, double i14, double i15, double i16, double i17) {
            return i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8 + i9 + i10 + i11 + i12 + i13 + i14 + i15 + i16 + i17;
        }
        
        public  Object[] virtualObject01(Object i1) {
            return new Object[] { i1 }; 
        }
        public  Object[] virtualObject02(Object i1, Object i2) {
            return new Object[] { i1 , i2 };
        }
        public  Object[] virtualObject03(Object i1, Object i2, Object i3) {
            return new Object[] { i1 , i2 , i3 };
        }
        public  Object[] virtualObject04(Object i1, Object i2, Object i3, Object i4) {
            return new Object[] { i1 , i2 , i3 , i4 };
        }
        public  Object[] virtualObject05(Object i1, Object i2, Object i3, Object i4, Object i5) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 };
        }
        public  Object[] virtualObject06(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 };
        }
        public  Object[] virtualObject07(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 };
        }
        public  Object[] virtualObject08(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 };
        }
        public  Object[] virtualObject09(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 };
        }
        public  Object[] virtualObject10(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 };
        }
        public  Object[] virtualObject11(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 };
        }
        public  Object[] virtualObject12(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 };
        }
        public  Object[] virtualObject13(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 };
        }
        public  Object[] virtualObject14(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 };
        }
        public  Object[] virtualObject15(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 };
        }
        public  Object[] virtualObject16(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 , i16 };
        }
        public  Object[] virtualObject17(Object i1, Object i2, Object i3, Object i4, Object i5, Object i6, Object i7, Object i8, Object i9, Object i10, Object i11, Object i12, Object i13, Object i14, Object i15, Object i16, Object i17) {
            return new Object[] { i1 , i2 , i3 , i4 , i5 , i6 , i7 , i8 , i9 , i10 , i11 , i12 , i13 , i14 , i15 , i16 , i17 };
        }
        
    }
}




