package stx.libjava.benchmarks;

public class OverloadedMethods2 {

	public OverloadedMethods2 doSmth(int i) {
		return this;
	}

	public OverloadedMethods2 doSmth(float i) {
		return this;
	}

	public OverloadedMethods2 doSmth(String i) {
		return this;
	}

	public OverloadedMethods2 doSmth(Object i) {
		return this;
	}

	public OverloadedMethods2 doSmth(OverloadedMethods2 i) {
		return this;
	}

	public OverloadedMethods2 doSmth(char i) {
		return this;
	}

	public OverloadedMethods2 doSmth(byte i) {
		return this;
	}

	public OverloadedMethods2 doSmth(short i) {
		return this;
	}

	public OverloadedMethods2 doSmth(boolean i) {
		return this;
	}

	public static void main(String args[]) {		
		int n = Integer.parseInt(args[0]);
		runBenchmarkJ(n);
		long time = runBenchmarkJ(n);
		System.out.println("EXECUTION TIME: " + time);
    }

	public static long runBenchmarkJ(int n) {
		OverloadedMethods2 inst = new OverloadedMethods2();
		Object o = new Object();
		long start = System.currentTimeMillis();
		for (int i = 0; i < n; i++) {
			inst.doSmth(0);
			inst.doSmth(1.12345);
			inst.doSmth(o);
			inst.doSmth("");
			inst.doSmth('c');
			inst.doSmth(1);
			inst.doSmth(false);
		}
		long end = System.currentTimeMillis();
		long time = end - start;
		return time;
	}
}
