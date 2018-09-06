package stx.libjava.tests.lang;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class FloatAndDoubleTests {

	@Test
	public void test() {
		double f1 = Double.MAX_VALUE;		
		String s = Double.toString(f1);
		double f2 = Double.valueOf(s);
		assertTrue(f1 == f2);
	}
	
	@Test 	
	public void test_doubleToRawLongBits_and_longBitsToDouble() {		
		long l;
		double d;
				
		l = Double.doubleToRawLongBits(0.0D);
		assertEquals(0L, l);
		d = Double.longBitsToDouble(l);
		assertTrue(0.0D == d);
		
		l = Double.doubleToRawLongBits(0.1D);		
		assertEquals(4591870180066957722L, l);
		d = Double.longBitsToDouble(l);
		assertTrue(0.1D == d);
		
		l = Double.doubleToRawLongBits(3.14159D);		
		assertEquals(4614256650576692846L, l);
		d = Double.longBitsToDouble(l);
		assertTrue(3.14159D == d);
		
		l = Double.doubleToRawLongBits(Double.MAX_VALUE);		
		assertEquals(9218868437227405311L, l);
		d = Double.longBitsToDouble(l);
		assertTrue(Double.MAX_VALUE == d);
		
		l = Double.doubleToRawLongBits(Double.MIN_VALUE);		
		assertEquals(1L, l);
		d = Double.longBitsToDouble(l);
		assertTrue(Double.MIN_VALUE == d);
		
		l = Double.doubleToRawLongBits(Double.NaN);		
		assertEquals(9221120237041090560L, l);		
	}
	
	@Test 	
	public void test_floatToRawIntBits_and_intBitsToFloat() {		
		int i;
		float d;
				
		i = Float.floatToRawIntBits(0.0F);
		assertEquals(0, i);
		d = Float.intBitsToFloat(i);
		assertTrue(0.0F == d);
		
		i = Float.floatToRawIntBits(0.1F);		
		assertEquals(1036831949, i);
		d = Float.intBitsToFloat(i);
		assertTrue(0.1F == d);
		
		i = Float.floatToRawIntBits(3.14159F);		
		assertEquals(1078530000, i);
		d = Float.intBitsToFloat(i);
		assertTrue(3.14159F == d);
		
		i = Float.floatToRawIntBits(Float.MAX_VALUE);		
		assertEquals(2139095039, i);
		d = Float.intBitsToFloat(i);
		assertTrue(Float.MAX_VALUE == d);
		
		i = Float.floatToRawIntBits(Float.MIN_VALUE);		
		assertEquals(1, i);
		d = Float.intBitsToFloat(i);
		assertTrue(Float.MIN_VALUE == d);
		
		i = Float.floatToRawIntBits(Float.NaN);		
		assertEquals(2143289344, i);		
	}

}
