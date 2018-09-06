package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

public class ARRAYLENGTH {

	@Test
	public void test() {
		int l;
		int[] i_arr = null;
		
		try {
			l = i_arr.length;
			fail();
		} catch (NullPointerException npe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		byte[] b_arr = null;
		
		try {
			l = b_arr.length;
			fail();
		} catch (NullPointerException npe) {
			// OK
		} catch (Exception e) {
			fail();
		}

	}

}
