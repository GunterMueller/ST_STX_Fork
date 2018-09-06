package stx.libjava.tests.mocks;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class SimpleMath {

	public static int add2To2000Expect2002() {
		int a = 2;
		int b = 2000;
		int result = a + b;
		return result;
	}
	
	public static int addMinus5ToArg(int arg) {
		return arg + (-5);
	}
	
	public static int multiply(int a, int b) {
		return a * b;
	}
	
	public static int power(int base, int exp) {
		return powerAcc(base, exp, 1);
	}
	
	public static int powerAcc(int base, int exp, int accumulator) {
		if (exp == 0) {
			return accumulator;
		}
		return powerAcc(base, exp - 1, accumulator * base);
	}
	
	public static int div(int num, int mod) {
		return num % mod;
	}
	
	public static int negateInt(int num) {
		return ~num;
	}
	
	public static int bitShiftLeft(int num, int degree) {
		return num << degree;
	}
	
	public static int bitShiftRight(int num, int degree) {
		return num >> degree;
	}
	
	public static int division(int nom, int denom) {
		return nom/denom;
	}
	
	public static int inc2(int num) {
		num++;
		++num;
		return num;
	}
	
	public static int dec2(int num) {
		num--;
		--num;
		return num;
	}
	
	public static int unsignedBitShiftRight(int num, int degree) {
		return num >>> degree;
	}
	
	public static int and(int first, int second) {
		return first & second;
	}
	
	public static int or(int first, int second) {
		return first | second;
	}
	
	public static int xor(int first, int second) {
		return first ^ second;
	}
	
	public static void justUseConstants() {
		long l0 = 0l;
		long l1 = 1l;
		float f0 = 0;
		float f1 = 1;
		float f2 = 2;
		double d0 = 0;
		double d1 = 1;
	}
	
	public static int isYourStackCreatedCorrectly() {
		int a = 0;
		int b = 1;
		a = 2;
		b = 3;
		a = 4;
		a = 5;
		b = 6;
		a = 7;
		b = 8;
		b = 9;
		return a;
	}
	
	public static double isYourStackCreatedCorrectlyEvenWithDoublesAndLongs() {
		double a = 0;
		long b = 1;
		a = 2;
		b = 3;
		a = 4;
		a = 5;
		b = 6;
		a = 7;
		b = 8;
		b = 9;
		return a;
	}
	
	public static int sumArray(int[] array) {
		int result = 0;
		for (int i = 0; i < array.length; i++) {
			result += array[i];
		}
		return result;
	}
	
	public static double sumArrayOfDoubles(double[] array) {
		double result = 0;
		for (int i = 0; i < array.length; i++) {
			result += array[i];
		}
		return result;
	}
	
	public static long[] giveMeArrayOfLongs() {
		
		return new long[100];
	}
	
	public static void main(String[] args) {
		System.out.println("add2To2000Expect2002 returned: " + add2To2000Expect2002());
		System.out.println("addMinus5ToArg with 10 returned: " + addMinus5ToArg(10));
		System.out.println("multiply with 10 and 20 returned: " + multiply(10, 20));
		System.out.println("power with 2 and 10 returned: " + power(2, 10));
	}
	
}
