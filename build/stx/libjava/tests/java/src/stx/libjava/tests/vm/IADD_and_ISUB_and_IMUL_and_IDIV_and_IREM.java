package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

public class IADD_and_ISUB_and_IMUL_and_IDIV_and_IREM {
	public static int INT31_MAX_VAL =  1073741823; // SmallInteger maxVal on 32bit arch
	public static int INT31_MIN_VAL = -1073741824; // SmallInteger minVal on 32bit arch
	public static int INT32_MAX_VAL = Integer.MAX_VALUE;
	public static int INT32_MIN_VAL = Integer.MIN_VALUE;
	
	@Test
	public void test_IADD() {
		int i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT31_MAX_VAL;
		i2 = 1;
		r = i1 + i2;
		assertEquals(1073741824, r);
		
		 
		i1 = INT32_MAX_VAL;
		i2 = 1;
		r = i1 + i2;
		assertEquals(INT32_MIN_VAL, r);		
	}
	
	@Test
	public void test_ISUB() {
		int i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT31_MIN_VAL;
		i2 = 1;
		r = i1 - i2;
		assertEquals(-1073741825, r);
		
		 
		i1 = INT32_MIN_VAL;
		i2 = 1;
		r = i1 - i2;
		assertEquals(INT32_MAX_VAL, r);		
	}
	
	@Test
	public void test_IMUL() {
		int i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT31_MAX_VAL;
		i2 = 2;
		r = i1 * i2;
		assertEquals(INT32_MAX_VAL - 1, r);
				 
		i1 = INT32_MIN_VAL;
		i2 = 2;
		r = i1 * i2;
		assertEquals(0, r);		
	}
	
	@Test
	public void test_IDIV() {
		int i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT32_MIN_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT32_MIN_VAL, r);
		
		i1 = INT32_MAX_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT32_MIN_VAL + 1, r);

				 
		i1 = INT32_MIN_VAL;
		i2 = 0;
		try {
			r = i1 / i2;
			assertTrue("Failed to throw ArithmeticException", false);
		} catch (ArithmeticException ai) {
			// OK
		} catch (Exception e) {
			assertTrue("Failed to throw ArithmeticException", false);
		}			
	}
	
	@Test
	public void test_IREM() {
		int i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT32_MIN_VAL;
		i2 = -1 ;
		r = i1 % i2;
		assertEquals(0, r);
		
		i1 = INT32_MAX_VAL;
		i2 = -1 ;
		r = i1 % i2;
		assertEquals(0, r);

				 
		i1 = INT32_MIN_VAL;
		i2 = 0;
		try {
			r = i1 % i2;
			assertTrue("Failed to throw ArithmeticException", false);
		} catch (ArithmeticException ai) {
			// OK
		} catch (Exception e) {
			assertTrue("Failed to throw ArithmeticException", false);
		}			
	}
	
	@Test
	public void test_IREM_regression_01() {
		int i1, i2, r;
		
		i1 = 1808897413;
		i2 = 81;
		r =i1 % i2;
		assertEquals(67, r);
	}

	
	
}
