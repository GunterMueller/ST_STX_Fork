package stx.libjava.tests.lang;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class MoreThan16ArgumentsTests {

	private int sumArgs(int a1, int a2, int a3, int a4, int a5, int a6, int a7,
			int a8, int a9, int a10, int a11, int a12, int a13, int a14,
			int a15, int a16, int a17, int a18, int a19, int a20) {
		int result = a1 + a2 + a3+ a4+a5+a6+a7+a8+a9+a10+a11+a12+a13+a14+a15+a16+a17+a18+a19+a20;
		return result;
	}
	
	private int[] arrayOfArgs (int a1, int a2, int a3, int a4, int a5, int a6, int a7,
			int a8, int a9, int a10, int a11, int a12, int a13, int a14,
			int a15, int a16, int a17, int a18, int a19, int a20) {
		int [] result = new int[20];
		result[0]=a1;
		result[1]=a2;
		result[2]=a3;
		result[3]=a4;
		result[4]=a5;
		result[5]=a6;
		result[6]=a7;
		result[7]=a8;
		result[8]=a9;
		result[9]=a10;
		result[10]=a11;
		result[11]=a12;
		result[12]=a13;
		result[13]=a14;
		result[14]=a15;
		result[15]=a16;
		result[16]=a17;
		result[17]=a18;
		result[18]=a19;
		result[19]=a20;
		
		return result;
	}
	
	private int[] varargs(int ... args) {
		int[] result = new int[args.length];
		for (int i = 0; i < args.length; i++) {
			result[i] = args[i];
		}
		return result;
	}

	@Test
	public void testSumArgs() {
		int actual = sumArgs(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);
		int expected = (1+20)*10;
		assertEquals(expected, actual);
	}
	
	@Test
	public void testPositions() {
		int [] result = arrayOfArgs(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);		
		assertEquals(result[0], 1);
		assertEquals(result[1], 2);
		assertEquals(result[2], 3);
		assertEquals(result[3], 4);
		assertEquals(result[4], 5);
		assertEquals(result[5], 6);
		assertEquals(result[6], 7);
		assertEquals(result[7], 8);
		assertEquals(result[8], 9);
		assertEquals(result[9], 10);
		assertEquals(result[10], 11);
		assertEquals(result[11], 12);
		assertEquals(result[12], 13);
		assertEquals(result[13], 14);
		assertEquals(result[14], 15);
		assertEquals(result[15], 16);
		assertEquals(result[16], 17);
		assertEquals(result[17], 18);
		assertEquals(result[18], 19);
		assertEquals(result[19], 20);		
	}
	
	@Test
	public void testVarargs() {
		int[] actual = varargs(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20);
		for (int i = 0; i < 20; i++ ) {
			assertEquals(actual[i], i+1);
		}
	}
}
