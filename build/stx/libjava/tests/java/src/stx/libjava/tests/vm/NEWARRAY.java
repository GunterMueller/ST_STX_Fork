package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

public class NEWARRAY {

	@Test
	public void test_bounds_boolean() {
		boolean[] arr;
		boolean o;		
		arr = new boolean[10];
		
		try {
			o = arr[-1];
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		arr = new boolean[10];
		try {
			arr[-1] = false;
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
		
		arr = new boolean[10];
		try {
			arr[11] = false;
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	@Test
	public void test_negative_size_boolean() {
		boolean[] arr;
		try {
			arr = new boolean[-1];
		} catch (NegativeArraySizeException nase) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	
	// === char ====
	@Test
	public void test_bounds_char() {
		char[] arr;
		char o;		
		arr = new char[10];
		
		try {
			o = arr[-1];
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		arr = new char[10];
		try {
			arr[-1] = '0';
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
		
		arr = new char[10];
		try {
			arr[11] = '0';
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	@Test
	public void test_negative_size_char() {
		char[] arr;
		try {
			arr = new char[-1];
		} catch (NegativeArraySizeException nase) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	// === byte ====
	@Test
	public void test_bounds_byte() {
		byte[] arr;
		byte o;		
		arr = new byte[10];
		
		try {
			o = arr[-1];
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
		
		arr = new byte[10];
		try {
			arr[-1] = 0;
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
		
		arr = new byte[10];
		try {
			arr[11] = 0;
			fail();
		} catch (ArrayIndexOutOfBoundsException abe) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	@Test
	public void test_negative_size_byte() {
		byte[] arr;
		try {
			arr = new byte[-1];
		} catch (NegativeArraySizeException nase) {
			// OK
		} catch (Exception e) {
			fail();
		}
	}
	
	// === short ====
		@Test
		public void test_bounds_short() {
			short[] arr;
			short o;		
			arr = new short[10];
			
			try {
				o = arr[-1];
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
			
			arr = new short[10];
			try {
				arr[-1] = 0;
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
			
			arr = new short[10];
			try {
				arr[11] = 0;
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		@Test
		public void test_negative_size_short() {
			short[] arr;
			try {
				arr = new short[-1];
			} catch (NegativeArraySizeException nase) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		// === int ====
		@Test
		public void test_bounds_int() {
			int[] arr;
			int o;		
			arr = new int[10];
			
			try {
				o = arr[-1];
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
			
			arr = new int[10];
			try {
				arr[-1] = 0;
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
			
			arr = new int[10];
			try {
				arr[11] = 0;
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		@Test
		public void test_negative_size_int() {
			int[] arr;
			try {
				arr = new int[-1];
			} catch (NegativeArraySizeException nase) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		// === long ====
		@Test
		public void test_bounds_long() {
			long[] arr;
			long o;		
			arr = new long[10];
			
			try {
				o = arr[-1];
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
			
			arr = new long[10];
			try {
				arr[-1] = 0;
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
			
			arr = new long[10];
			try {
				arr[11] = 0;
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		@Test
		public void test_negative_size_long() {
			long[] arr;
			try {
				arr = new long[-1];
			} catch (NegativeArraySizeException nase) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		// === float ====
		@Test
		public void test_bounds_float() {
			float[] arr;
			float o;		
			arr = new float[10];
			
			try {
				o = arr[-1];
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
			
			arr = new float[10];
			try {
				arr[-1] = 0;
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
			
			arr = new float[10];
			try {
				arr[11] = 0;
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		@Test
		public void test_negative_size_float() {
			float[] arr;
			try {
				arr = new float[-1];
			} catch (NegativeArraySizeException nase) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		// === double ====
		@Test
		public void test_bounds_double() {
			double[] arr;
			double o;		
			arr = new double[10];
			
			try {
				o = arr[-1];
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
			
			arr = new double[10];
			try {
				arr[-1] = 0;
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
			
			arr = new double[10];
			try {
				arr[11] = 0;
				fail();
			} catch (ArrayIndexOutOfBoundsException abe) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}
		
		@Test
		public void test_negative_size_double() {
			double[] arr;
			try {
				arr = new double[-1];
			} catch (NegativeArraySizeException nase) {
				// OK
			} catch (Exception e) {
				fail();
			}
		}		
}
