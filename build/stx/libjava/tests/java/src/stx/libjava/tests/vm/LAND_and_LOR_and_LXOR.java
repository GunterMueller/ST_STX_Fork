package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

public class LAND_and_LOR_and_LXOR {
	final static long LONG_MASK = 0xffffffffL;

	@Test
	public void test_regression_01() {
		int dl = 1517774901;		
		assertEquals(1517774901, dl & LONG_MASK);
		
		int qhat = 234233353;
		assertEquals(234233353, qhat & LONG_MASK);
	}

}
