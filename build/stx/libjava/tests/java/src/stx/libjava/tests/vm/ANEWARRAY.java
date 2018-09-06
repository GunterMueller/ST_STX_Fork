package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

public class ANEWARRAY {

	@Test
	public void test_bounds_01() {
		Object[] arr;
		Object o;		
		arr = new Object[10];
		
		try {
			o = arr[-1];
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		arr = new Object[10];
		try {
			arr[-1] = new Object();
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		try {
			o = arr[11];
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		arr = new Object[10];
		try {
			arr[11] = new Object();
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	@Test
	public void test_negative_size_01() {
		Object[] arr;
		try {
			arr = new Object[-1];
		} catch (NegativeArraySizeException nase) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
}
