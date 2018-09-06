package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

public class LADD_and_LSUB_and_LMUL_and_LDIV_and_LREM {
	public static long INT31_MAX_VAL =  1073741823; // SmallInteger maxVal on 32bit arch
	public static long INT31_MIN_VAL = -1073741824; // SmallInteger minVal on 32bit arch
	public static long INT32_MAX_VAL = Integer.MAX_VALUE;
	public static long INT32_MIN_VAL = Integer.MIN_VALUE;

	public static long INT63_MAX_VAL =  4611686018427387903L; // SmallInteger maxVal on 32bit arch
	public static long INT63_MIN_VAL = -4611686018427387904L; // SmallInteger minVal on 32bit arch
	public static long INT64_MAX_VAL = Long.MAX_VALUE;
	public static long INT64_MIN_VAL = Long.MIN_VALUE;

	
	@Test
	public void test_LADD() {
		long i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT31_MAX_VAL;
		i2 = 1;
		r = i1 + i2;
		assertEquals(1073741824, r);
		
		 
		i1 = INT32_MAX_VAL;
		i2 = 1;
		r = i1 + i2;
		assertEquals(2147483648L, r);
		
		i1 = INT63_MAX_VAL;
		i2 = 1;
		r = i1 + i2;
		assertEquals(4611686018427387904L, r);
		
		 
		i1 = INT64_MAX_VAL;
		i2 = 1;
		r = i1 + i2;
		assertEquals(INT64_MIN_VAL, r);
		
	}
	
	@Test
	public void test_LSUB() {
		long i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT31_MIN_VAL;
		i2 = 1;
		r = i1 - i2;
		assertEquals(-1073741825, r);
		
		 
		i1 = INT32_MIN_VAL;
		i2 = 1;
		r = i1 - i2;
		assertEquals(-2147483649L, r);
		 
		i1 = INT63_MIN_VAL;
		i2 = 1;
		r = i1 - i2;
		assertEquals(-4611686018427387905L, r);
		
		 
		i1 = INT64_MIN_VAL;
		i2 = 1;
		r = i1 - i2;
		assertEquals(INT64_MAX_VAL, r);		

	}
	
	@Test
	public void test_LMUL() {
		long i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT31_MAX_VAL;
		i2 = 2;
		r = i1 * i2;
		assertEquals(INT32_MAX_VAL - 1, r);
				 
		i1 = INT32_MIN_VAL;
		i2 = 2;
		r = i1 * i2;
		assertEquals(-4294967296L, r);
		
		i1 = INT63_MAX_VAL;
		i2 = 2;
		r = i1 * i2;
		assertEquals(INT64_MAX_VAL - 1, r);
				 
		i1 = INT64_MIN_VAL;
		i2 = 2;
		r = i1 * i2;
		assertEquals(0, r);		
	}
	
	@Test
	public void test_regression_01() {
		long a = 1517774901;
		long b = 234233353;
		
		long p = a * b;
				
		assertEquals(355513504160473053L, p);
		

	}
	
	@Test
	public void test_LDIV() {
		long i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT32_MIN_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(2147483648L, r);
		
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
		
		i1 = INT64_MIN_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT64_MIN_VAL, r);
		
		i1 = INT64_MAX_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT64_MIN_VAL + 1, r);

				 
		i1 = INT64_MIN_VAL;
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
	public void test_LREM() {
		long i1, i2, r;
				
		// Use variables to trick the compiler (and inhibit constant folding) 
		i1 = INT32_MIN_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT32_MAX_VAL+1, r);
		
		i1 = INT32_MAX_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT32_MIN_VAL+1, r);

				 
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
		
		i1 = INT64_MIN_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT64_MIN_VAL, r);
		
		i1 = INT64_MAX_VAL;
		i2 = -1 ;
		r = i1 / i2;
		assertEquals(INT64_MIN_VAL + 1, r);

				 
		i1 = INT64_MIN_VAL;
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

	
}
